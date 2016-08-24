//
//  ViewController.m
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "RestClient.h"
#import "HomeCatagoryResModel.h"
#import "HomeCatagoryCell.h"
#import "CenterViewController.h"
#import "SignInDetailHandler.h"
//#import "SVProgressHUD/SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "AppointmentsViewController.h"
#import "ContactUsViewController.h"
#import "SettingsViewController.h"
#import "AppointmentsViewController.h"
#import "SettingsViewController.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,CLLocationManagerDelegate>{
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    RestClient *restClient;
    
}

@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic, assign) BOOL isMenuOPen;
@property (nonatomic, weak) IBOutlet UIView *menuContainerView;
@property (nonatomic, weak) IBOutlet UIView *layerView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *categoryListArr;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *menuConstaraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *itemCellWidth;
@property (nonatomic, strong) MenuViewController *menuController;
@property (nonatomic, strong) SignInDetailHandler *signInHandler;

@property (nonatomic, weak) IBOutlet UILabel *headerLbl;

- (IBAction)clickOnLeftMenu:(id)sender;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, retain) CLLocationManager *locationMgr;
@property (nonatomic, strong)CLGeocoder *geoCoder;
@end

@implementation ViewController

- (void)viewDidLoad {
    self.geoCoder = [[CLGeocoder alloc] init];
     restClient=[[RestClient alloc]init];
    [super viewDidLoad];
    self.headerLbl.font = [UIFont fontWithName:@"Pacifico" size:24];
    menuItemTitleLbl.font = [UIFont fontWithName:@"Pacifico" size:24];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnGesture:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:recognizer];

//    [SVProgressHUD showWithStatus:@"Updating" maskType:SVProgressHUDMaskTypeBlack];
    self.signInHandler = [SignInDetailHandler sharedInstance];
    [self.view bringSubviewToFront:self.menuContainerView];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    [self callGetCategoryList];
    
    if ([self.locationMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationMgr requestWhenInUseAuthorization];
    }
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidSelectLocation:) name:@"DidSelectLocation" object:nil];

    if (self.signInHandler.isSignin) {
        [self.menuController reloadData];
    }
     [self setUpLocationService];
}

- (void)DidSelectLocation:(NSNotification *)sender {
    NSDictionary *dict = sender.object;
    [self.locationBTN setTitle:dict[@"locationName"] forState:UIControlStateNormal];
}

- (void)callGetCategoryList {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the determinate mode to show task progress.
//    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
if ([restClient rechabilityCheck]) {
    [restClient getHomeCategoryList:^(NSArray *catList, NSError *error) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [hud hideAnimated:YES];

        if (!error) {
                self.categoryListArr = catList;

                [self.collectionView reloadData];
//                [hud hideAnimated:YES];
            NSLog(@"%@",catList);
        }
        });

    }];
}
}

- (void)callLogOutFunctionality {
    
    self.signInHandler.isSignin = NO;
//    if (self.signInHandler.isSignin) {
//    }
//    [self animateLeftMenu];
//    [self performSelector:@selector(animateLeftMenu) withObject:nil afterDelay:0.1];

    self.signInHandler.loginResModel = nil;
    self.signInHandler.accessToken = nil;
    self.signInHandler.userId = nil;
    [self performSelector:@selector(reloadLeftMenu) withObject:nil afterDelay:1.0];
//

    
    
//    [RestClient logout:[NSNumber numberWithInt:1] callBackHandler:^(NSDictionary *res, NSError *error) {
//        [self animateLeftMenu];
//        [self callGetCategoryList];
//    }];
    
   NSString* errorMsg = @"Your Successfully Logged Out";
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:errorMsg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                         }];
    [view addAction:ok];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)reloadLeftMenu {
    [self.menuController reloadData];

}

- (IBAction)clickOnLeftMenu:(id)sender {
    [self animateLeftMenu];

}

- (IBAction)tapOnGesture:(id)sender;{
    [self animateLeftMenu];
}

- (void)animateLeftMenu {
    [self.view layoutIfNeeded];
    float layerAlphaVal ;
    if (self.isMenuOPen) {
        self.menuConstaraint.constant = -290;
        layerAlphaVal = 0;
    }else{
        self.menuConstaraint.constant = 0;
        layerAlphaVal = 0.7f;
    }
    
    self.isMenuOPen = !self.isMenuOPen;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.layerView.alpha = layerAlphaVal;
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

- (void)didSelectMenuItem:(NSIndexPath *)indexPath {
    
    MenuItemContainerView.hidden=YES;
    menuItemTitleView.hidden=YES;
    [self animateLeftMenu];
    if (self.signInHandler.isSignin) {
        if (indexPath.row == 6) {
            [self callLogOutFunctionality];
        }else if (indexPath.row ==1){
            AppointmentsViewController *appointmentsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"appointments"];
            [self showViewControllerInContainerView:appointmentsViewController];
            MenuItemContainerView.hidden=NO;
            menuItemTitleView.hidden=NO;
            menuItemTitleLbl.text=@"Appointments";
           
        }else if (indexPath.row ==2){
            
        }else if (indexPath.row==3){
            SettingsViewController *settingsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            [self showViewControllerInContainerView:settingsViewController];
           MenuItemContainerView.hidden=NO;
            menuItemTitleView.hidden=NO;
            menuItemTitleLbl.text=@"Settings";
           
        }else if (indexPath.row==4){
            
        }else if (indexPath.row==5){
            
            ContactUsViewController *contactUsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            [self showViewControllerInContainerView:contactUsViewController];
            
           MenuItemContainerView.hidden=NO;
            menuItemTitleView.hidden=NO;
            menuItemTitleLbl.text=@"Contact Us";
 
        }
    }else{
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"signVC" sender:nil];
        }else if (indexPath.row ==1){
            
        }else if (indexPath.row ==2){
            MenuItemContainerView.hidden=NO;
            ContactUsViewController *contactUsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            [self showViewControllerInContainerView:contactUsViewController];

        }
    }
    
}
-(void)showViewControllerInContainerView:(UIViewController *)viewController{
    [self addChildViewController:viewController];                 // 1
    viewController.view.frame = MenuItemContainerView.bounds;
    
    MenuItemContainerView.backgroundColor=[UIColor redColor];
    //2
    [MenuItemContainerView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];

    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCatagoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    HomeCatagoryResModel *model = self.categoryListArr[indexPath.row];
    
//    cell.imgView.image = [UIImage imageNamed:@"moodboard_4"];
    cell.titleLbl.text = model.name;
    [RestClient loadImageinImgView:cell.imgView withUrlString:model.image];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeCatagoryCell *cell = (HomeCatagoryCell *) [collectionView cellForItemAtIndexPath:indexPath];

    CGSize size ;
    
    CGFloat widthOfCell=(self.view.frame.size.width-30)/2;
    CGFloat heightOfCell=(self.view.frame.size.height-150)/2;
    size=CGSizeMake(widthOfCell, heightOfCell);
//    if (self.view.frame.size.width == 320) {
//        size = CGSizeMake(145, 205);
//    }else if (self.view.frame.size.width == 375) {
//        size = CGSizeMake(170, 250);
//    }else if (self.view.frame.size.width == 414) {
//        size = CGSizeMake(190, 270);
//    }

    return size;
}

//#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10); // top, left, bottom, right
}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    
//    return 0.0;
//}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10.0;
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCatagoryResModel *model = self.categoryListArr[indexPath.row];
    [self performSegueWithIdentifier:@"CenterVC" sender:model];
}

//func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
//{
//    let cellSpacing = CGFloat(2) //Define the space between each cell
//    let leftRightMargin = CGFloat(20) //If defined in Interface Builder for "Section Insets"
//    let numColumns = CGFloat(3) //The total number of columns you want
//    
//    let totalCellSpace = cellSpacing * (numColumns - 1)
//    let screenWidth = UIScreen.mainScreen().bounds.width
//    let width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
//    let height = CGFloat(110) //whatever height you want
//    
//    return CGSizeMake(width, height);
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout*)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    int cellspace = 5;
//    int leftRightMargin = 5;
//    int numColums = 2;
//    
//    int totalCellSpace = cellspace * (numColums - 1);
//    int screenWidth = [UIScreen mainScreen].bounds.size.width;
//    int width = (screenWidth - leftRightMargin - totalCellSpace) / numColums;
//    int height = 260;
//    HomeCatagoryCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
//
//    return CGSizeMake(width, height);
//}
//
////- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
////    return 10.0;
////}
//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
//    return UIEdgeInsetsMake(10,0,10,10);  // top, left, bottom, right
//}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(50, 50);
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MenuLeftVC"]) {
        self.menuController = segue.destinationViewController;
        self.menuController.menuDelegate = self;
    }else if ([segue.identifier isEqualToString:@"CenterVC"]) {
            CenterViewController *controller = segue.destinationViewController;
            controller.categoryModel = sender;
    }else if ([segue.identifier isEqualToString:@"appointmentView"]){
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)setUpLocationService {
    _locationMgr = [[CLLocationManager alloc] init];
    _locationMgr.delegate=self;
    _locationMgr.desiredAccuracy=kCLLocationAccuracyBest;
    _locationMgr.distanceFilter=kCLDistanceFilterNone;
    [_locationMgr requestWhenInUseAuthorization];
    [_locationMgr startMonitoringSignificantLocationChanges];
    [_locationMgr startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    
    NSLog(@"%@",error);
}



@end
