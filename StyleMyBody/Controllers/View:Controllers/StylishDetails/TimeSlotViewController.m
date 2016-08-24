//
//  TimeSlotViewController.m
//  StyleMyBody
//
//  Created by sipani online on 04/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "TimeSlotViewController.h"
#import "TimeSlotTableViewCell.h"
#import "RestClient.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AllStylistsResModel.h"
#import "StylistResModel.h"
#import "StylistServiceResModel.h"
#import "StylistListTableViewCell.h"
#import "AllStylistsResModel.h"
#import "AppointmentReqModel.h"
#import "BookingViewController.h"
#import "RestClient.h"
#import "TimeSlotReqModel.h"

#define NumOfHours   14
#define slotlableWidth 1

@interface TimeSlotViewController ()<UITableViewDataSource,UITableViewDelegate>
{
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
    
    
    
    NSNumber *startIndex;
    NSNumber *shopEndIndex;
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

@implementation TimeSlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    //    slotTimeLbl.backgroundColor = [UIColor redColor];
    
    slotsPointsX=[[NSMutableArray alloc]init];
    
//    int offsetVal1 = (self.allStylistsResModel.) *5)/60;
//    
//    int timeVal1 = (timeVal * 5)/60;
//    
//    
//    int totalHrs = (12 - offsetVal1) + (timeVal1 - 12);

    
    timeValuesArr = [NSMutableArray arrayWithObjects:@"9 AM",@"10 AM",@"11 AM",@"12 PM",@"1 PM",@"2 PM",@"3 PM",@"4 PM",@"5 PM",@"6 PM",@"7 PM",@"8 PM", nil];
    
    timeValuesArr1 = [NSMutableArray arrayWithObjects:@"9",@"10",@"11",@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    
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

-(void)MakeRangeSloats{
    
    // Finding moving slider width
    int time = 0;
    CGRect serviceFrm = CGRectMake(0, 0, 180, self.serviceScrollView.frame.size.height);
    for (StylistServiceResModel *serviceModel in self.selectedServiceList) {
       UIView *serviceView = [self getServiceDetailView:serviceModel :180];
        serviceView.frame = serviceFrm;
        [self.serviceScrollView addSubview:serviceView];
        
        serviceFrm.origin.x =serviceView.frame.origin.x+serviceView.frame.size.width+2;
        
        time += [serviceModel.time  intValue];
    }
    
    self.serviceScrollView.contentSize = CGSizeMake(serviceFrm.origin.x, 0);
    
    totalGapMinitues = time;

    float contentViewWidth =  timeSlotView.frame.size.width;
    int noOfHoursToShow = (int)timeValuesArr.count;
    // int noOfSlotsToBeMade=noOfHoursToShow-1;
    
    eachSloatWidth = floor(contentViewWidth/(noOfHoursToShow));
    
    // Finding start value of slider
    int timeVal = [self.allStylistsResModel.startHour intValue];
   
    int offsetVal = [self.allStylistsResModel.offset intValue] + timeVal;
    
    int timeVal1 = (timeVal * 5)/60;
    
    int totalHrs = (12 - timeVal1) + (timeVal1 - 12);

    
//    int width = timeSlotView.frame.size.width;
//    int eachSlot = width/15;
    
    int startWidth = (timeVal1 - 7) * eachSloatWidth;
    
    startXAxisOfSilderView.constant = startWidth;
    
    NSString *startSrt = [NSString stringWithFormat:@"%d:00",timeVal1];
    
    NSString *endStr = [self getEndTime:startSrt withRange:time];
    
    self.startTimeLBL.text=[NSString stringWithFormat:@"%d",timeVal1];
    self.endTimeLBL.text=[NSString stringWithFormat:@"00"];
    
    slotTimeLbl.text = [NSString stringWithFormat:@"%@ - %@",startSrt,endStr];

//
//    float hoursVal = 0;
//    if (time > 60) {
//        hoursVal = time/60;
//    }else{
//        
//    }
    
//    NSString *endSrt = [NSString stringWithFormat:@"%@:%d",timeValuesArr1[(int)val+1],[arr[1] intValue] * 5];
    
//    slotTimeLbl.text = [NSString stringWithFormat:@"%@-%@",startSrt,endSrt];
    
    int noOfSubslots=12;
    float subSlotWidth = eachSloatWidth/noOfSubslots;
    eackSmallSlotWidth = eachSloatWidth/noOfSubslots;

    int numOfSubSlot = time/5;
    
    movingSlotWidth = numOfSubSlot*subSlotWidth;

    WidthOfPlaceCardView.constant = movingSlotWidth;
    
    int i;
    
    timeSlotView.backgroundColor = [UIColor clearColor];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, timeSlotView.frame.size.height-1, timeSlotView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [timeSlotView addSubview:lineView];
    
    for (i=0; i < noOfHoursToShow; i++) {
        
        UILabel*lbl=[[UILabel alloc] initWithFrame:CGRectMake(i*eachSloatWidth, timeSlotView.frame.size.height-15, slotlableWidth, 15)];
        //            lbl.center=CGPointMake(i*eachSloatWidth, lbl.center.y);
        lbl.backgroundColor=[UIColor blackColor];
        
        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(lbl.center.x-5, 0, 15, 20)];
        titleLbl.text= timeValuesArr[i];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.numberOfLines = 2;
        titleLbl.font = [UIFont systemFontOfSize:8];
        titleLbl.textColor = [UIColor blackColor];
        [timeSlotView addSubview:titleLbl];
        
        [timeSlotView addSubview:lbl];
        
        //            if (! (i == noOfHoursToShow)) {
        int k;
        
        float subSlotY = subSlotWidth;
        
        for (k=0; k<=noOfSubslots; k++)
        {
            UILabel *lbl1=[[UILabel alloc] init];
            
            //                    if (k == 0) {
            //
            //                    }
            subSlotY = (k * subSlotWidth);
                        
            lbl1.frame=CGRectMake(((lbl.frame.origin.x+lbl.frame.size.width))+subSlotY,timeSlotView.frame.size.height-5 , slotlableWidth, 5);
            
            lbl1.backgroundColor=[UIColor blackColor];
            
            NSNumber *yourFloatNumber = [NSNumber numberWithFloat:lbl1.center.x];
            //
            [slotsPointsX addObject:yourFloatNumber];
            
            // PreviousX=lbl.frame.origin.x+lbl.frame.size.width;
            [timeSlotView addSubview:lbl1];
        }
    }
}

- (UIView *)getServiceDetailView:(StylistServiceResModel *)serviceModel :(int)height {
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
    [self MakeRangeSloats];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    slotTimeLbl.frame = frm;
}

- (void)setBottomTimeSlotView:(int)minVal :(int)maxValue {
    
}

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
    [self setDateInDateLbls];
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
    
}

- (IBAction)dateCancelACtion:(id)sender {
    isDateAlertShown=YES;
    [self dateBtnAction:self];
    
    
}
-(IBAction)bookNowAction:(id)sender{
    
    AppointmentReqModel *appointmentReqModel=[[AppointmentReqModel alloc]init];
    appointmentReqModel.centerId=self.centerId;
    appointmentReqModel.bookingDate=selectedDate;
    appointmentReqModel.centerStylistId=0;
    appointmentReqModel.offerId=self.OfferId;
    appointmentReqModel.offset=[NSNumber numberWithInt:20];
    appointmentReqModel.packageId=0;
    appointmentReqModel.startTimeIndex=[NSNumber numberWithInt:200];
    appointmentReqModel.stylistId=0;
    appointmentReqModel.totalAmount=[NSNumber numberWithInt:200];
    appointmentReqModel.travelTime=0;
    appointmentReqModel.walkIn=0;
    
    [self performSegueWithIdentifier:@"bookingPage" sender:appointmentReqModel];
}
-(void)callDetailsOfTimeSlot{
//    1
//    centerStylistId	2
//    dateTime	2016-07-19
//    serviceId	7
//    stylistId	2
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSLog(@"%@",self.selectedServiceList);
     for (StylistServiceResModel *serviceModel in self.selectedServiceList) {
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
    [restClient getTimeSlotDetails:model callBackHandler:^(NSDictionary *appointments, NSError *error) {
        
    }];
    }
}
-(void)setUpTimeSlots{
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//      BookingViewController*bookingViewController = segue.destinationViewController;
//    bookingViewController.appointmentDict=sender;
}

@end
