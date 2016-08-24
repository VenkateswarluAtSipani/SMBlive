//
//  DetailViewController.m
//  StyleMyBody
//
//  Created by sipani online on 5/2/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "DetailViewController.h"
#import "RestClient.h"
#import "MBProgressHUD.h"
#import "CenterDetailResModel.h"
#import "ServiceResModel.h"
#import "OperationHoursResModel.h"
#import "RestClient.h"
#import "MapModel.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "centerDetailsCell.h"

@interface DetailViewController ()<UIGestureRecognizerDelegate>
{
  NSNumber *isFev;
    RestClient *restClient;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CenterDetailResModel *detailModel;
@property (nonatomic, strong) MKMapItem *mapItem;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self callGetCenterDetails];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)callGetCenterDetails {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    if ([restClient rechabilityCheck]) {
    [restClient getOneCenterDetail:self.centerSubmodel.centerId callBackRes:^(CenterDetailResModel *centerDetail, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.detailModel = centerDetail;
            [self.tableView reloadData];
            [hud hideAnimated:YES];
        });
    }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    centerDetailsCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        UIScrollView *displyaImgScrollView =[cell viewWithTag:1000];
        UIButton *fevBtn = [cell viewWithTag:100];
        [fevBtn addTarget:self action:@selector(slectFevButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.detailModel.isFavorite boolValue]) {
            [fevBtn setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
        }else{
            [fevBtn setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
        }
        
        UISwipeGestureRecognizer *leftSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(imgLeftSwipe:)];
        leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *rightSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(imgRightSwipe:)];
        leftSwipe.delegate=self;
        rightSwipe.delegate=self;
        leftSwipe.delaysTouchesBegan = YES;
        rightSwipe.delaysTouchesBegan = YES;
        rightSwipe.cancelsTouchesInView=YES;
        rightSwipe.cancelsTouchesInView=YES;
        rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
        [displyaImgScrollView addGestureRecognizer:leftSwipe];
        [displyaImgScrollView addGestureRecognizer:rightSwipe];
        [self loadMainIngsOnScrollView:displyaImgScrollView withList:self.detailModel.centerCoverImages];
        
    }else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
                UIImageView *logoImgView = (UIImageView *)[cell viewWithTag:10];
        UILabel *nameLbl = (UILabel *)[cell viewWithTag:11];
        UIImageView *ratingImgView = (UIImageView *)[cell viewWithTag:12];
        ratingImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Rating-%d",[self.detailModel.rating intValue]]];

        nameLbl.text = self.detailModel.displayName;
        [RestClient loadImageinImgView:logoImgView withUrlString:self.detailModel.logo];
        
    }else if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
        UILabel *descLbl = (UILabel *)[cell viewWithTag:10];
        descLbl.text = self.detailModel.catDescription;
    }else if (indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"openHoursCell"];
        UILabel *openHoursLbl = (UILabel *)[cell viewWithTag:10];
        NSString *openHourStr =  [self getOpenHouresString:self.detailModel.operationHours];
        NSLog(@"%@",openHourStr);
        
        openHoursLbl.text = openHourStr;

    }else if (indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"weServeCell"];
        UIView *leftView = (UIView *)[cell viewWithTag:10];
        UIView *rightView = (UIView *)[cell viewWithTag:11];
   
        UILabel *weServeLbl = (UILabel *)[leftView viewWithTag:100];
        UILabel *advancedBookingLbl = (UILabel *)[rightView viewWithTag:101];
        
        
        if ([self.detailModel.serveFor intValue] == 0) {
            weServeLbl.text = @"Male";
        }else if ([self.detailModel.serveFor intValue] == 1) {
            weServeLbl.text = @"Female";
            
        }else if ([self.detailModel.serveFor intValue] == 2) {
            weServeLbl.text = @"Unisex";
        }

        NSNumber *advBooking=self.detailModel.advanceBookingPeriod;
        if ([advBooking integerValue]) {
             advancedBookingLbl.text =[NSString stringWithFormat:@"%@ Days before",[[NSNumber numberWithInt:[advBooking intValue]*15] stringValue]];
        }else{
             advancedBookingLbl.text =[NSString stringWithFormat:@"%@ ",@"No Advance Booking"];
        }
       

    }else if (indexPath.row == 5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"amenitiesCell"];
        
        NSArray *amenities=[self.detailModel.amenities componentsSeparatedByString:@","];
        
        
        if ([self.detailModel.centerId integerValue]>0) {
            if (![amenities containsObject:@"1"]) {
                cell.acViewWidth.constant=0;
                cell.acView.hidden=YES;
            }if (![amenities containsObject:@"2"]) {
                cell.wiFiViewWidth.constant=0;
                cell.wiFiView.hidden=YES;
            }if (![amenities containsObject:@"3"]) {
                cell.TvViewWidth.constant=0;
                cell.TvView.hidden=YES;
            }
  
        }
        
    }else if (indexPath.row == 6) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
        UILabel *openHoursLbl = (UILabel *)[cell viewWithTag:10];
        openHoursLbl.text = self.detailModel.address;
        
        MKMapView *mapView = (MKMapView*)[cell viewWithTag:11];
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
        CLLocationCoordinate2D logCord = CLLocationCoordinate2DMake([self.detailModel.latitude doubleValue], [self.detailModel.longitude doubleValue]);
        MKCoordinateRegion region = MKCoordinateRegionMake(logCord, span);

        [mapView setRegion:region animated:YES];
        
        MapModel *ann = [[MapModel alloc] init];
        ann.titleName = @"put title here";
        ann.coordinate = region.center;
        [mapView addAnnotation:ann];

        UIButton *startNavBtn = [cell viewWithTag:100];
        [startNavBtn addTarget:self action:@selector(clickOnStartNavigation) forControlEvents:UIControlEventTouchUpInside];

        
    }else if (indexPath.row == 7) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"shareItCell"];
        
    }
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    
    return NO;
}
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer
{
   
    return NO;
}
-(void)loadMainIngsOnScrollView:(UIScrollView*)StylistScrollView withList:(NSArray *)imgsArray{
    // Finding moving slider width
    
    CGRect serviceFrm = CGRectMake(0, 0, self.view.frame.size.width-16, StylistScrollView.frame.size.height);
    for (NSString *mainImg in imgsArray) {
        UIView *serviceView = [self getmainImgView:mainImg :StylistScrollView.frame.size.height];
        serviceView.frame = serviceFrm;
        [StylistScrollView addSubview:serviceView];
        serviceFrm.origin.x =serviceView.frame.origin.x+serviceView.frame.size.width;
    }
    StylistScrollView.contentSize = CGSizeMake(serviceFrm.origin.x, 0);
    
}

- (UIView *)getmainImgView:(NSString* )imgUrl :(int)height {
    
    UIView *serviceView = [[UIView alloc]init];
    //  serviceView.backgroundColor = [UIColor greenColor];
    UIImageView *profilePic=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-16, height)];
    NSString *photoUrlStr=imgUrl;
    if (photoUrlStr.length>0) {
        [RestClient loadImageinImgView:profilePic withUrlString:photoUrlStr];
        
    }else{
        profilePic.image=[UIImage imageNamed:@"my-account"];
    }
    [serviceView addSubview:profilePic];
    return serviceView;
}
-(IBAction)imgLeftSwipe:(UISwipeGestureRecognizer*)sender {
    UIScrollView *scrollview = (UIScrollView*)sender.view;
    NSLog(@"%ld", (long)scrollview.tag);//By tag, you can find out where you had tapped.
    if (scrollview.contentOffset.x < (scrollview.contentSize.width-scrollview.frame.size.width)) {
        [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x+scrollview.frame.size.width, 0) animated:YES];
    }
    
}



-(IBAction)imgRightSwipe:(UISwipeGestureRecognizer*)sender {
    UIScrollView *scrollview = (UIScrollView*)sender.view;
    NSLog(@"%ld", (long)scrollview.tag);//By tag, you can find out where you had tapped.
    if (scrollview.contentOffset.x > 0) {
        [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x-scrollview.frame.size.width, 0) animated:YES];
    }
}
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = nil;
    if(annotation != mV.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:defaultPinID] ;
        
//        pinView.pinColor = MKPinAnnotationColorPurple;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    }
    else {
        [mV.userLocation setTitle:@"I am here"];
    }
    return pinView;
}

- (void)clickOnStartNavigation {
    CLLocationCoordinate2D logCord = CLLocationCoordinate2DMake([self.detailModel.latitude doubleValue], [self.detailModel.longitude doubleValue]);

    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:logCord addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = self.detailModel.address;
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [item openInMapsWithLaunchOptions:options];
    
}

- (void)slectFevButton:(UIButton *)fevBtn {
//    UIButton *fevBtn = (UIButton *)sender;
    if ([fevBtn.currentImage isEqual:[UIImage imageNamed:@"like1"]]) {
        isFev = [NSNumber numberWithInt:YES];
        [fevBtn setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
    }else{
        isFev = [NSNumber numberWithInt:NO];
        [fevBtn setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
    }

    [self setFevToItem];
    
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.centerSubmodel,@"indexPath",@"NearBy",@"FromView",isFev,@"IsFev", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"FevSelectNow" object:dict];

}

- (void)setFevToItem {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
//    CenterListResModel *model = [self.nearByController.nearByCenterListModel objectAtIndex:indexPath.row];
    if ([restClient rechabilityCheck]) {
    [restClient setFev:self.detailModel.centerId isFev:isFev callBackRes:^(NSString *resStr, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadViewData" object:nil];
        });
    }];
    }
}

- (NSString *)getOpenHouresString:(NSArray *)arr {
    NSMutableString *mutableStr = [[NSMutableString alloc]init];
    
    int i = 0;
    for (OperationHoursResModel *model in arr) {
     
        NSString *str = [NSString stringWithFormat:@"%@   %@",[self getDayName:[model.opDay intValue]],[self getOPenAndCloseHours:model.startTimeIndex withOffSet:model.offset]];
        
        if (i == 0) {
            [mutableStr appendString:str];
        }else {
            [mutableStr appendString:[NSString stringWithFormat:@"\n\n%@",str]];
        }
        NSLog(@"%@",str);
        
        i++;
       
        
    }
    
    return mutableStr;
}

- (NSString *)getOPenAndCloseHours:(NSNumber *)startIndex withOffSet:(NSNumber *)offSet {
    
//    int timeVal = [startIndex intValue] ;
//    int offsetVal = [offSet intValue];
//    
//    float startTime = (timeVal *5)/60;
//    float endTime = ((timeVal+offsetVal) * 5)/60;
//    
//    if (endTime > 12) {
//        endTime -= 12;
//    }
//    
//    NSString *statrStr = [NSString stringWithFormat:@"%.2f",startTime];
//    NSArray *startarr = [statrStr componentsSeparatedByString:@"."];
//    int startMin= 0;
//    if ([startarr[1] intValue] > 0) {
//        startMin = (60/100)*[startarr[1] intValue];
//    }
//    
//    NSString *startTimeStr = [NSString stringWithFormat:@"%@:%d0",startarr[0],startMin];
//    
//    NSString *endStr = [NSString stringWithFormat:@"%.2f",endTime];
//    
//    NSArray *arr = [endStr componentsSeparatedByString:@"."];
//    
//    int min= 0;
//    if ([arr[1] intValue] > 0) {
//         min = (60/100)*[arr[1] intValue];
//    }
//    
    
    
    
    NSString *startTimeStr = [self getTimeFromOffset:[startIndex integerValue]];
    NSString *endTimeStr = [self getTimeFromOffset:[startIndex integerValue]+[offSet integerValue]];
    
    NSString *finalFinalStr = [NSString stringWithFormat:@"%@ -  %@",startTimeStr,endTimeStr];
    
    return finalFinalStr;
    
}
- (NSString *)getTimeFromOffset:(NSInteger) val {
    NSInteger valuMulti=(val)*5;
    NSInteger val1 = valuMulti/60;
    NSInteger valu2 = valuMulti%60;
    NSString *AMorPM;
    if (val1>=12) {
        AMorPM=@"PM";
    }else{
        AMorPM=@"AM";
    }
    
    if (val1 > 12) {
        val1 -= 12;
    }
    return [NSString stringWithFormat:@"%ld:%02ld %@",(long)val1,(long)valu2,AMorPM];
    // return [NSString stringWithFormat:@"%ld:%ld %@",val1,valu2,AMorPM];
}
//- (NSString *)getEndTime:(NSString *)startTime withRange:(int)range {
//    NSString *endTime;
//    
//    int minutes;
//    int hours;
//    if (range >= 60) {
//        minutes = ((range*60) / 60) % 60;
//        hours = (range*60) / 3600;
//    }else{
//        minutes = range;
//        hours = 0;
//    }
//    
//    
//    NSArray *startTimeArr = [startTime componentsSeparatedByString:@":"];
//    
//    
//    //    NSArray *arr = [[NSString stringWithFormat:@"%.2f",timeVal] componentsSeparatedByString:@"."];
//    
//    int hour = [startTimeArr[0] intValue] + hours;
//    
//    int minitues = [startTimeArr[1] intValue] + minutes;
//    
//    int tempMinitues = 0;
//    int tempHours = 0;
//    if (minitues >= 60 ) {
//        tempMinitues = ((minitues*60) / 60) % 60;
//        tempHours = (minitues*60) / 3600;
//    }else{
//        tempMinitues = minitues;
//    }
//    
//    hour += tempHours;
//    minutes = tempMinitues;
//    
//    if (hour > 12) {
//        hour = hour-12;
//    }
//    
//    NSString *minitStr = [NSString stringWithFormat:@"%d",minutes];
//    
//    if (minitStr.length < 2) {
//        minitStr = [NSString stringWithFormat:@"0%d",minutes];
//    }
//    
//    endTime = [NSString stringWithFormat:@"%d:%@",hour,minitStr];
//    
//    return endTime;
//}

- (NSString *)getDayName:(int)i {
    NSString *str;
    switch (i) {
        case 1:
            str = @"MON";
            break;
        case 2:
            str = @"TUE";
            break;
        case 3:
            str = @"WED";
            break;
        case 4:
            str = @"THU";
            break;
        case 5:
            str = @"FRI";
            break;
        case 6:
            str = @"SAT";
            break;
        case 0:
            str = @"SUN";
            break;
            
        default:
            break;
    }
    
    return str;
}

- (IBAction)clickOnBookNow:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSelectBookNow" object:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
