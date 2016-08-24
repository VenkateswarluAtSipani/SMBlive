//
//  AllStylistServiceViewController.m
//  StyleMyBody
//
//  Created by macbook on 03/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "AllStylistServiceViewController.h"
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
#import "NewTimeSlotViewController.h"

@interface AllStylistServiceViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    RestClient *restClient;
    int serviceCount;
    NSString *selectedDate;
    BOOL isDateAlertShown;
    MBProgressHUD *hud;
}
@property (nonatomic, weak) IBOutlet UITableView *stylistTV;
@property (nonatomic, weak) IBOutlet UITableView *serviceTV;
@property (nonatomic, strong) AllStylistsResModel *allStylistsResModel;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UILabel *selectServiceLbl;
@property (nonatomic, weak) IBOutlet UILabel *headerTitleLbl;
@property (nonatomic , strong) NSArray *allStylistArray;
@property (nonatomic , strong) NSArray *allServicesArray;
@property (nonatomic, strong) NSMutableArray *stylistsToDisplay;
@property (nonatomic, strong) NSMutableArray *servicesToDisplay;
@property (nonatomic, strong) NSMutableArray *selectedServicesArray;
@property (nonatomic, strong) NSString *isHomeSeviceSelected;
@property (nonatomic, strong) NSString* selectedStylistId;
@property (nonatomic, strong) NSIndexPath *serviceSelectedId;///to Adjust Scrolling possition
@property (nonatomic, assign) BOOL isStylistPossitionAdjusted;
@end

@implementation AllStylistServiceViewController

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
    
  
    self.headerTitleLbl.text = self.headerTitle;
    
    self.spaceConstraint.constant = 0;
    self.spaceConstraint1.constant = 0;
    
    [self getAllStylistWithDate:@""];
    [self getallServices];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEEE,dd MMM"];
    NSString* dateString = [df stringFromDate:today];
    dateString = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    [datePicker setMinimumDate:today];
    selectedDate=dateString;
    [self.dateBtn setTitle:selectedDate forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
     [self handleBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllStylistWithDate:(NSString*)dateStr {
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    if ([restClient rechabilityCheck]) {
    [restClient getAllStylists:self.centerId andOfferId:self.offerId andDate:dateStr callBackRes:^(AllStylistsResModel *allStylistsResModel, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _selectedStylistId=@"";
            _isHomeSeviceSelected=@"";
            _selectedServicesArray=[[NSMutableArray alloc]init];

            self.allStylistsResModel = allStylistsResModel;
            self.allStylistArray=allStylistsResModel.stylistResArr;
            self.stylistsToDisplay=[[NSMutableArray alloc]initWithArray:allStylistsResModel.stylistResArr];
             [self.stylistTV reloadData];
            [self performSelector:@selector(updateAllStylist) withObject:nil afterDelay:1.0];
        });
    }];
    }
}

- (void)updateAllStylist {
    [self.stylistTV reloadData];
    [hud hideAnimated:YES];
}

- (void)getallServices {
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud1.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    if ([restClient rechabilityCheck]) {
    [restClient getAllServicelistsWithoutGroups:self.centerId callBackRes:^(NSArray *serviceArr, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.allServicesArray=serviceArr;
            //            [self.stylistTV reloadData];
            self.servicesToDisplay=[[NSMutableArray alloc]initWithArray:serviceArr];
            [self.serviceTV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            
            [hud1 hideAnimated:YES];
        });
    }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    if (tableView.tag==1) {
        row=_stylistsToDisplay.count;
    }else{
        row=_servicesToDisplay.count;
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
        stylistModel=[_stylistsToDisplay objectAtIndex:indexPath.row];
        cell.titleLbl.text = stylistModel.name;
        NSArray *avilableArr = stylistModel.stylistOperationHours;
        [[cell contentView] setFrame:[cell bounds]];
        cell.contentView.backgroundColor=[UIColor clearColor];
        if ([stylistModel.stylistId integerValue]==[_selectedStylistId integerValue]) {
            cell.selectedImgView.hidden=NO;
            if (!_isStylistPossitionAdjusted) {
                double delayInSeconds = 0.1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [tableView scrollToRowAtIndexPath:indexPath
                                     atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                });
                _isStylistPossitionAdjusted=YES;
            }
            
        }else{
            cell.selectedImgView.hidden=YES;
        }
        
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
   
        UIImageView *ratingImgView = (UIImageView *)[cell viewWithTag:143];
        ratingImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Rating-%d",[stylistModel.rating intValue]]];
        cell.imgView.image = [UIImage imageNamed:@"Sample"];
        cell.morningLbl.text = [self getShopStartTime:[self.allStylistsResModel.startHour integerValue]];
        cell.eveingLbl.text = [self getShopEndTime:[self.allStylistsResModel.startHour integerValue] + [self.allStylistsResModel.offset integerValue]];
        cell.afterNoonLbl.text = [self getMiddleTime:[self.allStylistsResModel.startHour integerValue] endVal:[self.allStylistsResModel.startHour integerValue]+[self.allStylistsResModel.offset integerValue]];
        
        [RestClient loadImageinImgView: cell.imgView withUrlString:stylistModel.photo];
        
        return cell;
    }
    ServiceTableViewCell *cell = (ServiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
    ServiceResModel *serviceModl;
    serviceModl=[_servicesToDisplay objectAtIndex:indexPath.row];
    cell.titleLbl.text = serviceModl.name;
    cell.priceLbl.text = [NSString stringWithFormat:@"\u20B9 %@",[serviceModl.price stringValue]];
    cell.durationLbl.text = [NSString stringWithFormat:@"%@ mins" ,[serviceModl.time stringValue]];
    cell.iconsStackView.autoresizesSubviews=YES;
    BOOL isHomeService = [serviceModl.isHomeService boolValue];
    BOOL isPkgService = [serviceModl.isPackage boolValue];
    BOOL isOfferService = [serviceModl.isOffer boolValue];
    
    ////-----selction and unselction ----///
    cell.contentView.backgroundColor=[UIColor clearColor];
    int serviceIndex;
    for (serviceIndex=0;serviceIndex<_selectedServicesArray.count;serviceIndex++) {
        NSNumber *seectedServiceId=[_selectedServicesArray objectAtIndex:serviceIndex];
        if ([serviceModl.serviceId integerValue]== [seectedServiceId integerValue]) {
            NSLog(@"selectedIndex:%ld,selcted Id:%ld",[serviceModl.serviceId integerValue],indexPath.row);
            cell.contentView.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:244.0/255.0 blue:218.0/255.0 alpha:1.0];
            break;
        }
    }

     ////-----selction and unselction ----///
    

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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)filterServicesAndStylistBasedOnServiceSelctionAmong:(NSArray *)ServicesArray{
    
    //----To filter Services according to selected Service Type---------//
     _servicesToDisplay=[[NSMutableArray alloc]init];
    NSMutableArray *mutServicesArray=[[NSMutableArray alloc]init];
    NSMutableArray *mutServicesIDArray=[[NSMutableArray alloc]init];
        
    if ([_isHomeSeviceSelected isEqualToString:@"1"]) {
        for (ServiceResModel *serviceModel in ServicesArray) {
            if ([serviceModel.isHomeService integerValue]==1) {
                [mutServicesArray addObject:serviceModel];
                [mutServicesIDArray addObject:serviceModel.serviceId];
            }else{
                
            }
        }
    }else if ([_isHomeSeviceSelected isEqualToString:@"0"]) {
        for (ServiceResModel *serviceModel in ServicesArray) {
            if ([serviceModel.isHomeService integerValue]==0) {
                [mutServicesArray addObject:serviceModel];
                [mutServicesIDArray addObject:serviceModel.serviceId];
            }else{
                
            }
        }
    }else if ([_isHomeSeviceSelected isEqualToString:@""]){
        mutServicesArray=[NSMutableArray arrayWithArray:ServicesArray];
        for (ServiceResModel *serviceModel in ServicesArray) {
            [mutServicesIDArray addObject:serviceModel.serviceId];
        }
    }
        
    _servicesToDisplay=mutServicesArray;
    NSMutableArray *mutStylistArray=[[NSMutableArray alloc]init];
    //----To filter Stylist according to list of Services---------//
    for (StylistResModel *stylistModel in _allStylistArray) {
    
        NSMutableSet *set1 = [NSMutableSet setWithArray:stylistModel.servicesIdArray];
        NSMutableSet *set2 = [NSMutableSet setWithArray:mutServicesIDArray];
        [set1 intersectSet:set2]; //this will give you only the obejcts that are in both sets
        NSArray *commonItems = [set1 allObjects];
        if (commonItems.count>0) {
            [mutStylistArray addObject:stylistModel];
            NSLog(@"idsArray: %@,%@",mutServicesIDArray,stylistModel.servicesIdArray);
        }
    }
    if ([_isHomeSeviceSelected isEqualToString:@""]&& ![_selectedStylistId isEqualToString:@""]) {
        _stylistsToDisplay=[NSMutableArray arrayWithArray:_allStylistArray];
    }else{
         _stylistsToDisplay=mutStylistArray;
    }
   
    
    NSMutableSet *set1 = [NSMutableSet setWithArray:_selectedServicesArray];
    NSMutableSet *set2 = [NSMutableSet setWithArray:mutServicesIDArray];
    [set1 intersectSet:set2]; //this will give you only the obejcts that are in both sets
    NSArray *commonItems = [set1 allObjects];
    _selectedServicesArray=[NSMutableArray arrayWithArray:commonItems];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.serviceTV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
         [self.stylistTV reloadData];
    });

   
}
-(NSMutableArray *)getServicesFromStylistModel:(StylistResModel*)stylistModel orStylistId:(NSString *)styListId{
    
     NSMutableArray *servicesMutArray=[[NSMutableArray alloc]init];
    if ([styListId isEqualToString:@""]) {
        NSArray *servicesIdArray=stylistModel.servicesIdArray;
       
        for (ServiceResModel *serviceModel in _allServicesArray) {
            if ([servicesIdArray containsObject:serviceModel.serviceId]) {
                [servicesMutArray addObject:serviceModel];
            }
        }
        return servicesMutArray;
    }else{
        
        for (StylistResModel *stylist in _allStylistArray) {
            if ([stylist.stylistId integerValue]==[styListId integerValue] ) {
                NSArray *servicesIdArray=_selectedServicesArray;
                for (ServiceResModel *serviceModel in _allServicesArray) {
                    if ([servicesIdArray containsObject:serviceModel.serviceId]) {
                        [servicesMutArray addObject:serviceModel];
                    }
                }
            }
        }
    }
    return servicesMutArray;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        _isStylistPossitionAdjusted=NO;
        StylistResModel *stylistResModel = [_stylistsToDisplay objectAtIndex:indexPath.row];
        if ([stylistResModel.stylistId integerValue]== [_selectedStylistId integerValue]) {
            _selectedStylistId=@"";
            if (_selectedServicesArray.count) {
               [self filterServicesAndStylistBasedOnServiceSelctionAmong:_allServicesArray];
            }else{
                _servicesToDisplay=[NSMutableArray arrayWithArray:_allServicesArray];
                _stylistsToDisplay=[NSMutableArray arrayWithArray:_allStylistArray];
            }
            
        }else{
            _selectedStylistId=[NSString stringWithFormat:@"%ld",[stylistResModel.stylistId integerValue]];
            
            if (_selectedServicesArray.count) {
                
                NSMutableSet *set1 = [NSMutableSet setWithArray:_selectedServicesArray];
                NSMutableSet *set2 = [NSMutableSet setWithArray:stylistResModel.servicesIdArray];
                [set1 intersectSet:set2]; //this will give you only the obejcts that are in both sets
                NSArray *commonItems = [set1 allObjects];
                _selectedServicesArray=[NSMutableArray arrayWithArray:commonItems];
               
            }
            
            if (_selectedServicesArray.count) {
                
               [self filterServicesAndStylistBasedOnServiceSelctionAmong:[self getServicesFromStylistModel:stylistResModel orStylistId:@""]];
            }else{
                
              _servicesToDisplay=[self getServicesFromStylistModel:stylistResModel orStylistId:@""];
                
            }
            
        }
       
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.serviceTV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
             [self.stylistTV reloadData];
        });

        
        
    }else{
        
        ServiceResModel *serviceModel = [_servicesToDisplay objectAtIndex:indexPath.row];
        bool isServiceIdRemoved=NO;
        int serviceIndex;
        for (serviceIndex=0;serviceIndex<_selectedServicesArray.count;serviceIndex++) {
            NSNumber *seectedServiceId=[_selectedServicesArray objectAtIndex:serviceIndex];
            if ([serviceModel.serviceId integerValue]== [seectedServiceId integerValue]) {
                isServiceIdRemoved=YES;
                [_selectedServicesArray removeObjectAtIndex:serviceIndex];
            }
        }
        if (!isServiceIdRemoved) {
           [_selectedServicesArray addObject:serviceModel.serviceId];
        }
        
        if (_selectedServicesArray.count>0) {
            ServiceResModel *serviceModl=[_servicesToDisplay objectAtIndex:indexPath.row];
            if ([serviceModl.isHomeService integerValue]==1) {
                _isHomeSeviceSelected=@"1";
            }else{
                _isHomeSeviceSelected=@"0";
            }
        if (_selectedServicesArray.count>0) {
            [self filterServicesAndStylistBasedOnServiceSelctionAmong:_servicesToDisplay];
        }else{
           [self filterServicesAndStylistBasedOnServiceSelctionAmong:_allServicesArray];
       }
        
        }else{
          _isHomeSeviceSelected=@""; //No service is selcted ...... so it will depend on selcetdStylist Only  type
           // _servicesToDisplay=[NSMutableArray arrayWithArray:_allServicesArray];
            StylistResModel *stylist=[self getStylistFromListWithId:_selectedStylistId];
            if (stylist) {
              [self filterServicesAndStylistBasedOnServiceSelctionAmong:[self getServicesFromStylistModel:stylist orStylistId:@""]];
            }else{
                [self filterServicesAndStylistBasedOnServiceSelctionAmong:_allServicesArray];
            }
            
        }
        
    }
    [self handleBottomView];
}
-(StylistResModel*)getStylistFromListWithId:(NSString*)stylistId{
    if ([stylistId isEqualToString:@""]) {
        
    }else{
        for (StylistResModel *stylistModel in _allStylistArray) {
            if ([stylistModel.stylistId integerValue]==[stylistId integerValue]) {
                return stylistModel;
            }
        }
    }
    return nil;
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

-(void)handleBottomView{
    StylistResModel *stylist=[self getStylistFromListWithId:_selectedStylistId];
    if (stylist) {
        _heightOfBottomView.constant=50;
        _bottomView.hidden=NO;
        NSString *displayTxt=[NSString stringWithFormat:@"%ld Service from %@",_selectedServicesArray.count,stylist.name];
        NSLog(@"%@",displayTxt);
        _selectServiceLbl.text=displayTxt;
        
    }else{
        _heightOfBottomView.constant=0;
        _bottomView.hidden=YES;
    }
}
- (IBAction)selectTimeSlot:(id)sender {
    if (_selectedServicesArray.count>0 && ![_selectedStylistId isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"TimeSlotVC" sender:nil];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TimeSlotVC"]) {
        NewTimeSlotViewController * controller = segue.destinationViewController;
        ;
        for (StylistResModel *stylistModel in _stylistsToDisplay) {
            if ([stylistModel.stylistId integerValue]==[_selectedStylistId integerValue]) {
                controller.selectedStylistModel = stylistModel;
                break;
            }
        }
        controller.centerId=self.centerId;
        controller.OfferId=self.offerId;
        controller.allStylistsResModel = self.allStylistsResModel;
        controller.dateSelectedInPreviousPage=datePicker.date;
        
        NSMutableArray *servicesArray=[[NSMutableArray alloc]init];
      
            for (ServiceResModel *service in _allServicesArray) {
                if ([_selectedServicesArray containsObject:service.serviceId]) {
                    [servicesArray addObject:service];
                }
            }
        controller.selectedServiceListinSplit = servicesArray;
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
    
    
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE,dd MMM"];
    dateString = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    selectedDate=dateString;
}

- (IBAction)dateSelectACtion:(id)sender {
    
    [self.dateBtn setTitle:selectedDate forState:UIControlStateNormal];
    isDateAlertShown=YES;
    [self dateBtnAction:self];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [self getAllStylistWithDate:[NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]]];
   
    [_serviceTV reloadData];
}

- (IBAction)dateCancelACtion:(id)sender {
    isDateAlertShown=YES;
    [self dateBtnAction:self];
    
    
}
@end

