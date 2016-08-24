//
//  TimeSlotViewController.m
//  StyleMyBody
//
//  Created by sipani online on 04/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "NewTimeSlotViewController.h"
#import "TimeSlotTableViewCell.h"
#import "RestClient.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AllStylistsResModel.h"
#import "StylistResModel.h"
#import "ServiceResModel.h"
#import "StylistListTableViewCell.h"
#import "AllStylistsResModel.h"
#import "AppointmentReqModel.h"
#import "BookingViewController.h"
#import "RestClient.h"
#import "TimeSlotReqModel.h"
#import "MBProgressHUD.h"

#define NumOfHours   14
#define slotlableWidth 0.5

@interface NewTimeSlotViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *hud;
    NSMutableArray *slotsPointsX;
    NSMutableArray *timeValuesArr;
    NSMutableArray *timeValuesArr1;
    
    NSDictionary *resDict ;
    
    double eachSloatWidth;
    double eackSmallSlotWidth;
    CGRect frm;
    
    double movingSlotWidth;
    double rangeOfSliderWidth;
    int totalGapMinitues;
    
    int serviceCount;
    NSString *selectedDate;
    BOOL isDateAlertShown;
    NSArray *nextSevenDaysArray;
    NSInteger selctedDayIndex;
    RestClient* restClient;
    
    NSNumber *startTimeIndex;
    NSNumber *TotalOffset;
    NSNumber *travelTime;
    NSArray *stylistOperationHours;
    NSArray *happyHours;
    NSArray *stylistServices;
    
    bool SliderStartPossitionSetted;
    CGPoint slotPoint;
    CGFloat slotStartPossition;
    NSMutableArray *validSlotsPossitionArray;
    NSMutableArray *validSlotsToBookArray;
    NSMutableArray *notValidSlotsToBookArray;
    NSMutableArray *arrayOfSlotDuriations;
    NSInteger totalAmount;
  //  NSArray *totalSelectedServiceList;
    
}

@property (nonatomic, weak) IBOutlet UITableView *timeSlotTV;
//@property (nonatomic, strong) AllStylistsResModel *allStylistsResModel;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) NSIndexPath *selectedServiceIndex;
@property (nonatomic, strong) NSMutableArray *serviceArr;
@property (nonatomic, strong) NSMutableArray *selectedStylistArr;
@property (nonatomic, strong) NSMutableArray *selectedServiceIndexArr;

@property (nonatomic, weak) IBOutlet UIImageView *stylistImgView;
@property (nonatomic, weak) IBOutlet UILabel *serviceTypeLbl;
@property (nonatomic, weak) IBOutlet UILabel *stylistNameLbl;

@property (nonatomic, weak) IBOutlet UIScrollView *serviceScrollView;


@end

@implementation NewTimeSlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     placardView.transform = CGAffineTransformMakeScale(1.0, 1.5);
//    placardView.backgroundColor=[UIColor clearColor];
    
    
    
    
    totalAmount=0;
    _sliderTopCurve1.layer.cornerRadius=4;
     _sliderTopCurve2.layer.cornerRadius=4;
    NSDate *today = [NSDate date];
    restClient=[[RestClient alloc]init];
    datePicker.minimumDate=today;
    datePicker.date=self.dateSelectedInPreviousPage;
    [self setdateLayer];
    nextSevenDaysArray= [self nextSevenDaysFromDate:self.dateSelectedInPreviousPage];
    selctedDayIndex=1;
    [self setDateInDateLbls];
    monthLbl.font = [UIFont fontWithName:@"Pacifico" size:16];
    
    frm = slotTimeLbl.frame;
    slotTimeLbl.layer.cornerRadius = 10.f;
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    
    [ContentView addGestureRecognizer:pan];
    
    self.timeSlotTV.estimatedRowHeight = 1000;
    self.timeSlotTV.rowHeight = UITableViewAutomaticDimension;
    self.timeSlotTV.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    
    //    ContentView.backgroundColor=[UIColor colorWithRed:148.0/255.0 green:221.0/255.0 blue:160.0/255.0 alpha:1.0];
    //     placardView.backgroundColor=[UIColor colorWithRed:164.0/255.0 green:225.0/255.0 blue:174.0/255.0 alpha:1.0];
    
    slotsPointsX=[[NSMutableArray alloc]init];
    
    [self setUpServiceView];
    [self callDetailsOfTimeSlot];
    
}
-(void)viewWillAppear:(BOOL)animated{
    isDateAlertShown=NO;
    self.datePickerBlurBtn.alpha=0.0;
    _dateAlertView.hidden=YES;
}
-(NSMutableArray *)nextSevenDaysFromDate:(NSDate*)date{
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = [calendar startOfDayForDate:date];
    NSMutableArray<NSDate*> * nextSevenDays = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 7; i++) {
        [nextSevenDays addObject:[calendar dateByAddingUnit:NSCalendarUnitDay value: i toDate: startDate options: NSCalendarMatchNextTime]];
    }
    NSLog(@"%@", nextSevenDays);
    return nextSevenDays;
}


- (void)setUpServiceView {
    self.stylistNameLbl.text = self.selectedStylistModel.name;
    self.serviceTypeLbl.text = self.selectedStylistModel.designation;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:self.selectedStylistModel.photo] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data != nil) {
                self.stylistImgView.image = [UIImage imageWithData:data];
            }
        });
    }];
    [task resume];
    
}



- (UIView *)getServiceDetailView:(ServiceResModel *)serviceModel :(int)height {
    int width = 180;
    
    UIView *serviceView = [[UIView alloc]init];
    serviceView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 150, 20)];
    nameLbl.text = serviceModel.name;
    
    [serviceView addSubview:nameLbl];
    
    UILabel *priceLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, nameLbl.frame.origin.y+nameLbl.frame.size.height+20  , 100, 30)];
    priceLbl.textColor=[UIColor colorWithRed:252.0/255 green:106.0/255.0 blue:73.0/255.0 alpha:1];
    priceLbl.text = [NSString stringWithFormat:@"\u20B9 %d only",[serviceModel.price intValue]];
    //    priceLbl.backgroundColor = [UIColor redColor];
    
    [serviceView addSubview:priceLbl];
    
    UILabel *timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(width-80, nameLbl.frame.origin.y+nameLbl.frame.size.height+20  , 70, 30)];
    timeLbl.text = [NSString stringWithFormat:@"%@ min",[serviceModel.time stringValue]];
    //    timeLbl.backgroundColor = [UIColor redColor];
    
    [serviceView addSubview:timeLbl];
    
    
    return serviceView;
    
}

- (NSString *)getEndTime:(NSString *)startTime withRange:(int)range {
    NSString *endTime;
    
    int minutes;
    int hours;
    if (range >= 60) {
        minutes = ((range*60) / 60) % 60;
        hours = (range*60) / 3600;
    }else{
        minutes = range;
        hours = 0;
    }
    
    
    NSArray *startTimeArr = [startTime componentsSeparatedByString:@":"];
    
    
    //    NSArray *arr = [[NSString stringWithFormat:@"%.2f",timeVal] componentsSeparatedByString:@"."];
    
    int hour = [startTimeArr[0] intValue] + hours;
    
    int minitues = [startTimeArr[1] intValue] + minutes;
    
    int tempMinitues = 0;
    int tempHours = 0;
    if (minitues >= 60 ) {
        tempMinitues = ((minitues*60) / 60) % 60;
        tempHours = (minitues*60) / 3600;
    }else{
        tempMinitues = minitues;
    }
    
    hour += tempHours;
    minutes = tempMinitues;
    
    if (hour > 12) {
        hour = hour-12;
    }
    
    NSString *minitStr = [NSString stringWithFormat:@"%d",minutes];
    
    if (minitStr.length < 2) {
        minitStr = [NSString stringWithFormat:@"0%d",minutes];
    }
    
    endTime = [NSString stringWithFormat:@"%d:%@",hour,minitStr];
    
    return endTime;
}

-(void)viewDidAppear:(BOOL)animated {
   // [self MakeRangeSloats];
    
//    placardView.center = CGPointMake(150, placardView.center.y);
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   // slotTimeLbl.frame = frm;
    //placardView.center = slotPoint;
}

- (void)setBottomTimeSlotView:(int)minVal :(int)maxValue {
    
}


- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGFloat pixelsPerOffsetValue= ContentView.frame.size.width/[TotalOffset integerValue];
    
    CGPoint translation = [recognizer translationInView:ContentView];
    
    placardView.bounds=CGRectMake(0, placardView.bounds.origin.y, placardView.bounds.size.width, placardView.bounds.size.height);
    slotTimeLbl.bounds=CGRectMake(0, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
    
    
    if (XValueOfPlacardView.constant + (translation.x/2) <=slotStartPossition) {
        
    }else if (XValueOfPlacardView.constant + (translation.x/2) >=ContentView.frame.size.width-WidthOfPlaceCardView.constant){
        
    }else{
        // if(recognizer.state ==UIGestureRecognizerStateChanged){
        
//        placardView.center = CGPointMake(placardView.center.x + translation.x,
//                                         placardView.center.y + 0);
        XValueOfPlacardView.constant=XValueOfPlacardView.constant + (translation.x/2);
        
        slotTimeLbl.center = CGPointMake(XValueOfPlacardView.constant + (translation.x/2), slotTimeLbl.center.y + 0);
        
        if (slotTimeLbl.frame.origin.x<=0) {
            slotTimeLbl.frame=CGRectMake(0, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
        }else if (slotTimeLbl.frame.origin.x+slotTimeLbl.frame.size.width>=self.view.frame.size.width){
            slotTimeLbl.frame=CGRectMake(self.view.frame.size.width-slotTimeLbl.frame.size.width, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
        }
        
        if(recognizer.state == UIGestureRecognizerStateEnded)
                {
                    CGFloat targetNumber = XValueOfPlacardView.constant;
                    NSUInteger index = [validSlotsPossitionArray indexOfObject:@(targetNumber)
                                               inSortedRange:NSMakeRange(0, validSlotsPossitionArray.count-1)
                                                     options:NSBinarySearchingFirstEqual | NSBinarySearchingInsertionIndex
                                             usingComparator:^(id a, id b) {
                                                 return [a compare:b];
                                                 
                                             }];
                    NSLog(@"Present :%f,next: %@",XValueOfPlacardView.constant,[validSlotsPossitionArray objectAtIndex:index]);
                    XValueOfPlacardView.constant=[[validSlotsPossitionArray objectAtIndex:index] floatValue];
                }
        NSInteger startIndex=XValueOfPlacardView.constant/pixelsPerOffsetValue;
        NSInteger endIndex=(XValueOfPlacardView.constant+WidthOfPlaceCardView.constant)/pixelsPerOffsetValue;
        
        NSString *timeDuriationTxt=[NSString stringWithFormat:@"%@-%@",[self getTimeFromOffset:startIndex],[self getTimeFromOffset:endIndex]];

        
        NSInteger valuMulti=(startIndex+[startTimeIndex integerValue])*5;
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
       
        
        _endTimeLBL.text=[NSString stringWithFormat:@"%02ld",(long)val1];
        _startTimeLBL.text=[NSString stringWithFormat:@"%02ld",(long)valu2];
        _startAmOrPm.text=AMorPM;
        slotTimeLbl.text=timeDuriationTxt;
        
//        NSNumber *variationShoulsHappane=0;
//        
//        NSMutableArray *distencesAbsaluteArray=[[NSMutableArray alloc]init];
//        
//        NSMutableArray *distencesArray=[[NSMutableArray alloc]init];
//        
//        //        NSUInteger index = [slotsPointsX indexOfObject:@(placardView.frame.origin.x)
//        //                                   inSortedRange:NSMakeRange(0, slotsPointsX.count)
//        //                                         options:NSBinarySearchingFirstEqual | NSBinarySearchingInsertionIndex
//        //                                 usingComparator:^(id a, id b) {
//        //                                     return [a compare:b];
//        //                                 }];
//        //
//        ////        variationShoulsHappane = slotsPointsX[index];
//        //        NSLog(@"xaxis value  = %f",placardView.frame.origin.x);
//        //        NSLog(@"index value = %d",(int)index);
//        //        NSLog(@"Object value = %@",slotsPointsX[index]);
//        
//        for (NSNumber *slotX in slotsPointsX ) {
//            
//            NSNumber *yourFloatNumber = [NSNumber numberWithFloat:-placardView.frame.origin.x+[slotX floatValue]];
//            
//            
//            [distencesAbsaluteArray addObject: [self absoluteValue: yourFloatNumber]];
//            
//            [distencesArray addObject: yourFloatNumber];
//            
//            
//            NSNumber *min=[distencesAbsaluteArray valueForKeyPath:@"@min.self"];
//            //                                    NSLog(@"End  %f",[min floatValue]);
//            
//            if ([[self absoluteValue:yourFloatNumber ] floatValue] == [min floatValue]) {
//                
//                variationShoulsHappane=yourFloatNumber;
//                //                    NSLog(@"variationShoulsHappane %f",variationShoulsHappane.floatValue);
//            }
//        }
//        
//        //            NSLog(@"placardView.frame.origin.x %f",placardView.frame.origin.x);
//        //            NSLog(@"variationShoulsHappane  %@",variationShoulsHappane);
//        
//        
//        
//        //            NSLog(@"%@",slotsPointsX);
//        
//        double val = placardView.frame.origin.x/eachSloatWidth;
//        
//        double val1 = eachSloatWidth - placardView.frame.origin.x;
//        
//        double val2  = 12-val1;
//        
//        
//        //            NSLog(@"%f",eachSloatWidth);
//        //            NSLog(@"%f",placardView.frame.origin.x);
//        //            NSLog(@"%f",val);
//        //            NSLog(@"%f",eackSmallSlotWidth);
//        NSLog(@"befor frame = %@", placardView);
//        placardView.frame=CGRectMake(placardView.frame.origin.x+[variationShoulsHappane floatValue], placardView.frame.origin.y, placardView.frame.size.width, placardView.frame.size.height);
//        NSLog(@"after frame = %@",placardView);
//        
//        slotTimeLbl.frame=CGRectMake((placardView.frame.origin.x+[variationShoulsHappane floatValue])-placardView.frame.size.width/2, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
//        
//        if (slotTimeLbl.frame.origin.x + slotTimeLbl.frame.size.width >= self.view.frame.size.width) {
//            slotTimeLbl.frame=CGRectMake(self.view.frame.size.width-slotTimeLbl.frame.size.width, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
//        }
//        
//        NSNumber *valnum = [NSNumber numberWithDouble:placardView.frame.origin.x
//                            ];
//        int indexVal = (int)[slotsPointsX indexOfObject:valnum];
//        //            NSLog(@"%d",indexVal);
//        
//        float timeDiff = (float) ((indexVal-1)*5)/60;
//        
//        NSString *timeDiffStr = [NSString stringWithFormat:@"%.1f",timeDiff];
//        
//        NSArray *arr = [timeDiffStr componentsSeparatedByString:@"."];
//        
//        NSString *startSrt = [NSString stringWithFormat:@"%@:%d",timeValuesArr1[(int)val],[arr[1] intValue] * 5];
//        
//        //            NSString *endSrt = [NSString stringWithFormat:@"%@:%d",timeValuesArr1[(int)val+1],[arr[1] intValue] * 5];
//        
//        //
//        
//        NSString *endStr = [self getEndTime:startSrt withRange:totalGapMinitues];
//        slotTimeLbl.text = [NSString stringWithFormat:@"%@-%@",startSrt,endStr];
//        
//        NSArray *startTimeArr = [startSrt componentsSeparatedByString:@":"];
//        
//        self.startTimeLBL.text=[NSString stringWithFormat:@"%@",startTimeArr[0]];
//        self.endTimeLBL.text=[NSString stringWithFormat:@"%@",startTimeArr[1]];
//        
//        
//        if (self.startTimeLBL.text.length < 2) {
//            self.startTimeLBL.text = [NSString stringWithFormat:@"0%@",self.startTimeLBL.text];
//        }
//        
//        if (self.endTimeLBL.text.length < 2) {
//            self.endTimeLBL.text = [NSString stringWithFormat:@"0%@",self.endTimeLBL.text];
//        }
//        
//        
//        frm = slotTimeLbl.frame;
//        
//        //        }
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:ContentView];
}

-(NSNumber *)absoluteValue:(NSNumber *)input {
    return [NSNumber numberWithDouble:fabs([input doubleValue])];
}


/*
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    

    CGPoint translation = [recognizer translationInView:ContentView];
    
    
    placardView.bounds=CGRectMake(0, placardView.bounds.origin.y, placardView.bounds.size.width, placardView.bounds.size.height);
    slotTimeLbl.bounds=CGRectMake(0, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
    
    
    if (placardView.frame.origin.x + translation.x <=0) {
        
    }else if (placardView.frame.origin.x + translation.x >=ContentView.frame.size.width-placardView.frame.size.width){
        
    }else{
        // if(recognizer.state ==UIGestureRecognizerStateChanged){
        
        placardView.center = CGPointMake(placardView.center.x + translation.x,
                                         placardView.center.y + 0);
        slotTimeLbl.center = CGPointMake(placardView.center.x + translation.x, slotTimeLbl.center.y + 0);
        
        //        if(recognizer.state == UIGestureRecognizerStateEnded)
        //        {
        NSNumber *variationShoulsHappane=0;
        
        NSMutableArray *distencesAbsaluteArray=[[NSMutableArray alloc]init];
        
        NSMutableArray *distencesArray=[[NSMutableArray alloc]init];
        
        //        NSUInteger index = [slotsPointsX indexOfObject:@(placardView.frame.origin.x)
        //                                   inSortedRange:NSMakeRange(0, slotsPointsX.count)
        //                                         options:NSBinarySearchingFirstEqual | NSBinarySearchingInsertionIndex
        //                                 usingComparator:^(id a, id b) {
        //                                     return [a compare:b];
        //                                 }];
        //
        ////        variationShoulsHappane = slotsPointsX[index];
        //        NSLog(@"xaxis value  = %f",placardView.frame.origin.x);
        //        NSLog(@"index value = %d",(int)index);
        //        NSLog(@"Object value = %@",slotsPointsX[index]);
        
        for (NSNumber *slotX in slotsPointsX ) {
            
            NSNumber *yourFloatNumber = [NSNumber numberWithFloat:-placardView.frame.origin.x+[slotX floatValue]];
            
            
            [distencesAbsaluteArray addObject: [self absoluteValue: yourFloatNumber]];
            
            [distencesArray addObject: yourFloatNumber];
            
            
            NSNumber *min=[distencesAbsaluteArray valueForKeyPath:@"@min.self"];
            //                                    NSLog(@"End  %f",[min floatValue]);
            
            if ([[self absoluteValue:yourFloatNumber ] floatValue] == [min floatValue]) {
                
                variationShoulsHappane=yourFloatNumber;
                //                    NSLog(@"variationShoulsHappane %f",variationShoulsHappane.floatValue);
            }
        }
        
        //            NSLog(@"placardView.frame.origin.x %f",placardView.frame.origin.x);
        //            NSLog(@"variationShoulsHappane  %@",variationShoulsHappane);
        
        
        
        //            NSLog(@"%@",slotsPointsX);
        
        double val = placardView.frame.origin.x/eachSloatWidth;
        
        double val1 = eachSloatWidth - placardView.frame.origin.x;
        
        double val2  = 12-val1;
        
        
        //            NSLog(@"%f",eachSloatWidth);
        //            NSLog(@"%f",placardView.frame.origin.x);
        //            NSLog(@"%f",val);
        //            NSLog(@"%f",eackSmallSlotWidth);
        NSLog(@"befor frame = %@", placardView);
        placardView.frame=CGRectMake(placardView.frame.origin.x+[variationShoulsHappane floatValue], placardView.frame.origin.y, placardView.frame.size.width, placardView.frame.size.height);
        NSLog(@"after frame = %@",placardView);
        
        slotTimeLbl.frame=CGRectMake((placardView.frame.origin.x+[variationShoulsHappane floatValue])-placardView.frame.size.width/2, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
        
        if (slotTimeLbl.frame.origin.x + slotTimeLbl.frame.size.width >= self.view.frame.size.width) {
            slotTimeLbl.frame=CGRectMake(self.view.frame.size.width-slotTimeLbl.frame.size.width, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
        }
        
        NSNumber *valnum = [NSNumber numberWithDouble:placardView.frame.origin.x
                            ];
        int indexVal = (int)[slotsPointsX indexOfObject:valnum];
        //            NSLog(@"%d",indexVal);
        
        float timeDiff = (float) ((indexVal-1)*5)/60;
        
        NSString *timeDiffStr = [NSString stringWithFormat:@"%.1f",timeDiff];
        
        NSArray *arr = [timeDiffStr componentsSeparatedByString:@"."];
        
        NSString *startSrt = [NSString stringWithFormat:@"%@:%d",timeValuesArr1[(int)val],[arr[1] intValue] * 5];
        
        //            NSString *endSrt = [NSString stringWithFormat:@"%@:%d",timeValuesArr1[(int)val+1],[arr[1] intValue] * 5];
        
        //
        
        NSString *endStr = [self getEndTime:startSrt withRange:totalGapMinitues];
        slotTimeLbl.text = [NSString stringWithFormat:@"%@-%@",startSrt,endStr];
        
        NSArray *startTimeArr = [startSrt componentsSeparatedByString:@":"];
        
        self.startTimeLBL.text=[NSString stringWithFormat:@"%@",startTimeArr[0]];
        self.endTimeLBL.text=[NSString stringWithFormat:@"%@",startTimeArr[1]];
        
        
        if (self.startTimeLBL.text.length < 2) {
            self.startTimeLBL.text = [NSString stringWithFormat:@"0%@",self.startTimeLBL.text];
        }
        
        if (self.endTimeLBL.text.length < 2) {
            self.endTimeLBL.text = [NSString stringWithFormat:@"0%@",self.endTimeLBL.text];
        }
        
        
        frm = slotTimeLbl.frame;
        
        //        }
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:ContentView];
}

//- (NSString *)getTimeSlotValue {
//    int time = 0;
//    for (StylistServiceResModel *serviceModel in self.selectedServiceList) {
//        time += [serviceModel.time  intValue];
//    }
//
//    if (time > 60) {
//        float timeVal = time/60
//    }
//}


-(NSNumber *)absoluteValue:(NSNumber *)input {
    return [NSNumber numberWithDouble:fabs([input doubleValue])];
}

//- (void)getAllStylist {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
//
//    [RestClient getAllStylists:self.centerId callBackRes:^(AllStylistsResModel *allStylistsResModel, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.allStylistsResModel = allStylistsResModel;
//            NSMutableArray *tempArr = [NSMutableArray array];
//            for (StylistResModel *stylistModel in self.allStylistsResModel.stylistResArr) {
//
//                [tempArr addObjectsFromArray:stylistModel.stylistServices];
//            }
//
//
//            //            [tempArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            //                if (![result containsObject:obj]) {
//            //                    [result addObject:obj];
//            //                }
//            //            }];
//
//            for (StylistServiceResModel *serviceModel in tempArr) {
//                BOOL isContain = NO;
//                for (StylistServiceResModel *serviceModel1 in self.serviceArr) {
//                    if ([serviceModel1.serviceId isEqual:serviceModel.serviceId]) {
//                        isContain = YES;
//                        break;
//                    }
//                }
//                if (!isContain) {
//                    [self.serviceArr addObject:serviceModel];
//                }
//            }
//            NSLog(@"%d",self.serviceArr.count);
//            [self.timeSlotTV reloadData];
//
//            [hud hideAnimated:YES];
//        });
//    }];
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSInteger row = 0;
//
//        if (self.selectedStylistArr.count == 0) {
//            row = self.allStylistsResModel.stylistResArr.count;
//        }else{
//            row = self.selectedStylistArr.count;
//
////    }else if  {
////            row = self.serviceArr.count;
////        }else{
////            StylistResModel *stylistModel = self.allStylistsResModel.stylistResArr[self.selectedIndex.row];
////            row = stylistModel.stylistServices.count;
////        }
//    }
//    return row;
//
//}
 
 */
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//
//    TimeSlotTableViewCell *cell = (TimeSlotTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"timeSlotTVC"];
//    StylistServiceResModel *serviceModel;
//    if (self.selectedIndex == nil) {
//        serviceModel = self.serviceArr[indexPath.row];
//    }else{
//        StylistResModel *stylistModel = self.allStylistsResModel.stylistResArr[self.selectedIndex.row];
//        serviceModel = stylistModel.stylistServices[indexPath.row];
//    }
//
//    if ([self.selectedServiceIndexArr containsObject:indexPath]) {
//        cell.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:244.0/255.0 blue:218.0/255.0 alpha:1.0];
//    }else{
//        cell.backgroundColor = [UIColor whiteColor];
//    }
//    //    if (self.selectedServiceIndex == indexPath) {
//    //        cell.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:244.0/255.0 blue:218.0/255.0 alpha:1.0];
//    //    }else{
//    //        cell.backgroundColor = [UIColor whiteColor];
//    //    }
//
//    cell.stylistName.text = serviceModel.name;
//    self.priceLBL.text = [NSString stringWithFormat:@"\u20B9 %@",[serviceModel.price stringValue]];
//
////    cell.durationLbl.text = [NSString stringWithFormat:@"%@ mins" ,[serviceModel.time stringValue]];
//
//    return cell;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



- (IBAction)backToVC:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setdateLayer{
    d1Num.layer.cornerRadius=d1Num.frame.size.height/2;
    d2Num.layer.cornerRadius=d2Num.frame.size.height/2;
    d3Num.layer.cornerRadius=d3Num.frame.size.height/2;
    d4Num.layer.cornerRadius=d4Num.frame.size.height/2;
    d5Num.layer.cornerRadius=d5Num.frame.size.height/2;
    d6Num.layer.cornerRadius=d6Num.frame.size.height/2;
    d7Num.layer.cornerRadius=d7Num.frame.size.height/2;
}
-(void)setDateInDateLbls{
    int dayIndex;
    for ( dayIndex=0;dayIndex<nextSevenDaysArray.count;dayIndex++ ) {
        
        NSDate *dateForPicker=[nextSevenDaysArray objectAtIndex:selctedDayIndex-1];
        datePicker.date=dateForPicker;
        
        NSDate *date=[nextSevenDaysArray objectAtIndex:dayIndex];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE"];
        NSString *dayName = [formatter stringFromDate:date];
        dayName=[dayName uppercaseString];
        [formatter setDateFormat:@"dd"];
        NSString *day = [formatter stringFromDate:date];
        NSLog(@"%@",dayName);
        [formatter setDateFormat:@"MMMM YYYY"];
        NSString *month = [formatter stringFromDate:date];
        UIColor *heighlitedColor=[UIColor colorWithRed:174/255.0 green:71/255.0  blue:45/255.0  alpha:1];
        switch (dayIndex) {
            case 0:
                d1Name.text=dayName;
                [d1Num setTitle:day forState:UIControlStateNormal];
                if (dayIndex==selctedDayIndex-1 ) {
                    d1Num.backgroundColor=heighlitedColor;
                }else{
                    d1Num.backgroundColor=[UIColor clearColor];
                }
                
                monthLbl.text=month;
                break;
            case 1:
                d2Name.text=dayName;
                [d2Num setTitle:day forState:UIControlStateNormal];
                if (dayIndex==selctedDayIndex-1 ) {
                    d2Num.backgroundColor=heighlitedColor;
                }else{
                    d2Num.backgroundColor=[UIColor clearColor];
                }
                break;
            case 2:
                d3Name.text=dayName;
                [d3Num setTitle:day forState:UIControlStateNormal];
                if (dayIndex==selctedDayIndex-1 ) {
                    d3Num.backgroundColor=heighlitedColor;
                }else{
                    d3Num.backgroundColor=[UIColor clearColor];
                }
                break;
            case 3:
                d4Name.text=dayName;
                [d4Num setTitle:day forState:UIControlStateNormal];
                if (dayIndex==selctedDayIndex-1 ) {
                    d4Num.backgroundColor=heighlitedColor;
                }else{
                    d4Num.backgroundColor=[UIColor clearColor];
                }
                break;
            case 4:
                d5Name.text=dayName;
                [d5Num setTitle:day forState:UIControlStateNormal];
                if (dayIndex==selctedDayIndex-1 ) {
                    d5Num.backgroundColor=heighlitedColor;
                }else{
                    d5Num.backgroundColor=[UIColor clearColor];
                }
                break;
            case 5:
                d6Name.text=dayName;
                [d6Num setTitle:day forState:UIControlStateNormal];
                if (dayIndex==selctedDayIndex-1 ) {
                    d6Num.backgroundColor=heighlitedColor;
                }else{
                    d6Num.backgroundColor=[UIColor clearColor];
                }
                break;
            case 6:
                d7Name.text=dayName;
                [d7Num setTitle:day forState:UIControlStateNormal];
                if (dayIndex==selctedDayIndex-1 ) {
                    d7Num.backgroundColor=heighlitedColor;
                }else{
                    d7Num.backgroundColor=[UIColor clearColor];
                }
                break;
                
            default:
                break;
        }
        
        
    }
}
- (IBAction)dayBtnACtion:(id)sender {
    UIButton *btn=(UIButton*)sender;
    selctedDayIndex=btn.tag;
    NSDate *dateForPicker=[nextSevenDaysArray objectAtIndex:selctedDayIndex-1];
    datePicker.date=dateForPicker;
    [self setDateInDateLbls];
    [self callDetailsOfTimeSlot];
    
    //[self setDateInDateLbls];
}
- (IBAction)dateBtnAction:(id)sender {
    if (isDateAlertShown) {
        isDateAlertShown=NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.datePickerBlurBtn.alpha=0.0;
            self.DatePickerAlertView.alpha=0.0;
        } completion:^(BOOL finished) {
            _dateAlertView.hidden=YES;
            
        }];
    }else{
        isDateAlertShown=YES;
        _dateAlertView.hidden=NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.datePickerBlurBtn.alpha=0.6;
            self.DatePickerAlertView.alpha=1;
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (IBAction)datePickerValueChangedAction:(id)sender {
    
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSString *dateString;
    
    //    dateString = [NSDateFormatter localizedStringFromDate:[picker date]
    //                                                dateStyle:NSDateFormatterMediumStyle
    //                                                timeStyle:NSDateFormatterNoStyle];
    
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE,dd MMM"];
    dateString = [df stringFromDate:today];
    dateString = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    
    
    
    
    selectedDate=dateString;
}

- (IBAction)dateSelectACtion:(id)sender {
    
    [self.dateBtn setTitle:selectedDate forState:UIControlStateNormal];
    selctedDayIndex=1;
    nextSevenDaysArray=[self nextSevenDaysFromDate:datePicker.date];
    [self setDateInDateLbls];
    isDateAlertShown=YES;
    [self dateBtnAction:self];
    [self callDetailsOfTimeSlot];
    
}

- (IBAction)dateCancelACtion:(id)sender {
    isDateAlertShown=YES;
    [self dateBtnAction:self];
    
    
}
-(IBAction)bookNowAction:(id)sender{
    
    
    
    
    
    AppointmentReqModel *appointmentReqModel=[[AppointmentReqModel alloc]init];
    NSMutableArray *bookedServicesArray=[[NSMutableArray alloc]init];
    for (ServiceResModel *serviceModel in self.selectedServiceListinSplit) {
        NSDictionary *serviceDict=[NSDictionary dictionaryWithObjectsAndKeys:serviceModel.serviceId,@"serviceId",serviceModel.isHomeService,@"isHomeService",serviceModel.isOffer,@"isOffer",serviceModel.isPackage,@"isPackage",serviceModel.isNotMappedServices,@"isServiceNotMapped",serviceModel.name,@"name",serviceModel.price,@"price",serviceModel.time,@"time", nil];
        [bookedServicesArray addObject:serviceDict];
        
        //    [serviceId] => 1
        //    [isHomeService] => 0
        //    [isOffer] => 0
        //    [isPackage] => 0
        //    [isServiceNotMapped] => 0
        //    [name] => Haircut
        //    [price] => 200
        //    [time] => 10

      
    }
    
    
    CGFloat pixelsPerOffsetValue= ContentView.frame.size.width/[TotalOffset integerValue];
    NSInteger startIndex=XValueOfPlacardView.constant/pixelsPerOffsetValue;
    NSInteger endIndex=(XValueOfPlacardView.constant+WidthOfPlaceCardView.constant)/pixelsPerOffsetValue;
    
    NSString *timeDuriationTxt=[NSString stringWithFormat:@"%@-%@",[self getTimeFromOffset:startIndex],[self getTimeFromOffset:endIndex]];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [formatter stringFromDate:datePicker.date];
    selectedDate=[date uppercaseString];
    
    
    
    
    appointmentReqModel.offset=[NSNumber numberWithInteger:endIndex-startIndex];
    appointmentReqModel.startTimeIndex=[NSNumber numberWithInteger:startIndex+[startTimeIndex integerValue]];
    
    NSInteger endOffset=[appointmentReqModel.startTimeIndex integerValue]+[appointmentReqModel.offset integerValue];
    
     appointmentReqModel.offerId=[NSNumber numberWithInteger:[self.OfferId integerValue]];
    for ( NSDictionary *happyHour in happyHours) {
        if ([[happyHour valueForKey:@"startTimeIndex"] integerValue]<=[appointmentReqModel.startTimeIndex integerValue] && [[happyHour valueForKey:@"startTimeIndex"] integerValue]+[[happyHour valueForKey:@"offset"] integerValue] >=endOffset) {
             appointmentReqModel.offerId=[NSNumber numberWithInteger:[[happyHour valueForKey:@"offerId"] integerValue]];
            break;
        }
    }
    
    appointmentReqModel.bookedServices=bookedServicesArray;
    appointmentReqModel.centerId=self.centerId;
    appointmentReqModel.bookingDate=selectedDate;
    appointmentReqModel.centerStylistId=_selectedStylistModel.centerStylistId;
    appointmentReqModel.packageId=[NSNumber numberWithInteger:0];
    appointmentReqModel.stylistId=_selectedStylistModel.stylistId;
    appointmentReqModel.totalAmount=[NSNumber numberWithInteger:totalAmount ];
    appointmentReqModel.travelTime=travelTime;
    appointmentReqModel.walkIn=[NSNumber numberWithInteger:0];

    [self callBookingApiWithAppointmentReqModel:appointmentReqModel];
   
}
-(void)callDetailsOfTimeSlot{
    //    1
    //    centerStylistId	2
    //    dateTime	2016-07-19
    //    serviceId	7
    //    stylistId	2
    totalAmount=0;
    SliderStartPossitionSetted=NO;
    validSlotsPossitionArray=[[NSMutableArray alloc]init];
    validSlotsToBookArray=[[NSMutableArray alloc]init];
    notValidSlotsToBookArray=[[NSMutableArray alloc]init];
    arrayOfSlotDuriations=[[NSMutableArray alloc]init];
    
    slotStartPossition=0;
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSLog(@"%@",self.selectedServiceListinSplit);
    for (ServiceResModel *serviceModel in self.selectedServiceListinSplit) {
        [arr addObject:serviceModel.serviceId];
    }
    TimeSlotReqModel *model=[[TimeSlotReqModel alloc]init];
    model.centerId=self.centerId;
    model.centerStylistId=_selectedStylistModel.centerStylistId;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    model.dateTime=[NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    model.serviceId=[arr componentsJoinedByString:@","];
    model.stylistId=_selectedStylistModel.stylistId;
    if ([restClient rechabilityCheck]) {
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    [restClient getTimeSlotDetails:model callBackHandler:^(NSDictionary *timeSlotDataDict, NSError *error) {
        
        NSDictionary *outletHour=[timeSlotDataDict valueForKey:@"outletHour"];
        startTimeIndex=[outletHour valueForKey:@"startHour"];
        TotalOffset=[outletHour valueForKey:@"offset"];
        travelTime=[outletHour valueForKey:@"travelTime"];
        NSDictionary *data=[[timeSlotDataDict valueForKey:@"data"] objectAtIndex:0];
        if (data.count>0) {
            NSArray *operatingHours=[data
                                     valueForKey:@"stylistOperationHours"];
            
            
            
            if (operatingHours.count>0) {
                stylistOperationHours=operatingHours ;
                
                NSSortDescriptor* brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTimeIndex" ascending:YES];
                NSArray* sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
                stylistOperationHours = [stylistOperationHours sortedArrayUsingDescriptors:sortDescriptors];
                //totalSelectedServiceList=[]
                
                happyHours=[[[timeSlotDataDict valueForKey:@"data"] valueForKey:@"happyHours"] objectAtIndex:0];
                stylistServices=[[[timeSlotDataDict valueForKey:@"data"] valueForKey:@"stylistServices"] objectAtIndex:0];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeSlotsAndColorViews];
                    [self SetInitialPointForPlaceCardView];
                    [self setupTimeSlots];
                    [self setupStylistOperationgHours];
                    
                    CGFloat pixelsPerOffsetValue= ContentView.frame.size.width/[TotalOffset integerValue];
                    XValueOfPlacardView.constant=[[validSlotsPossitionArray objectAtIndex:0] floatValue];
                    slotStartPossition=XValueOfPlacardView.constant;
                    slotTimeLbl.center = CGPointMake(XValueOfPlacardView.constant , slotTimeLbl.center.y + 0);
                    NSInteger startIndex=XValueOfPlacardView.constant/pixelsPerOffsetValue;
                    NSInteger endIndex=(XValueOfPlacardView.constant+WidthOfPlaceCardView.constant)/pixelsPerOffsetValue;
                    
                    NSString *timeDuriationTxt=[NSString stringWithFormat:@"%@-%@",[self getTimeFromOffset:startIndex],[self getTimeFromOffset:endIndex]];
                    slotTimeLbl.text=timeDuriationTxt;
                    
                    
                    NSArray *stlistServices=[data valueForKey:@"stylistServices"];
                    for (ServiceResModel *service in _selectedServiceListinSplit) {
                        for (NSDictionary *serviceDict in stlistServices) {
                            if ([service.serviceId integerValue]==[[serviceDict valueForKey:@"serviceId"] integerValue]) {
                                service.price=[serviceDict valueForKey:@"price"];
                            }
                        }
                    }
                    
                    [self setupServices];
                    [hud hideAnimated:YES];
                });
            }
       
            
         
        }else{
            
        }
        
       
    }];
    }
}



-(void)removeSlotsAndColorViews{
    for (UIView *subUIView in ContentView.subviews) {
        if (subUIView==placardView) {
        }else{
        [subUIView removeFromSuperview];
        }
    }
    for (UIView *subUIView in timeSlotView.subviews) {
        [subUIView removeFromSuperview];
    }
    
}
-(void)setupTimeSlots{
    
    CGFloat pixelsPerOffsetValue= ContentView.frame.size.width/[TotalOffset integerValue];
    NSLog( @"%f",pixelsPerOffsetValue);
    CGFloat numberOfSlots=[TotalOffset integerValue];
    
 ////----   offset*5/60=5/60 // for 5 min
 ///---  5 min -> 1 offsetValue.
    
    //eachSloatWidth
    int slotIndex;
    for (slotIndex=0; slotIndex<numberOfSlots; slotIndex++) {
        
        UILabel*lbl=[[UILabel alloc] initWithFrame:CGRectMake(slotIndex*pixelsPerOffsetValue, timeSlotView.frame.size.height-15, slotlableWidth, 15)];
        lbl.center=CGPointMake(slotIndex*pixelsPerOffsetValue, lbl.center.y);
      
       // NSLog(@"%f",lbl.center.x);
        lbl.backgroundColor=[UIColor blackColor];
        if (((slotIndex+[startTimeIndex integerValue])*5)%12==0) {
            lbl.frame=CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y-5, lbl.frame.size.width, lbl.frame.size.height+5);
            UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(lbl.center.x-5, 0, 15, 20)];
            titleLbl.center=CGPointMake(lbl.center.x, titleLbl.center.y);
            titleLbl.text= [NSString stringWithFormat:@"%@",[self gethoursFromOffset:slotIndex]];
            titleLbl.textAlignment = NSTextAlignmentCenter;
            titleLbl.numberOfLines = 2;
            titleLbl.font = [UIFont systemFontOfSize:8];
            titleLbl.textColor = [UIColor blackColor];
            [timeSlotView addSubview:titleLbl];
        }
        if (lbl.center.x>=slotStartPossition) {
            [validSlotsPossitionArray addObject:[NSNumber numberWithFloat:lbl.center.x]];
        }
        [timeSlotView addSubview:lbl];
    }
    
}
-(void)setupServices{
    int time = 0;
    CGRect serviceFrm = CGRectMake(0, 0, 180, self.serviceScrollView.frame.size.height);
    ServiceResModel *serviceModel1 = [self.selectedServiceListinSplit objectAtIndex:0];
    int servicesCount;
    if ([serviceModel1.isHomeService integerValue]) {
        servicesCount=self.selectedServiceListinSplit.count+2;
    }else{
        servicesCount=self.selectedServiceListinSplit.count;
    }
    int serviceIndex;
    NSString *homeTitle;
    
    for (serviceIndex=0;serviceIndex<servicesCount;serviceIndex++) {
        ServiceResModel *serviceModel;
        if (servicesCount>self.selectedServiceListinSplit.count) {
            if (serviceIndex==0) {
                homeTitle=@"Travel Time to home";
               
            }else if (serviceIndex==self.selectedServiceListinSplit.count+1) {
               homeTitle=@"Travel Time to Saloon";
               
            }else{
               serviceModel=[self.selectedServiceListinSplit objectAtIndex:serviceIndex-1];
            }
            
            
        }else{
        serviceModel=[self.selectedServiceListinSplit objectAtIndex:serviceIndex];
        }
        
        if (serviceModel) {
            UIView *serviceView = [self getServiceDetailView:serviceModel :180];
            serviceView.frame = serviceFrm;
            [self.serviceScrollView addSubview:serviceView];
            serviceFrm.origin.x =serviceView.frame.origin.x+serviceView.frame.size.width+2;
            time += [serviceModel.time  intValue];
            totalAmount +=[serviceModel.price integerValue];
        }else{
            UIView *serviceView = [[UIView alloc]init];
            serviceView.frame = serviceFrm;
            UILabel* titleLbl=[[UILabel alloc]initWithFrame: CGRectMake(0, 15, serviceView.frame.size.width, 30)];
            titleLbl.textAlignment=NSTextAlignmentCenter;
            titleLbl.text=homeTitle;
            UILabel *travelTimeLbl=[[UILabel alloc]init];
            travelTimeLbl.frame=CGRectMake(0, 50, serviceView.frame.size.width, 30);
            travelTimeLbl.text=[NSString stringWithFormat:@"    %@ min",travelTime];
            travelTimeLbl.backgroundColor=[UIColor yellowColor];
            [serviceView addSubview:travelTimeLbl];
            [serviceView addSubview:titleLbl];
            serviceView.backgroundColor=[UIColor whiteColor];
            [self.serviceScrollView addSubview:serviceView];
            serviceFrm.origin.x =serviceView.frame.origin.x+serviceView.frame.size.width+2;
            time += [serviceModel.time  intValue];
           
        }
        
    }
    NSString *rupee=@"\u20B9";
    _priceLBL.text=[NSString stringWithFormat:@"%@ %2ld",rupee,(long)totalAmount];
    self.serviceScrollView.contentSize = CGSizeMake(serviceFrm.origin.x, 0);
}

-(void)SetInitialPointForPlaceCardView{
    CGFloat pixelsPerOffsetValue= ContentView.frame.size.width/[TotalOffset integerValue];
    NSLog( @"%f",pixelsPerOffsetValue);
    NSInteger duriationTime=0;
    BOOL isHomeService=NO;
    for (NSDictionary *service in stylistServices) {
        duriationTime +=[[service valueForKey:@"time"] integerValue];
        if ([[service valueForKey:@"isHomeService"] integerValue]) {
             isHomeService=YES;
        }
    }
    NSInteger TotalDuriation;
    if (isHomeService) {
        CGFloat homeServiceWidth=([travelTime integerValue]/5)*pixelsPerOffsetValue;
        WidthOfPlaceHomeView1.constant=homeServiceWidth;
        WidthOfPlaceHomeView2.constant=homeServiceWidth;
          TotalDuriation=duriationTime+(2*[travelTime integerValue]);
        
    }else{
         TotalDuriation=duriationTime;
    }
   
    WidthOfPlaceCardView.constant=(TotalDuriation/5)*pixelsPerOffsetValue;
    
       if ([self selectedDateIsToday:datePicker.date]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh"];
        NSString *hours = [formatter stringFromDate:[NSDate date]];
        hours=[hours uppercaseString];
        [formatter setDateFormat:@"mm"];
        NSString *minutes = [formatter stringFromDate:[NSDate date]];
        minutes=[minutes uppercaseString];
        [formatter setDateFormat:@"a"];
        NSString *AMorPM = [formatter stringFromDate:[NSDate date]];
        AMorPM=[AMorPM uppercaseString];
        NSInteger hour=[hours integerValue];
        NSInteger minute=[minutes integerValue];
        if ([AMorPM isEqualToString:@"AM"]) {
        
            if (hour==12) {
                hour-=12;
            }
        }else{
            if (hour!=12) {
            hour+=12;
            }
        }
        NSInteger totlMinutes=(hour*60)+minute;
        NSInteger totalMinutsOffset=(totlMinutes/5)+3;
        NSDictionary *dictNoOperation=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:(totalMinutsOffset-[startTimeIndex integerValue])],@"offset",startTimeIndex,@"startTimeIndex",[NSNumber numberWithInteger:3],@"status", nil];
          
           
           slotPoint = CGPointMake((totalMinutsOffset-[startTimeIndex integerValue])*pixelsPerOffsetValue, placardView.center.y);
           //        placardView.center = CGPointMake(200, placardView.center.y);
           XValueOfPlacardView.constant=slotPoint.x;
           
           slotStartPossition=XValueOfPlacardView.constant;
           slotTimeLbl.center = CGPointMake(XValueOfPlacardView.constant , slotTimeLbl.center.y + 0);
           NSInteger startIndex=XValueOfPlacardView.constant/pixelsPerOffsetValue;
           NSInteger endIndex=(XValueOfPlacardView.constant+WidthOfPlaceCardView.constant)/pixelsPerOffsetValue;
           
           NSString *timeDuriationTxt=[NSString stringWithFormat:@"%@-%@",[self getTimeFromOffset:startIndex],[self getTimeFromOffset:endIndex]];
           slotTimeLbl.text=timeDuriationTxt;
           NSInteger valuMulti=(startIndex+[startTimeIndex integerValue])*5;
           NSInteger val1 = valuMulti/60;
           NSInteger valu2 = valuMulti%60;
           NSString *AMorPM1;
           if (val1>=12) {
               AMorPM1=@"PM";
           }else{
               AMorPM1=@"AM";
           }
           
           if (val1 > 12) {
               val1 -= 12;
           }
           _endTimeLBL.text=[NSString stringWithFormat:@"%02ld",(long)val1];
           _startTimeLBL.text=[NSString stringWithFormat:@"%02ld",(long)valu2];
           _startAmOrPm.text=AMorPM1;
           slotTimeLbl.text=timeDuriationTxt;
           if (slotTimeLbl.frame.origin.x<=0) {
               slotTimeLbl.frame=CGRectMake(0, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
           }else if (slotTimeLbl.frame.origin.x+slotTimeLbl.frame.size.width>=self.view.frame.size.width){
               slotTimeLbl.frame=CGRectMake(self.view.frame.size.width-slotTimeLbl.frame.size.width, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
           }
           
           SliderStartPossitionSetted=YES;
           NSDictionary *dictOfCurrentTimeDuriation=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3],@"status",[NSNumber numberWithInt:0],@"start",[NSNumber numberWithFloat:slotStartPossition],@"end", nil];
           [arrayOfSlotDuriations addObject:dictOfCurrentTimeDuriation];
           //  startXAxisOfSilderView.constant=(totalMinutsOffset-[startTimeIndex integerValue])*pixelsPerOffsetValue;
           
           
        [self addOperationHoursView:dictNoOperation];

    }
}

-(void)setPlaceCardInitialPossition{
    
}

-(BOOL)selectedDateIsToday:(NSDate *)selectedDate{
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [formatter stringFromDate:today];
    date=[date uppercaseString];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *Dateselected = [formatter stringFromDate:selectedDate];
    Dateselected=[Dateselected uppercaseString];
    if ([date isEqualToString:Dateselected]) {
        return YES;
    }else{
       return NO;
    }
    
}
-(void)setupStylistOperationgHours{
    
    
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:stylistOperationHours];
    [array addObjectsFromArray:happyHours];
    NSSortDescriptor* brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTimeIndex" ascending:YES];
    NSArray* sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    NSArray*  SortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
    for (NSDictionary *operationDict in SortedArray) {
        [self addOperationHoursView:operationDict];
    }
//    for (NSDictionary *happyHourDict in happyHours) {
//        [self addOperationHoursView:happyHourDict];
//    }
    //[self.view addSubview:placardView];
}
-(void)addOperationHoursView:(NSDictionary*)operationDict{
    CGFloat pixelsPerOffsetValue= ContentView.frame.size.width/[TotalOffset integerValue];
    NSLog( @"%f",pixelsPerOffsetValue);
    NSNumber *startIndex=[operationDict valueForKey:@"startTimeIndex"];
    NSInteger resultentStartIndex=[startIndex integerValue]-[startTimeIndex integerValue];
    CGFloat widthOfServiceView=[[operationDict valueForKey:@"offset"] integerValue]*pixelsPerOffsetValue;
    CGFloat viewStartPossition=pixelsPerOffsetValue*resultentStartIndex;
    CGFloat viewEndPossition =viewStartPossition+widthOfServiceView;
    
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(viewStartPossition, 0, widthOfServiceView, ContentView.frame.size.height);
    
    [self removeValuesfrom:[NSNumber numberWithFloat:viewStartPossition-WidthOfPlaceCardView.constant] To:[NSNumber numberWithFloat:viewStartPossition]];
    [self removeValuesfrom:[NSNumber numberWithFloat:viewEndPossition-WidthOfPlaceCardView.constant] To:[NSNumber numberWithFloat:viewEndPossition]];
    
//    if ([self selectedDateIsToday:datePicker.date]) {
//        if (widthOfServiceView + (pixelsPerOffsetValue*resultentStartIndex) >slotStartPossition) {
//            if (viewStartPossition>slotStartPossition) {
//                
//            }else{
//              view.frame=CGRectMake(slotStartPossition, 0, slotStartPossition-viewStartPossition, ContentView.frame.size.height);
//                
//                [self removeValuesfrom:[NSNumber numberWithFloat:slotStartPossition-viewStartPossition-WidthOfPlaceCardView.constant] To:[NSNumber numberWithFloat:slotStartPossition-viewStartPossition]];
//            }
//        }else{
//            if (!viewStartPossition+widthOfServiceView == slotStartPossition) {
//                view.hidden=YES;
//            }
//            
//            [self removeValuesfrom:[NSNumber numberWithFloat:viewStartPossition] To:[NSNumber numberWithFloat:viewEndPossition]];
//        }
//        
//    }
    
    if ([[operationDict valueForKey:@"status"]integerValue]==4) {
        view.backgroundColor= [UIColor colorWithRed:123.0/255.0 green:178.0/255.0 blue:234.0/255.0 alpha:1.0];
//        CGRect upperRect = view.frame;
//        [[UIColor blueColor] set];
//        UIRectFill(upperRect);
        
        if (!SliderStartPossitionSetted && widthOfServiceView>WidthOfPlaceCardView.constant) {
            
            XValueOfPlacardView.constant=pixelsPerOffsetValue*resultentStartIndex;
            slotTimeLbl.center = CGPointMake(XValueOfPlacardView.constant , slotTimeLbl.center.y + 0);
            NSInteger startIndex=XValueOfPlacardView.constant/pixelsPerOffsetValue;
            NSInteger endIndex=(XValueOfPlacardView.constant+WidthOfPlaceCardView.constant)/pixelsPerOffsetValue;
            
            NSString *timeDuriationTxt=[NSString stringWithFormat:@"%@-%@",[self getTimeFromOffset:startIndex],[self getTimeFromOffset:endIndex]];
            slotTimeLbl.text=timeDuriationTxt;
            NSInteger valuMulti=(startIndex+[startTimeIndex integerValue])*5;
            NSInteger val1 = valuMulti/60;
            NSInteger valu2 = valuMulti%60;
            NSString *AMorPM1;
            if (val1>=12) {
                AMorPM1=@"PM";
            }else{
                AMorPM1=@"AM";
            }
            
            if (val1 > 12) {
                val1 -= 12;
            }
            _endTimeLBL.text=[NSString stringWithFormat:@"%02ld",(long)val1];
            _startTimeLBL.text=[NSString stringWithFormat:@"%02ld",(long)valu2];
            _startAmOrPm.text=AMorPM1;
            slotTimeLbl.text=timeDuriationTxt;
            if (slotTimeLbl.frame.origin.x<=0) {
                slotTimeLbl.frame=CGRectMake(0, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
            }else if (slotTimeLbl.frame.origin.x+slotTimeLbl.frame.size.width>=self.view.frame.size.width){
                slotTimeLbl.frame=CGRectMake(self.view.frame.size.width-slotTimeLbl.frame.size.width, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
            }
            
            slotStartPossition=XValueOfPlacardView.constant;
            SliderStartPossitionSetted=YES;
            
           
            
        }
    }else if ([[operationDict valueForKey:@"status"]integerValue]==3) {
         view.backgroundColor= [UIColor colorWithRed:236.0/255.0 green:241.0/255.0 blue:254.0/255.0 alpha:1.0];
         [self removeValuesfrom:[NSNumber numberWithFloat:viewStartPossition] To:[NSNumber numberWithFloat:viewEndPossition]];
        
    }else  if ([[operationDict valueForKey:@"status"]integerValue]==2) {
         view.backgroundColor= [UIColor colorWithRed:236.0/255.0 green:241.0/255.0 blue:254.0/255.0 alpha:1.0];
         [self removeValuesfrom:[NSNumber numberWithFloat:viewStartPossition] To:[NSNumber numberWithFloat:viewEndPossition]];

    }else  if ([[operationDict valueForKey:@"status"]integerValue]==1) {
         view.backgroundColor= [UIColor clearColor];

        if (!SliderStartPossitionSetted && widthOfServiceView>WidthOfPlaceCardView.constant) {
            XValueOfPlacardView.constant=pixelsPerOffsetValue*resultentStartIndex;
            slotTimeLbl.center = CGPointMake(XValueOfPlacardView.constant, slotTimeLbl.center.y + 0);
            NSInteger startIndex=XValueOfPlacardView.constant/pixelsPerOffsetValue;
            NSInteger endIndex=(XValueOfPlacardView.constant+WidthOfPlaceCardView.constant)/pixelsPerOffsetValue;
            
            NSString *timeDuriationTxt=[NSString stringWithFormat:@"%@-%@",[self getTimeFromOffset:startIndex],[self getTimeFromOffset:endIndex]];
            slotTimeLbl.text=timeDuriationTxt;
            
            slotTimeLbl.text=timeDuriationTxt;
            NSInteger valuMulti=(startIndex+[startTimeIndex integerValue])*5;
            NSInteger val1 = valuMulti/60;
            NSInteger valu2 = valuMulti%60;
            NSString *AMorPM1;
            if (val1>=12) {
                AMorPM1=@"PM";
            }else{
                AMorPM1=@"AM";
            }
            
            if (val1 > 12) {
                val1 -= 12;
            }
            
            
            _endTimeLBL.text=[NSString stringWithFormat:@"%02ld",(long)val1];
            _startTimeLBL.text=[NSString stringWithFormat:@"%02ld",(long)valu2];
            _startAmOrPm.text=AMorPM1;
            
            if (slotTimeLbl.frame.origin.x<=0) {
                slotTimeLbl.frame=CGRectMake(0, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
            }else if (slotTimeLbl.frame.origin.x+slotTimeLbl.frame.size.width>=self.view.frame.size.width){
                slotTimeLbl.frame=CGRectMake(self.view.frame.size.width-slotTimeLbl.frame.size.width, slotTimeLbl.frame.origin.y, slotTimeLbl.frame.size.width, slotTimeLbl.frame.size.height);
            }
            
            slotStartPossition=XValueOfPlacardView.constant;
            SliderStartPossitionSetted=YES;
        }
    }
    
    [ContentView insertSubview:view belowSubview:placardView];
    //[ContentView addSubview:view];

  
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    BookingViewController*bookingViewController = segue.destinationViewController;
    bookingViewController.appointmentDict=sender;
}
- (NSString *)gethoursFromOffset:(NSInteger) val {
    NSInteger valuMulti=(val+[startTimeIndex integerValue])*5;
    
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
     return [NSString stringWithFormat:@"%ld %@",val1,AMorPM];
   // return [NSString stringWithFormat:@"%ld:%ld %@",val1,valu2,AMorPM];
}
- (NSString *)getTimeFromOffset:(NSInteger) val {
    NSInteger valuMulti=(val+[startTimeIndex integerValue])*5;
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_serviceScrollView) {
        if (scrollView.contentOffset.x<0.0) {
            scrollView.contentOffset=CGPointMake(0, 0);
        }else if ( scrollView.contentOffset.x>=scrollView.contentSize.width){
            scrollView.contentOffset=CGPointMake(scrollView.contentSize.width, 0);
        }
    }else{
        if (scrollView.contentOffset.y<0.0) {
            scrollView.contentOffset=CGPointMake(0,0);
        }
    }
}

-(void)removeValuesfrom:(NSNumber *)from To:(NSNumber*)To{
    
   // NSMutableArray *array=[[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:10],[NSNumber numberWithInteger:11],[NSNumber numberWithInteger:12],[NSNumber numberWithInteger:13], nil];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"doubleValue > %@ AND doubleValue =< %@",from,To];
    NSArray *filteredValues = [validSlotsPossitionArray filteredArrayUsingPredicate:pred];
    [validSlotsPossitionArray removeObjectsInArray:filteredValues];
    
}
-(void)callBookingApiWithAppointmentReqModel:(AppointmentReqModel*)appointmentReqModel{
    if ([restClient rechabilityCheck]) {
        [restClient getBookingId:appointmentReqModel callBackRes:^(NSData *data, NSError *error) {
            
            NSDictionary *resDict1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([resDict1 valueForKey:@"bookingId"]) {
                    [self performSegueWithIdentifier:@"bookingPage" sender:resDict1];
                    
                }else{
                    UIAlertController * view=   [UIAlertController
                                                 alertControllerWithTitle:@"Style My Body"
                                                 message:@"Please select valid time slot"
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
                
            });
            
        
        }];
         
         
    }
}
@end
