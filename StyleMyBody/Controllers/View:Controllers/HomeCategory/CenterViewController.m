//
//  CenterViewController.m
//  StyleMyBody
//
//  Created by sipani online on 4/14/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "CenterViewController.h"
#import "NearByCentersViewController.h"
#import "RecentCenterViewController.h"
#import "OfferCenterViewController.h"
#import "CAPSPageMenu.h"
#import "RestClient.h"
#import "CenterListResModel.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "DetailCenterViewController.h"
#import "AllStylistAndServicesInGroupViewController.h"
#import "SignInDetailHandler.h"
#import "SignViewController.h"
#import "OfferFullDetailsViewController.h"
#import "SearchAndFilterModel.h"
#import "FilterView.h"

@interface CenterViewController () <CLLocationManagerDelegate>{
    RestClient *restClient;
    SearchAndFilterModel *searchModel;
}
@property (nonatomic) CAPSPageMenu *pageMenu;
@property (nonatomic) NSMutableArray *recentCenterListArr;
@property (nonatomic) NSArray *nearCenterListArr;
@property (nonatomic) NearByCentersViewController *nearByController;
@property (nonatomic) RecentCenterViewController *recentController;
@property (nonatomic) OfferCenterViewController *offersController;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic, retain) CLLocationManager *locationMgr;
@property (nonatomic, retain) CLLocation *lastLocation;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    restClient=[[RestClient alloc]init];

    self.headerLbl.font = [UIFont fontWithName:@"Pacifico" size:24];
  //  self.headerLbl.text = self.categoryModel.name;
    self.appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if ([self.locationMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationMgr requestWhenInUseAuthorization];
    }
    
    searchModel=[[SearchAndFilterModel alloc]init];
    searchModel.categoryId=self.categoryModel.categoryId;
    searchModel.Id=self.autoSearchModel.centerID;
    searchModel.search=self.autoSearchModel.search;
    searchModel.type=self.autoSearchModel.type;
    
  //  [self setupCenterViewController];

    
}
-(void)setupCenterViewController{
    
    [self getCenterList];
    self.nearByController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"NearByVC"];
    self.nearByController.title = @"NEAREST";
    //    nearByController.categoryModel = self.categoryModel;
    
    self.recentController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"RecentVC"];
    self.recentController.title = @"RECENT";
    self.recentController.categoryModel = self.categoryModel;
    //    nearByController.categoryModel = self.categoryModel;
    
    
    self.offersController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"OffersVC"];
    self.offersController.title = @"OFFERS";
    if (!_autoSearchModel) {
        self.offersController.categoryId=[NSNumber numberWithInteger:[_categoryModel.categoryId integerValue]];
    }else{
        
        self.offersController.centerId=searchModel.Id;
    }
    
    self.offersController.isBookNowNeeded=NO;
    
    NSArray *controllerArray = @[self.nearByController, self.recentController, self.offersController];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:255.0/255.0 green:105.0/255.0 blue:66.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithRed:232.0/255.0 green:223.0/255.0 blue:23.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:238.0/255.0 green:241.0/255.0 blue:246.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:14.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @((self.view.bounds.size.width/3)-40),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [self.view addSubview:_pageMenu.view];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCell:) name:@"DidSelectCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectBookNow:) name:@"DidSelectBookNow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectFevNow:) name:@"FevSelectNow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCenterData) name:@"ReloadViewData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OfferSelected:) name:@"OfferSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SearchModified:) name:@"SearchModified" object:nil];
    
    [self setUpLocationService];
    [self setupCenterViewController];
}
-(IBAction)SearchModified:(NSNotification*)sender{
    searchModel=sender.object;

    [self setupCenterViewController];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpLocationService {
    _locationMgr = [[CLLocationManager alloc] init];
    _locationMgr.delegate=self;
    _locationMgr.desiredAccuracy=kCLLocationAccuracyBest;
    _locationMgr.distanceFilter=kCLDistanceFilterNone;
    [_locationMgr requestWhenInUseAuthorization];
    [_locationMgr startMonitoringSignificantLocationChanges];
    [_locationMgr startUpdatingLocation];
}

- (void)getCenterList {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");

    
    if ([restClient rechabilityCheck]) {
    [restClient getCenterList:searchModel callBackRes:^(NSArray *centerList, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nearCenterListArr = centerList;
            [self getRecentCenters];
            self.nearByController.nearByCenterListModel = self.recentCenterListArr;
//            self.recentController.recentCenterListModel = self.recentCenterListArr;
            [self.nearByController.tableView reloadData];

            [hud hideAnimated:YES];
        });
        
    }];
    }
}


- (void)getRecentCenters {
    self.recentCenterListArr = [self.nearCenterListArr mutableCopy]; // your mutable copy of the fetched objects
    
    for (CenterListResModel *model in self.recentCenterListArr) {
        CLLocationDegrees lat = [model.latitude doubleValue];
        CLLocationDegrees lng = [model.longitude doubleValue];
        CLLocation *houseLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        CLLocationDistance meters = [houseLocation distanceFromLocation:self.currentLocation];
        model.currentDistance = @(meters/1000);
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"currentDistance" ascending:YES];
    [self.recentCenterListArr sortUsingDescriptors:@[sort]];
}

- (IBAction)clickOnBack:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}


- (void)didSelectCell:(NSNotification *)sender {
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:indexPath,@"indexPath",@"NearBy",@"FromView", nil];
        NSDictionary *dict = sender.object;
        [self performSegueWithIdentifier:@"detailCenter" sender:dict];
    
}
-(void)OfferSelected:(NSNotification *)sender{
    NSDictionary *dict = sender.object;
    [self performSegueWithIdentifier:@"offerFullDetails" sender:dict];
}
- (void)didSelectBookNow:(NSNotification *)sender {
    NSDictionary *dict = sender.object;
    
    SignInDetailHandler *dataHandler = [SignInDetailHandler sharedInstance];
    
    if (dataHandler.isSignin == YES) {
        
        AllStylistAndServicesInGroupViewController *serviceVC = (AllStylistAndServicesInGroupViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AllStylistAndServicesInGroupViewController"];
        NSIndexPath *indexPath = dict[@"indexPath"];
        CenterListResModel *model = [self.nearByController.nearByCenterListModel objectAtIndex:indexPath.row];
        serviceVC.headerTitle = model.displayName;
        serviceVC.centerId = model.centerId;
        [self.navigationController pushViewController:serviceVC animated:YES];

    }else{
        
        
        SignViewController *vc = [[UIStoryboard storyboardWithName:@"LoginFlow" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SIgnVC"];
        vc.viewFrom = FromOther;
        NSLog(@"%lu",(unsigned long)vc.viewFrom);
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)didSelectFevNow:(NSNotification *)sender {
   
    NSDictionary *dict = sender.object;
    [self setFevToItem:dict];
}

- (void)setFevToItem:(NSDictionary *)dict {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    NSIndexPath *indexPath = dict[@"indexPath"];

    CenterListResModel *model = [self.nearByController.nearByCenterListModel objectAtIndex:indexPath.row];

    if ([restClient rechabilityCheck]) {
    [restClient setFev:model.centerId isFev:dict[@"IsFev"] callBackRes:^(NSString *resStr, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getCenterList];
            [hud hideAnimated:YES];
        });
    }];
    }
    }

- (void)reloadCenterData {
    [self getCenterList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *dict = sender;
    NSIndexPath *indexPath = dict[@"indexPath"];
    if ([dict[@"FromView"] isEqual:@"NearBy"]) {
        DetailCenterViewController *detailCenterVC = segue.destinationViewController;
        detailCenterVC.headerTitleStr = self.headerLbl.text;
        detailCenterVC.selectedCenterItemModel = [self.nearByController.nearByCenterListModel objectAtIndex:indexPath.row];
        NSLog(@"%@",detailCenterVC.selectedCenterItemModel.displayName);
    }else if ([dict[@"FromView"] isEqual:@"OfferView"]){
        OfferFullDetailsViewController *detailCenterVC = segue.destinationViewController;
        detailCenterVC.offerId=[dict valueForKey:@"offerId"];
        detailCenterVC.offerType=[dict valueForKey:@"offerType"];
       // NSLog(@"%@",detailCenterVC.selectedCenterItemModel.displayName);
    }else if ([segue.identifier isEqualToString:@"FilterView"]){
        FilterView *filterView = segue.destinationViewController;
        filterView.searchAndFilterModel=searchModel;
       // filterView.offerType=[dict valueForKey:@"offerType"];
        // NSLog(@"%@",detailCenterVC.selectedCenterItemModel.displayName);
    }


}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        self.currentLocation = newLocation;
        self.appDelegate.currentLocation = newLocation;
    }
    if (self.currentLocation == newLocation) {
        [self.locationMgr stopUpdatingLocation];
    }
    [self getGoogleAdrressFromLatLong:newLocation.coordinate.latitude lon:newLocation.coordinate.longitude];
    
}
-(void)getGoogleAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    //[self showLoadingView:@"Loading.."];
    NSError *error = nil;
    
    NSString *lookUpString  = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false", lat,lon];
    
    lookUpString = [lookUpString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSData *jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:lookUpString]];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    
    // NSLog(@"%@",jsonDict);
    
    NSArray* jsonResults = [jsonDict objectForKey:@"results"];
    NSDictionary *dict=[jsonResults objectAtIndex:0];
    NSArray *adDict=[dict valueForKey:@"address_components"];
    NSString *formatedAddress=[NSString stringWithFormat:@"%@,%@",[[adDict objectAtIndex:2] valueForKey:@"short_name"],[[adDict objectAtIndex:3]valueForKey:@"short_name"]];
    [_locationBTN setTitle:formatedAddress forState:UIControlStateNormal];
    // NSLog(@"%@",jsonResults);
    
    //    "long_name" = "Araka Mico Layout";
    //    "short_name" = "Araka Mico Layout";
}
-(IBAction)filterBtnACtion:(id)sender{
    [self performSegueWithIdentifier:@"FilterView" sender:nil];
}

@end
