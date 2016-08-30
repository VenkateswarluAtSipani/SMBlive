//
//  AllServiceStylistViewController.m
//  StyleMyBody
//
//  Created by sipani online on 5/17/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "AllServiceStylistViewController.h"
#import "ServiceTableViewCell.h"
#import "StylistListTableViewCell.h"
#import "RestClient.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AllStylistsResModel.h"
#import "StylistResModel.h"
#import "StylistServiceResModel.h"
#import "TimeSlotViewController.h"
#import "StylistOperationHourResModel.h"
#import "ServiceResModel.h"

@interface AllServiceStylistViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    int serviceCount;
    NSString *selectedDate;
    BOOL isDateAlertShown;
    MBProgressHUD *hud;
    RestClient *restClient;
}
@property (nonatomic, weak) IBOutlet UITableView *stylistTV;
@property (nonatomic, weak) IBOutlet UITableView *serviceTV;
@property (nonatomic, strong) AllStylistsResModel *allStylistsResModel;
@property (nonatomic, strong) NSArray *allServiesArr;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) NSIndexPath *selectedServiceIndex;
@property (nonatomic, strong) NSArray *serviceArr;
@property (nonatomic, strong) NSMutableArray *userSelectedService;
@property (nonatomic, strong) NSMutableArray *selectedServiceWithType;


@property (nonatomic, strong) NSMutableArray *selectedStylistArr;
@property (nonatomic, strong) NSMutableArray *selectedServiceIndexArr;

@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UILabel *selectServiceLbl;
@property (nonatomic, weak) IBOutlet UILabel *headerTitleLbl;

@property (nonatomic, assign) BOOL isServiceSelected;
@property (nonatomic, assign) BOOL isHomeOrPcgServiceSelected;




@end

@implementation AllServiceStylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];

    self.stylistTV.estimatedRowHeight = 1000;
    self.stylistTV.rowHeight = UITableViewAutomaticDimension;
    self.stylistTV.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.serviceTV.estimatedRowHeight = 1000;
    self.serviceTV.rowHeight = UITableViewAutomaticDimension;
    self.serviceTV.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.headerTitleLbl.font = [UIFont fontWithName:@"Pacifico" size:24];
    
    self.serviceArr = [NSArray array];
    self.selectedStylistArr = [NSMutableArray array];
    self.selectedServiceIndexArr = [NSMutableArray array];
    self.userSelectedService = [NSMutableArray array];
    self.bottomView.hidden = YES;
    self.selectedIndex = nil;
    self.headerTitleLbl.text = self.headerTitle;
    
    self.spaceConstraint.constant = 0;
    self.spaceConstraint1.constant = 0;
    
    [self getAllStylist];
    [self getallServices];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEEE,dd MMM"];
    NSString* dateString = [df stringFromDate:today];
    dateString = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    selectedDate=dateString;
    [self.dateBtn setTitle:selectedDate forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllStylist {
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    [restClient getAllStylists:self.centerId andOfferId:0 andDate:@"" callBackRes:^(AllStylistsResModel *allStylistsResModel, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allStylistsResModel = allStylistsResModel;
            //            NSMutableArray *tempArr = [NSMutableArray array];
            //            for (StylistResModel *stylistModel in self.allStylistsResModel.stylistResArr) {
            //
            //                [tempArr addObjectsFromArray:stylistModel.stylistServices];
            //            }
            //                for (StylistServiceResModel *serviceModel in tempArr) {
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
            //(@"%lu",(unsigned long)self.serviceArr.count);
            [self.stylistTV reloadData];
            //            [self.serviceTV reloadData];
            [self performSelector:@selector(updateAllStylist) withObject:nil afterDelay:1.0];
        });
    }];
}

- (void)updateAllStylist {
    [self.stylistTV reloadData];
    [hud hideAnimated:YES];
    
}
- (void)updateAllServices {
    [self.serviceTV reloadData];
    [hud hideAnimated:YES];
    
}

- (void)getallServices {
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud1.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    [restClient getAllServicelists:self.centerId callBackRes:^(NSArray *serviceArr, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allServiesArr = serviceArr;
            //            [self.stylistTV reloadData];
            [self.serviceTV reloadData];
            
            [hud1 hideAnimated:YES];
        });
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    if (tableView.tag == 1) {
        if (self.selectedStylistArr.count == 0) {
            row = self.allStylistsResModel.stylistResArr.count;
        }else{
            row = self.selectedStylistArr.count;
        }
    }else if (tableView.tag == 2) {
        if (self.selectedServiceWithType.count) {
            return self.selectedServiceWithType.count;
        }
        
        if (self.selectedIndex == nil) {
            row = self.allServiesArr.count;
        }else{
            row = self.serviceArr.count;
        }
    }
    return row;
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Launch reload for the two index path
//    [self ];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 1) {
        StylistListTableViewCell *cell = (StylistListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"stylistCell"];
        cell.layoutMargins=tableView.layoutMargins;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        StylistResModel *stylistModel;
        if (self.selectedStylistArr.count == 0) {
            stylistModel = self.allStylistsResModel.stylistResArr[indexPath.row];
        }else{
            stylistModel = self.selectedStylistArr[indexPath.row];
        }
        cell.titleLbl.text = stylistModel.name;
        NSArray *avilableArr = stylistModel.stylistOperationHours;
        [[cell contentView] setFrame:[cell bounds]];
        
        for (UIView* subView in cell.timeSlotView.subviews)
        {
            [subView removeFromSuperview];
        }
        if (avilableArr.count) {
            StylistOperationHourResModel *startModel = [avilableArr firstObject];
            StylistOperationHourResModel *endModel = [avilableArr lastObject];
            
            NSLayoutConstraint *widthOfTimeSlotView=[NSLayoutConstraint constraintWithItem:cell.timeSlotView
                                                                                 attribute:NSLayoutAttributeWidth
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:cell.contentView
                                                                                 attribute:NSLayoutAttributeWidth
                                                                                multiplier:0.9
                                                                                  constant:0];
            [cell.contentView addConstraint:widthOfTimeSlotView];
            //
            
            // [self setTimeSlotView:startModel.startTimeIndex  time:[endModel.startTimeIndex intValue]+[endModel.offset intValue] view:cell.timeSlotView withStatus:1];
            
            for (StylistOperationHourResModel *operationHourResModel in avilableArr) {
                
                NSLog(@"%@ %@ %@ %@",
                      operationHourResModel.opDay,
                      operationHourResModel.startTimeIndex,
                      operationHourResModel.offset,
                      operationHourResModel.status);
                //   [self setTimeSlotView:operationHourResModel.startTimeIndex  time:[operationHourResModel.startTimeIndex intValue]+[operationHourResModel.offset intValue] view:cell.timeSlotView withStatus:[operationHourResModel.status integerValue]];
                
                CGSize timeSlotViewSize=cell.timeSlotView.frame.size;
                // NSLog(@"timeSlotViewSize %f ,%f",timeSlotViewSize.width ,tableView.frame.size.width);
                NSInteger duriationHoursIndex=[self.allStylistsResModel.offset integerValue];
                // NSLog(@"duriationHoursIndex %ld",duriationHoursIndex);
                float widthForeachPixel=timeSlotViewSize.width/duriationHoursIndex;
                float widthOfSuperView=widthForeachPixel*[operationHourResModel.offset integerValue];
                float XpossitionOfSuperView=widthForeachPixel*([operationHourResModel.startTimeIndex integerValue]-[startModel.startTimeIndex integerValue]);
                UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(XpossitionOfSuperView, 0, widthOfSuperView, cell.timeSlotView.frame.size.height)];
                [cell.timeSlotView addSubview:topView];
            
                //                multiplier=multiplier/duriationHoursIndex;
                //            NSLayoutConstraint *widthOfTimeSlotView=[NSLayoutConstraint constraintWithItem:topView
                //                                                                                                 attribute:NSLayoutAttributeWidth
                //                                                                                                 relatedBy:NSLayoutRelationEqual
                //                                                                                                    toItem:cell.timeSlotView
                //                                                                                                 attribute:NSLayoutAttributeWidth
                //                                                                        multiplier:multiplier
                //                                                                                                  constant:0];
                //                            [cell.contentView addConstraint:widthOfTimeSlotView];
                //
                NSLog(@"%@,%f,%f,%f,offset:%ld,%f",stylistModel.name,topView.frame.origin.x,topView.frame.size.width,cell.timeSlotView.frame.size.width,[operationHourResModel.offset integerValue],tableView.frame.size.width );
                
                if ([operationHourResModel.status integerValue]==1) {
                    topView.backgroundColor=[UIColor colorWithRed:148.0/255.0 green:221.0/255.0 blue:160.0/255.0 alpha:1.0];
                }else if ([operationHourResModel.status integerValue]==2){
                    topView.backgroundColor=[UIColor colorWithRed:232.0/255.0 green:236.0/255.0 blue:255.0/255.0 alpha:1.0];
                }else if ([operationHourResModel.status integerValue]==3){
                    topView.backgroundColor=[UIColor clearColor];
                }else if ([operationHourResModel.status integerValue]==4){
                    topView.backgroundColor=[UIColor colorWithRed:123.0/255.0 green:178.0/255.0 blue:235.0/255.0 alpha:1.0];
                }
            }
        }
        
        if (self.selectedIndex != nil) {
            if (self.selectedIndex.row == indexPath.row) {
                cell.selectedImgView.image = [UIImage imageNamed:@"select"];
            }else{
                cell.selectedImgView.image = [UIImage imageNamed:@""];
            }
        }else{
            cell.selectedImgView.image = [UIImage imageNamed:@""];
        }
        
        cell.imgView.image = [UIImage imageNamed:@"Sample"];
        cell.morningLbl.text = [self getShopStartTime:[self.allStylistsResModel.startHour integerValue]];
        cell.eveingLbl.text = [self getShopEndTime:[self.allStylistsResModel.startHour integerValue] + [self.allStylistsResModel.offset integerValue]];
        cell.afterNoonLbl.text = [self getMiddleTime:[self.allStylistsResModel.startHour integerValue] endVal:[self.allStylistsResModel.startHour integerValue]+[self.allStylistsResModel.offset integerValue]];
        
        
        
        
        
        NSURL *url = [NSURL URLWithString:stylistModel.photo];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        StylistListTableViewCell *cell = (StylistListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"stylistCell"];
                        if (cell)
                            cell.imgView.image = image;
                    });
                }
            }
        }] ;
        [task resume];
        
        return cell;
    }
    
    ServiceTableViewCell *cell = (ServiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
    
    ServiceResModel *serviceModl;
    
    if (self.selectedServiceWithType.count) {
        serviceModl = self.selectedServiceWithType[indexPath.row];
    }else if (self.selectedIndex == nil) {
        serviceModl = self.allServiesArr[indexPath.row];
    }else{
        serviceModl = self.serviceArr[indexPath.row];
    }
    
    if (self.userSelectedService.count) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serviceId == %@",serviceModl.serviceId ];
        NSArray * arr = [self.userSelectedService filteredArrayUsingPredicate:predicate];
        
        if (arr.count) {
            cell.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:244.0/255.0 blue:218.0/255.0 alpha:1.0];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.titleLbl.text = serviceModl.name;
    cell.priceLbl.text = [NSString stringWithFormat:@"\u20B9 %@",[serviceModl.price stringValue]];
    cell.durationLbl.text = [NSString stringWithFormat:@"%@ mins" ,[serviceModl.time stringValue]];
    cell.iconsStackView.autoresizesSubviews=YES;
    
    
    BOOL isHomeService = [serviceModl.isHomeService boolValue];
    BOOL isPkgService = [serviceModl.isPackage boolValue];
    BOOL isOfferService = [serviceModl.isOffer boolValue];
    
    cell.homeIconImg.hidden = YES;
    cell.packgIconImg.hidden = YES;
    cell.offerIconImg.hidden = YES;
    cell.arrowImgView.hidden = YES;
    if (isHomeService && isPkgService && isOfferService) {
        cell.homeIconImg.image = [UIImage imageNamed:@"home-2"];
        cell.packgIconImg.image=[UIImage imageNamed:@"package"];
        cell.offerIconImg.image=[UIImage imageNamed:@"offer"];
        cell.arrowImgView.hidden = NO;
        
    } else {
        if (!isHomeService) {
            if (isPkgService) {
                int width = 20;
                cell.homeIconImg.image = [UIImage imageNamed:@"package"];
                cell.homeIconImg.hidden = NO;
                if (isOfferService) {
                    width += 20;
                    cell.packgIconImg.image=[UIImage imageNamed:@"offer"];
                    cell.packgIconImg.hidden = NO;
                }
                cell.viewWidthConstarint.constant = width;
                cell.arrowImgView.hidden = NO;
                
            }else if (isOfferService){
                cell.homeIconImg.image = [UIImage imageNamed:@"offer"];
                cell.homeIconImg.hidden = NO;
                cell.viewWidthConstarint.constant = 20;
                cell.arrowImgView.hidden = NO;
            }
        }else{
            cell.homeIconImg.image = [UIImage imageNamed:@"home-2"];
            cell.homeIconImg.hidden = NO;
            cell.arrowImgView.hidden = NO;
            
            int width = 20;
            cell.viewWidthConstarint.constant = width;
            if (isPkgService) {
                cell.packgIconImg.image = [UIImage imageNamed:@"package"];
                cell.packgIconImg.hidden = NO;
                width += 20;
                if (isOfferService) {
                    width += 20;
                    cell.offerIconImg.image=[UIImage imageNamed:@"offer"];
                    cell.offerIconImg.hidden = NO;
                }
                cell.viewWidthConstarint.constant = width;
                cell.arrowImgView.hidden = NO;
                
            }else if (isOfferService){
                width += 20;
                cell.packgIconImg.image = [UIImage imageNamed:@"offer"];
                cell.packgIconImg.hidden = NO;
                cell.viewWidthConstarint.constant = width;
                cell.arrowImgView.hidden = NO;
                cell.viewWidthConstarint.constant = 40;
                
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        
        StylistResModel *stylistResModel = self.allStylistsResModel.stylistResArr[indexPath.row];
        
        NSMutableArray *selectedServiceArr = [NSMutableArray array];
        for (StylistServiceResModel *stylistModel in stylistResModel.stylistServices) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serviceId == %@",stylistModel.serviceId ];
            NSArray * arr = [self.allServiesArr filteredArrayUsingPredicate:predicate];
            [selectedServiceArr addObjectsFromArray:arr];
            NSLog(@"%@",arr);
        }
        self.serviceArr = [NSArray arrayWithArray:selectedServiceArr];
        
        
        if (self.selectedIndex != nil) {
            if (indexPath.row == self.selectedIndex.row) {
                self.selectedIndex = nil;
                self.bottomView.hidden = YES;
                self.spaceConstraint.constant = 0;
                self.spaceConstraint1.constant = 0;
                [self.selectedServiceWithType removeAllObjects];
                [self.selectedStylistArr removeAllObjects];
                [self.userSelectedService removeAllObjects];
                
            }else{
                StylistResModel *stylistModel = self.allStylistsResModel.stylistResArr[indexPath.row];
                
                self.selectedIndex = indexPath;
                self.bottomView.hidden = NO;
                self.spaceConstraint.constant = 51;
                self.spaceConstraint1.constant = 51;
                
                self.selectServiceLbl.text = [NSString stringWithFormat:@"%lu Services from %@",(unsigned long)self.selectedServiceIndexArr.count, stylistModel.name];
            }
        }else{
            StylistResModel *stylistModel = self.allStylistsResModel.stylistResArr[indexPath.row];
            
            self.selectedIndex = indexPath;
            self.bottomView.hidden = NO;
            self.spaceConstraint.constant = 51;
            self.spaceConstraint1.constant = 51;
            
            self.selectServiceLbl.text = [NSString stringWithFormat:@"%lu Services from %@",(unsigned long)self.selectedServiceIndexArr.count, stylistModel.name];
        }
        
        [self.stylistTV reloadData];
        [self.serviceTV reloadData];
    }else{
        
        //        [self.selectedServiceWithType removeAllObjects];
        
        //        self.isServiceSelected = !self.isServiceSelected;
        
        
        ServiceResModel *serviceModl;
        
        
        if (self.selectedServiceWithType.count) {
            serviceModl = self.selectedServiceWithType[indexPath.row];
        }else{
            if (self.selectedIndex == nil) {
                serviceModl = self.allServiesArr[indexPath.row];
            }else{
                serviceModl = self.serviceArr[indexPath.row];
            }
        }
        
        if (serviceModl.isHomeService) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isHomeService == %@",serviceModl.isHomeService ];
            NSArray * arr = [self.allServiesArr filteredArrayUsingPredicate:predicate];
            NSLog(@"%@",arr);
            self.selectedServiceWithType = [NSMutableArray arrayWithArray:arr];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isHomeService == %@",serviceModl.isHomeService ];
            NSArray * arr = [self.allServiesArr filteredArrayUsingPredicate:predicate];
            NSLog(@"%@",arr);
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.allServiesArr];
            [tempArr removeObjectsInArray:arr];
            self.selectedServiceWithType = [NSMutableArray arrayWithArray:tempArr];
        }
        
        if (self.userSelectedService.count) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serviceId == %@",serviceModl.serviceId ];
            NSArray * arr = [self.userSelectedService filteredArrayUsingPredicate:predicate];
            
            if (arr.count) {
                [self.userSelectedService removeObject:arr[0]];
            }else{
                [self.userSelectedService addObject:serviceModl];
            }
        }else{
            [self.userSelectedService addObject:serviceModl];
        }
        
        
        for (StylistResModel *styleModel in self.allStylistsResModel.stylistResArr) {
            for (StylistServiceResModel *serModel in styleModel.stylistServices) {
                if (serModel.serviceId == serviceModl.serviceId) {
                    if (![self.selectedStylistArr containsObject:styleModel]) {
                        [self.selectedStylistArr addObject:styleModel];
                    }
                }
            }
        }
        
        if (!self.userSelectedService.count && self.selectedIndex == nil) {
            [self.selectedServiceWithType removeAllObjects];
            [self.selectedStylistArr removeAllObjects];
        }
        
        
        [self.stylistTV reloadData];
        [self.serviceTV reloadData];
    }
}

- (void)setTimeSlotView:(NSNumber *)offset time:(int)time view:(UIView *)timeSlotView withStatus:(NSInteger)status{
    int timeVal = time ;
    //    int offsetVal = [offset intValue] + timeVal;
    int offsetVal = [offset intValue];
    
    int offsetVal1 = (offsetVal *5)/60;
    
    int timeVal1 = (timeVal * 5)/60;
    
    
    int totalHours = ([self.allStylistsResModel.offset intValue]*5)/60;
    
    //    int totalHrs = (12 - offsetVal1) + (timeVal1 - 12);
    
    int width = timeSlotView.frame.size.width;
    
    int eachSlot = width/totalHours;
    
    int startWidth = (offsetVal1 - offsetVal1) * eachSlot;
    
    int endWidth = (timeVal1-offsetVal1) * eachSlot;
    
    [timeSlotView addSubview:[self getAvilableTimeSlotView:startWidth totalWidth:endWidth view:timeSlotView.frame withStatus:status]];
}

- (UIView *)getAvilableTimeSlotView:(int )xAxis totalWidth:(int)totalWidth view:(CGRect)frm withStatus:(NSInteger)status {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(xAxis, 0, totalWidth, frm.size.height)];
    if (status==0) {
        view.backgroundColor=[UIColor redColor];
    }else if(status==1){
        view.backgroundColor = [UIColor colorWithRed:148.0/255.0 green:221.0/255.0 blue:160.0/255.0 alpha:1.0];
        
    }else if(status==2){
        view.backgroundColor=[UIColor blueColor];
        
    }else if(status==3){
        view.backgroundColor=[UIColor lightGrayColor];
    }
    
    
    return view;
}

- (IBAction)clickOnBack:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectTimeSlot:(id)sender {
    if (self.userSelectedService.count) {
        [self performSegueWithIdentifier:@"TimeSlotVC" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TimeSlotVC"]) {
        TimeSlotViewController * controller = segue.destinationViewController;
        StylistResModel *stylistModel;
        
        if (self.selectedStylistArr.count == 0) {
            stylistModel = self.allStylistsResModel.stylistResArr[self.selectedIndex.row];
        }else{
            stylistModel = self.selectedStylistArr[self.selectedIndex.row];
        }
        //        if (self.userSelectedService.count == 0) {
        //            stylistModel = self.allStylistsResModel.stylistResArr[self.selectedIndex.row];
        //        }else{
        //            stylistModel = self.selectedStylistArr[self.selectedIndex.row];
        //        }
        
        controller.selectedStylistModel = stylistModel;
        controller.allStylistsResModel = self.allStylistsResModel;
        
        //        StylistServiceResModel *serviceModel;
        //        if (self.selectedIndex == nil) {
        //            serviceModel = self.serviceArr[indexPath.row];
        //        }else{
        //            StylistResModel *stylistModel = self.allStylistsResModel.stylistResArr[self.selectedIndex.row];
        //            serviceModel = stylistModel.stylistServices[indexPath.row];
        //        }
        
        
        //        NSMutableArray *arr = [NSMutableArray array];
        
        //        StylistServiceResModel *serviceModel;
        //
        //
        //        for (NSIndexPath *index in self.selectedServiceIndexArr) {
        //            if (self.selectedIndex == nil) {
        //                serviceModel = self.serviceArr[index.row];
        //            }else{
        //                StylistResModel *stylistModel = self.allStylistsResModel.stylistResArr[self.selectedIndex.row];
        //                serviceModel = stylistModel.stylistServices[index.row];
        //            }
        //            [arr addObject:serviceModel];
        //        }
        
        controller.selectedServiceList = self.userSelectedService;
        
    }
}

- (NSString *)getShopStartTime:(NSInteger) val {
    NSInteger val1 = (val * 5)/60;
    NSInteger valu2 = (val * 5)%60;
    return [NSString stringWithFormat:@"%ld:%02ld AM",val1,(long)valu2];
}

- (NSString *)getShopEndTime:(NSInteger) val {
    NSInteger valuMulti=val*5;
    
    NSInteger val1 = (val * 5)/60;
    NSInteger valu2 = valuMulti%60;
    if (val1 > 12) {
        val1 -= 12;
    }
    return [NSString stringWithFormat:@"%ld:%ld PM",val1,valu2];
}

-(NSString *)getMiddleTime:(NSInteger)startVal endVal:(NSInteger)endVal {
    float val = (startVal * 5)/60;
    float val1 = (endVal * 5)/60;
    
    NSInteger val2 = (val+val1)/2;
    
    NSString *str = @"";
    if (val2 > 12) {
        val2 -= 12;
        str = @"PM";
    }else if (val2 == 12){
        str = @"PM";
    }
    else{
        str = @"AM";
    }
    return [NSString stringWithFormat:@"%ld %@",val2,str];
    
}
-(void)viewWillAppear:(BOOL)animated{
    isDateAlertShown=NO;
    self.datePickerBlurBtn.alpha=0.0;
    _dateAlertView.hidden=YES;
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
    isDateAlertShown=YES;
    [self dateBtnAction:self];
    
}

- (IBAction)dateCancelACtion:(id)sender {
    isDateAlertShown=YES;
    [self dateBtnAction:self];
    
    
}
@end
