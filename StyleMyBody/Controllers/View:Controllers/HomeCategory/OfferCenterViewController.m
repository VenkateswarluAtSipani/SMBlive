//
//  OfferCenterViewController.m
//  PageMenuDemoStoryboard
//
//  Created by sipani online on 4/14/16.
//  Copyright © 2016 Jin Sasaki. All rights reserved.
//

#import "OfferCenterViewController.h"
#import "RestClient.h"
#import "OffersListResModel.h"
#import "OffersCell.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "OfferFullDetailsViewController.h"

@interface OfferCenterViewController ()<UITableViewDelegate,CLLocationManagerDelegate>{
    RestClient *restClient;
}

@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic, strong) NSArray *offersListArr;
@property (nonatomic) NSMutableArray *nearestOffersArray;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bookNowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfBookNowView;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, retain) CLLocationManager *locationMgr;

@end

@implementation OfferCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     restClient=[[RestClient alloc]init];
    self.appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self callGetOffers];
    if (self.isBookNowNeeded) {
        _bookNowView.hidden=NO;
        _heightOfBookNowView.constant=50;
    }else{
        _bookNowView.hidden=YES;
        _heightOfBookNowView.constant=0;
    }
    if ([self.locationMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationMgr requestWhenInUseAuthorization];
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self setUpLocationService];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)callGetOffers {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    if ([restClient rechabilityCheck]) {
    [restClient getAllOffersList:_categoryId withCenterId:self.centerId callBackRes:^(NSArray *centerList, NSError *error) {
        NSLog(@"%@ === %@",centerList,error);
        if (centerList.count==0) {
            self.tableView .hidden=YES;
        }
        self.offersListArr = centerList;
        [self getnearestOffers];
        self.offersListArr=self.nearestOffersArray;
        [self.tableView reloadData];
        [hud hideAnimated:YES];
    }];
    }
}
- (void)getnearestOffers {
    self.nearestOffersArray = [self.offersListArr mutableCopy]; // your mutable copy of the fetched objects
    for (OffersListResModel *offerModel in self.nearestOffersArray) {
        CLLocationDegrees lat = [offerModel.centerLatitude doubleValue];
        CLLocationDegrees lng = [offerModel.centerLongitude doubleValue];
        CLLocation *houseLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        CLLocationDistance meters = [houseLocation distanceFromLocation:self.currentLocation];
        offerModel.currentDistance = @(meters/1000);
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"currentDistance" ascending:YES];
    [self.nearestOffersArray sortUsingDescriptors:@[sort]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.offersListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    OffersListResModel *model = self.offersListArr[indexPath.row];
    
    OffersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleLbl.text = model.centerName;
    cell.distanceLbl.text = [NSString stringWithFormat:@"%@ kms away",[Utility getDistanceFromLocations:appDelegate.currentLocation :[[CLLocation alloc]initWithLatitude:[model.centerLatitude doubleValue] longitude:[model.centerLongitude doubleValue]] ]];
   
    cell.discountTitleLbl.text = [NSString stringWithFormat:@"%@",model.title];
    NSString *offerType;
    if ([model.offerId integerValue]==-1) {
        offerType=@"package";
    }else{
        offerType=@"offer";
    }

    NSDictionary *offerDict =[self getOfferStrToDisplay:offerType for:model];
    if ([offerType isEqualToString:@"offer"]) {
      cell.offerTypeLbl.text = [offerDict valueForKey:@"subTitle" ];
    }else{
        cell.offerTypeLbl.attributedText = [offerDict valueForKey:@"subTitle" ];
    }
    
    cell.expiryLbl.text = [offerDict valueForKey:@"expire"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (model.image.length>0 ){
        [RestClient loadImageinImgView:cell.imgView withUrlString:model.image];
    }else{
        cell.imgView.image=[UIImage imageNamed:@"Sample-1"];
    }
       cell.selectionStyle=UITableViewCellEditingStyleNone;
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OffersListResModel *model = self.offersListArr[indexPath.row];
    NSNumber *offerId=model.offerId;
    NSString *offerType;
    if ([offerId integerValue]==-1) {
        offerId=model.packageId;
        offerType=@"package";
    }else{
        offerType=@"offer";
    }
    
    NSLog(@"%@",model.offerId);
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:offerId,@"offerId",indexPath,@"indexPath",@"OfferView",@"FromView",offerType,@"offerType", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OfferSelected" object:dict];
    
    //[[NSUserDefaults standardUserDefaults]setObject:model.offerId forKey:@"selectedOfferId"];
  
}
- (NSString *)getDateWithSpecificFormat:(NSString *)date {
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    NSDate *dateVal = [format dateFromString:date];
    
    format.dateFormat = @"dd MMMM yyyy";
    
    return [format stringFromDate:dateVal];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"offerFullDetails"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        OfferFullDetailsViewController *offerDetailVC = segue.destinationViewController;
        offerDetailVC.offerDetailmodel = self.offersListArr[indexPath.row];
    }
}

     // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

-(NSDictionary*)getOfferStrToDisplay:(NSString*)type for:(OffersListResModel *)offerFullDetailModel {
    
    NSString *subTitleLbltext=@"";
    NSString *exPiresStr;
    NSString *rupee=@"\u20B9";
    if ([type isEqualToString:@"offer"]) {
        
        if ([offerFullDetailModel.offerCategory integerValue]==1) {
            
            subTitleLbltext=[NSString stringWithFormat:@"%@ %@ Off",rupee,offerFullDetailModel.offerTypeValue];
            exPiresStr=[NSString stringWithFormat:@"Expires on %@",[self getDateWithSpecificFormat:offerFullDetailModel.endValue ]];
           
        }else if ([offerFullDetailModel.offerCategory integerValue]==2) {
            
            subTitleLbltext=[NSString stringWithFormat:@"%@ %@ Off",rupee,offerFullDetailModel.offerTypeValue];
            exPiresStr=[NSString stringWithFormat:@"Expires on %@",[self getDateWithSpecificFormat: offerFullDetailModel.endValue ]];
        
        }else if ([offerFullDetailModel.offerCategory integerValue]==3) {
            
            subTitleLbltext=[NSString stringWithFormat:@"%@ %% Off",offerFullDetailModel.offerTypeValue];
            if ([offerFullDetailModel.endType integerValue]==1) {
                exPiresStr=[NSString stringWithFormat:@"Expires on %@",[self getDateWithSpecificFormat: offerFullDetailModel.endValue ]];
                
            }else if ([offerFullDetailModel.endType integerValue]==2){
                exPiresStr=[NSString stringWithFormat:@"Valid for %@ persons",offerFullDetailModel.endValue];
           
                
            }
            
        }else if ([offerFullDetailModel.offerCategory integerValue]==4) {
            subTitleLbltext=[NSString stringWithFormat:@"Flat %@ %% Off",offerFullDetailModel.offerTypeValue];
            if ([offerFullDetailModel.endType integerValue]==1) {
                exPiresStr=[NSString stringWithFormat:@"Expires on %@",[self getDateWithSpecificFormat: offerFullDetailModel.endValue ]];
                
            }else if ([offerFullDetailModel.endType integerValue]==2){
                exPiresStr=[NSString stringWithFormat:@"Valid For %@ persons",offerFullDetailModel.endValue];
            }
        }
        
    }else{
        
        NSLog(@"%@",offerFullDetailModel.endType);
        NSString *price=[NSString stringWithFormat:@"%@",offerFullDetailModel.price];
        
        subTitleLbltext=[NSString stringWithFormat:@"%@ %@  %@ %@",rupee,offerFullDetailModel.discountedPrice,rupee,price];
       NSMutableAttributedString* PackageAttributeString = [[NSMutableAttributedString alloc] initWithString:subTitleLbltext];
        NSRange rangeOfPrise=NSMakeRange(PackageAttributeString.length-([price length]+2), [price length]+2);
        
        [PackageAttributeString addAttribute:NSStrikethroughStyleAttributeName
                                       value:@2
                                       range:rangeOfPrise];
        
        [PackageAttributeString addAttribute: NSFontAttributeName value:  [UIFont fontWithName:@"Helvetica" size:15] range: rangeOfPrise];
        [PackageAttributeString addAttribute:NSForegroundColorAttributeName
                                       value:[UIColor lightGrayColor]
                                       range:rangeOfPrise];
        if ([offerFullDetailModel.endType integerValue]==1) {
            exPiresStr=[NSString stringWithFormat:@"Expires on %@",[self getDateWithSpecificFormat: offerFullDetailModel.endValue ]];
        }else if ([offerFullDetailModel.endType integerValue]==2){
            exPiresStr=[NSString stringWithFormat:@"Valid for %@ persons",offerFullDetailModel.endValue];
        }
        
        NSDictionary *packageDict=[NSDictionary dictionaryWithObjectsAndKeys:PackageAttributeString,@"subTitle",exPiresStr,@"expire", nil];
        return packageDict;
    }
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:subTitleLbltext,@"subTitle",exPiresStr,@"expire", nil];
    return dict;
}

@end
