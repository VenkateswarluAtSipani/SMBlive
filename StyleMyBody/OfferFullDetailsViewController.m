//
//  OfferFullDetailsViewController.m
//  StyleMyBody
//
//  Created by sipani online on 5/29/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "OfferFullDetailsViewController.h"
#import "MBProgressHUD.h"
#import "RestClient.h"
#import "OfferDetailsCell.h"
#import "OfferFullDetailModel.h"
#import "OperationHoursResModel.h"
#import <math.h>
#import "SignInDetailHandler.h"
#import "SignInViewController.h"
#import "AllStylistServiceViewController.h"
#import "SignViewController.h"
#import "BookingViewController.h"

@interface OfferFullDetailsViewController ()<UIScrollViewDelegate>
{
    __weak IBOutlet UITableView *listTblView;
    OfferFullDetailModel *offerFullDetailModel;
    NSMutableArray  *cellIdentifiers;
    NSString*subTitleLbltext;
    NSString *exPiresStr;
    NSString *validityStr;
    NSString *freeDescription;
    NSString *offerValidOnStr;
    NSString *validityTitle;
    NSString *servicesTitle;
    NSMutableAttributedString *PackageAttributeString;
    RestClient *restClient;
}
@end

@implementation OfferFullDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];

    NSString *titleStr;
    if ([self.offerType isEqualToString:@"offer"]) {
        titleStr = @"Flexi offer";
    }else{
        titleStr = @"fixed package";
    }
    self.titleLbl.text=titleStr;

   // NSLog(@"%@",offerId);
    [self callGetOffers];
    
    listTblView.estimatedRowHeight = 44.0 ;
    listTblView.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}
- (void)callGetOffers {
     MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    if ([restClient rechabilityCheck]) {
    [restClient getOfferDetails:self.offerId withCenterId:self.centerId withType:self.offerType callBackRes:^(OfferFullDetailModel *centerList, NSError *error) {
        NSLog(@"%@ === %@",centerList,error);
        
        offerFullDetailModel=centerList;
        [self setAllContentsToDisplay];
        [self getCellsIdentifiersArray];
        [listTblView reloadData];
        [self performSelector:@selector(UpdateTbl:) withObject:nil afterDelay:0.5];
        //        self.offersListArr = centerList;
        //        [self.tableView reloadData];
        [hud hideAnimated:YES];
    }];
    }
}
-(IBAction)UpdateTbl:(id)sender{
    [listTblView reloadData];
}
-(void)setAllContentsToDisplay{
    NSString *rupee=@"\u20B9";
    validityTitle=@"Validity";
    if ([self.offerType isEqualToString:@"offer"]) {

    servicesTitle=@"OFFER VALID ON FOLLOWING SERVICES"; //@"SERVICES YOU GET"
    freeDescription=offerFullDetailModel.freeDetails;
    if ([offerFullDetailModel.offerCategory integerValue]==1) {
        
        subTitleLbltext=[NSString stringWithFormat:@"Gets Rs %@ Off on Min purchase of Rs %@",offerFullDetailModel.offerTypeValue,offerFullDetailModel.offerCategoryValue];
        exPiresStr=[NSString stringWithFormat:@"Expires on %@",[self getDateWithSpecificFormat: offerFullDetailModel.offerEndValue ]];
        validityStr=[NSString stringWithFormat:@"Valid till %@",[self getDateWithSpecificFormat: offerFullDetailModel.offerEndValue ]];
    }else if ([offerFullDetailModel.offerCategory integerValue]==2) {
        
        subTitleLbltext=[NSString stringWithFormat:@"Rs %@ for any of the %@ services below",offerFullDetailModel.offerTypeValue,offerFullDetailModel.offerCategoryValue];
        exPiresStr=[NSString stringWithFormat:@"Expires on %@",[self getDateWithSpecificFormat: offerFullDetailModel.offerEndValue ]];
        validityStr=[NSString stringWithFormat:@"Valid till %@",[self getDateWithSpecificFormat: offerFullDetailModel.offerEndValue ]];
    }else if ([offerFullDetailModel.offerCategory integerValue]==3) {
        
        subTitleLbltext=[NSString stringWithFormat:@"%@ %% Off",offerFullDetailModel.offerTypeValue];
        if ([offerFullDetailModel.offerEnd integerValue]==1) {
            exPiresStr=[NSString stringWithFormat:@"Expires on %@",[self getDateWithSpecificFormat: offerFullDetailModel.offerEndValue ]];
            NSMutableString* mutableStr=[[NSMutableString alloc]init];
            int i = 0;
            for (NSDictionary *hHour in offerFullDetailModel.offerHappyHours) {
                
                NSInteger startTimeIndex=[[hHour valueForKey:@"startTimeIndex"] integerValue];
                NSInteger endIndex=[[hHour valueForKey:@"startTimeIndex"] integerValue] + [[hHour valueForKey:@"offset"] integerValue];
                
                NSString *str = [NSString stringWithFormat:@"%@   %@ to %@",[self getDayName:[[hHour valueForKey:@"opDay"] intValue]],[self getShopStartTime:startTimeIndex ],[self getShopEndTime:endIndex]];
                
                if (i == 0) {
                    [mutableStr appendString:str];
                }else {
                    [mutableStr appendString:[NSString stringWithFormat:@"\n\n%@",str]];
                }
                NSLog(@"%@",str);
                i++;
            }
            validityStr=mutableStr;
            validityTitle=@"Valid On";
            
        }else if ([offerFullDetailModel.offerEnd integerValue]==2){
            exPiresStr=[NSString stringWithFormat:@"Valid for %@ persons",offerFullDetailModel.offerEndValue];
            NSMutableString* mutableStr=[[NSMutableString alloc]init];
            int i = 0;
            for (NSDictionary *hHour in offerFullDetailModel.offerHappyHours) {
                
                NSInteger startTimeIndex=[[hHour valueForKey:@"startTimeIndex"] integerValue];
                NSInteger endIndex=[[hHour valueForKey:@"startTimeIndex"] integerValue] + [[hHour valueForKey:@"offset"] integerValue];
                
                NSString *str = [NSString stringWithFormat:@"%@   %@ to %@",[self getDayName:[[hHour valueForKey:@"opDay"] intValue]],[self getShopStartTime:startTimeIndex ],[self getShopEndTime:endIndex]];
                
                if (i == 0) {
                    [mutableStr appendString:str];
                }else {
                    [mutableStr appendString:[NSString stringWithFormat:@"\n\n%@",str]];
                }
                NSLog(@"%@",str);
                i++;
            }
            validityStr=mutableStr;
            validityTitle=@"Valid On";
            
        }
        
    }else if ([offerFullDetailModel.offerCategory integerValue]==4) {
        subTitleLbltext=[NSString stringWithFormat:@"Flat %@ %% Off",offerFullDetailModel.offerTypeValue];
        if ([offerFullDetailModel.offerEnd integerValue]==1) {
            exPiresStr=[NSString stringWithFormat:@"Expires on %@",[self getDateWithSpecificFormat: offerFullDetailModel.offerEndValue ]];
            validityStr=[NSString stringWithFormat:@"Valid till %@",[self getDateWithSpecificFormat: offerFullDetailModel.offerEndValue ]];
        }else if ([offerFullDetailModel.offerEnd integerValue]==2){
            exPiresStr=[NSString stringWithFormat:@"Valid For %@ persons",offerFullDetailModel.offerEndValue];
            
                validityStr=@"";
        }
    }
    
    }else{
        servicesTitle=@"SERVICES YOU CAN SELECT";
        NSLog(@"%@",offerFullDetailModel.packageEndType);
        
        
        NSString *price=[NSString stringWithFormat:@"%@",offerFullDetailModel.price];
        
        subTitleLbltext=[NSString stringWithFormat:@"%@ %@  %@ %@",rupee,offerFullDetailModel.discountedPrice,rupee,price];
        PackageAttributeString = [[NSMutableAttributedString alloc] initWithString:subTitleLbltext];
        NSRange rangeOfPrise=NSMakeRange(PackageAttributeString.length-([price length]+2), [price length]+2);
        
        [PackageAttributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:rangeOfPrise];
        
         [PackageAttributeString addAttribute: NSFontAttributeName value:  [UIFont fontWithName:@"Helvetica" size:15] range: rangeOfPrise];
        [PackageAttributeString addAttribute:NSForegroundColorAttributeName
                     value:[UIColor lightGrayColor]
                     range:rangeOfPrise];
        
        if ([offerFullDetailModel.packageEndType integerValue]==1) {
            
            NSString *dateStr=[NSString stringWithFormat:@"%@",offerFullDetailModel.packageEndValue];
            
            exPiresStr=[NSString stringWithFormat:@"Expires on %@",[self getDateWithSpecificFormat:dateStr]];
            validityStr=[NSString stringWithFormat:@"Valid till %@",[self getDateWithSpecificFormat:dateStr]];
        }else if ([offerFullDetailModel.packageEndType integerValue]==2){
            exPiresStr=[NSString stringWithFormat:@"Valid for %@ persons",offerFullDetailModel.packageEndValue];
        }
        
        
    }
}
-(void)getCellsIdentifiersArray{
    cellIdentifiers=[[NSMutableArray alloc]initWithObjects:@"ImageCell",@"nameCell",@"priceCell",@"expiresCell", nil];
    
    if (offerFullDetailModel.descriptio.length>0) {
        [cellIdentifiers addObject: @"descriptionCell"];
    }
    if (offerFullDetailModel.servicesOfferArray.count>0) {
        [cellIdentifiers addObject:@"serviceCell"];
    }if (validityStr.length>0) {
        [cellIdentifiers addObject:@"validityCell"];
    }
    if (freeDescription.length>0) {
        [cellIdentifiers addObject:@"shareItCell"];
    }
    if (offerFullDetailModel.stylistOfferArray.count>0) {
        [cellIdentifiers addObject:@"personCell"];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (cellIdentifiers.count) {
        return cellIdentifiers.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OfferDetailsCell *cell;
   
    NSString *identifier=[cellIdentifiers objectAtIndex:indexPath.row];
    
    if ([identifier isEqualToString:@"ImageCell"] ) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
//        UIImageView *displyaImgView = (UIImageView *)[cell viewWithTag:10];
        UISwipeGestureRecognizer *leftSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(imgLeftSwipe:)];
        leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *rightSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(imgRightSwipe:)];
        rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
        [cell.mainImgesScrollView addGestureRecognizer:leftSwipe];
        [cell.mainImgesScrollView addGestureRecognizer:rightSwipe];
        [self loadMainIngsOnScrollView:cell.mainImgesScrollView withList:offerFullDetailModel.centerCoverImagesArray];
        
       
    }else if ([identifier isEqualToString:@"nameCell"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];

        cell.nameLbl.text = offerFullDetailModel.centerName;
        cell.addressLbl.text = [NSString stringWithFormat:@"%@",offerFullDetailModel.centerAddressTwo];
        [cell.addressLbl setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    
        [RestClient loadImageinImgView:cell.secSmallImg withUrlString:offerFullDetailModel.centerLogo];
        
        
    }else if ([identifier isEqualToString:@"priceCell"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell"];
        cell.titleLbl.text=offerFullDetailModel.title;
        if ([self.offerType isEqualToString:@"offer"]) {
           cell.subTitleLbl.text=subTitleLbltext;
        }else{
            cell.subTitleLbl.attributedText=PackageAttributeString;
        }
        
        CGFloat unitHeight = [self heightForWidth:cell.subTitleLbl.frame.size.width usingFont:cell.subTitleLbl.font forStr:@"a"];
        CGFloat blockHeight = [self heightForWidth:cell.subTitleLbl.frame.size.width usingFont:cell.subTitleLbl.font forStr:subTitleLbltext];
        NSInteger numberOfLines = ceilf(blockHeight / unitHeight);
        if (numberOfLines>2) {
            cell.dPicBottomConstraint.active=NO;
        }else{
           cell.dPicBottomConstraint.active=YES;
        }
        [cell.contentView layoutIfNeeded];
        NSString *imgUrlStr=offerFullDetailModel.image;
        [RestClient loadImageinImgView:cell.mainImg withUrlString:imgUrlStr];
        
    }else if ([identifier isEqualToString:@"expiresCell"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"expiresCell"];
        cell.expiresOnlbl.text=exPiresStr;
        
    }else if ([identifier isEqualToString:@"descriptionCell"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
        cell.descriptionLbl.text=offerFullDetailModel.descriptio;
    }
    else if ([identifier isEqualToString:@"serviceCell"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
        cell.servicesTitleLb.text=servicesTitle;
        NSArray *sevicesarray=offerFullDetailModel.servicesOfferArray;
        NSMutableString *mutableStr=[[NSMutableString alloc]init];
  
        if ([self.offerType isEqualToString:@"offer"]) {
            int i = 0;
            for (NSDictionary *service in sevicesarray) {
                NSString *str = [NSString stringWithFormat:@"%@",[service valueForKey:@"name"]];
                if (i == 0) {
                    [mutableStr appendString:str];
                }else {
                    [mutableStr appendString:[NSString stringWithFormat:@"\n\n%@",str]];
                }
                NSLog(@"%@",str);
                i++;
            }

        }else{
            int i = 0;
            for (NSDictionary *service in sevicesarray) {
                NSString *str = [NSString stringWithFormat:@"%@ - %@ Sittings",[service valueForKey:@"name"],[service valueForKey:@"noOfSittings"]];
                if (i == 0) {
                    [mutableStr appendString:str];
                }else {
                    [mutableStr appendString:[NSString stringWithFormat:@"\n\n%@",str]];
                }
                NSLog(@"%@",str);
                i++;
            }
        }
        cell.servicesCanSelectLbl.text=mutableStr;
       
        
    }else if ([identifier isEqualToString:@"validityCell"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"validityCell"];
        cell.validityLbl.text=validityStr;
        cell.validityTitleLbl.text=validityTitle;
        
    }else if ([identifier isEqualToString:@"shareItCell"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"shareItCell"];
        cell.freeDescriptionLbl.text=freeDescription;
    }else if ([identifier isEqualToString:@"personCell"]) {
        //@"STYLISTS This flexi offer is applicale for below listed stylists";
        cell = [tableView dequeueReusableCellWithIdentifier:@"personCell"];
        NSMutableAttributedString *attributedString;
        if ([self.offerType isEqualToString:@"offer"]) {
            attributedString = [[NSMutableAttributedString alloc]initWithString:@"STYLISTS This flexi offer is applicale for below listed stylists"];
        }else{
           attributedString = [[NSMutableAttributedString alloc]initWithString:@"STYLISTS This fixed package is applicale for below listed stylists"];
        }
        
        
       [attributedString addAttribute: NSFontAttributeName value:  [UIFont fontWithName:@"Helvetica" size:15] range: NSMakeRange(0,8)];
        cell.personsTitleLbl.attributedText=attributedString;
        [self loadStylistListOnScrollView:cell.stylistListScroll withList:offerFullDetailModel.stylistOfferArray];

    }    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}
- (CGFloat)heightForWidth:(CGFloat)width usingFont:(UIFont *)font forStr:(NSString*)str
{
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize labelSize = (CGSize){width, FLT_MAX};
    CGRect r = [str boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
    return r.size.height;
}
- (NSString *)getDateWithSpecificFormat:(NSString *)date {
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    NSDate *dateVal = [format dateFromString:date];
    
    format.dateFormat = @"dd MMMM yyyy";
    
    return [format stringFromDate:dateVal];
    
}
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
- (NSString *)getShopStartTime:(NSInteger) val {
    NSInteger val1 = (val * 5)/60;
    NSInteger valu2 = (val * 5)%60;
    NSString *AMorPM;
    if (val1>=12) {
        AMorPM=@"PM";
    }else{
      AMorPM=@"AM";
    }
    if (val1 > 12) {
        val1 -= 12;
    }
    return [NSString stringWithFormat:@"%ld:%02ld %@",val1,(long)valu2,AMorPM];
}

- (NSString *)getShopEndTime:(NSInteger) val {
    NSInteger valuMulti=val*5;
    
    NSInteger val1 = (val * 5)/60;
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
    
    return [NSString stringWithFormat:@"%ld:%02ld %@",val1,valu2,AMorPM];
}

-(void)loadStylistListOnScrollView:(UIScrollView*)StylistScrollView withList:(NSArray *)stylistList{
    // Finding moving slider width

    CGRect serviceFrm = CGRectMake(0, 0, 180, StylistScrollView.frame.size.height);
    for (NSDictionary *stylist in stylistList) {
        UIView *serviceView = [self getStylistView:stylist :180];
        serviceView.frame = serviceFrm;
        [StylistScrollView addSubview:serviceView];
        
        serviceFrm.origin.x =serviceView.frame.origin.x+serviceView.frame.size.width+2;
    }
    StylistScrollView.contentSize = CGSizeMake(serviceFrm.origin.x, 0);
    
}
-(void)loadMainIngsOnScrollView:(UIScrollView*)StylistScrollView withList:(NSArray *)imgsArray{
    // Finding moving slider width
    
    CGRect serviceFrm = CGRectMake(0, 0, self.view.frame.size.width, StylistScrollView.frame.size.height);
    for (NSString *mainImg in imgsArray) {
        UIView *serviceView = [self getmainImgView:mainImg :StylistScrollView.frame.size.height];
        serviceView.frame = serviceFrm;
        [StylistScrollView addSubview:serviceView];
        serviceFrm.origin.x =serviceView.frame.origin.x+serviceView.frame.size.width;
    }
    StylistScrollView.contentSize = CGSizeMake(serviceFrm.origin.x, 0);
    
}


- (UIView *)getStylistView:(NSDictionary* )stylist :(int)height {
    int width = 180;
    UIView *serviceView = [[UIView alloc]init];
    //  serviceView.backgroundColor = [UIColor greenColor];
    UIImageView *profilePic=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    NSString *photoUrlStr=[stylist valueForKey:@"photo"];
    if (photoUrlStr.length>0) {
        [RestClient loadImageinImgView:profilePic withUrlString:photoUrlStr];
    }else{
        profilePic.image=[UIImage imageNamed:@"my-account"];
    }
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, 100, 20)];
    nameLbl.text = [stylist valueForKey:@"name"];
    [serviceView addSubview:nameLbl];
    [serviceView addSubview:profilePic];
    return serviceView;
}

- (UIView *)getmainImgView:(NSString* )imgUrl :(int)height {
    
    UIView *serviceView = [[UIView alloc]init];
  //  serviceView.backgroundColor = [UIColor greenColor];
    UIImageView *profilePic=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    NSString *photoUrlStr=imgUrl;
    if (photoUrlStr.length>0) {
        [RestClient loadImageinImgView:profilePic withUrlString:photoUrlStr];

    }else{
        profilePic.image=[UIImage imageNamed:@"my-account"];
    }
    [serviceView addSubview:profilePic];
        return serviceView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:indexPath,@"indexPath",@"Offer",@"FromView", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSelectCell" object:dict];
}

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

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ClaimThisOffer:(id)sender {

    SignInDetailHandler *dataHandler = [SignInDetailHandler sharedInstance];
    
    if (dataHandler.isSignin == YES) {
        if ([_offerType isEqualToString:@"offer"]) {
            AllStylistServiceViewController *serviceVC = (AllStylistServiceViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AllStylistServiceViewController"];
            
            serviceVC.headerTitle = self.offerDetailmodel.centerName;
            serviceVC.offerId=offerFullDetailModel.offerId;
            serviceVC.centerId = offerFullDetailModel.centerId;
            [self.navigationController pushViewController:serviceVC animated:YES];
        }else{
            [restClient claimPackageWithID:offerFullDetailModel.packageId callBackRes:^(BookingResponseModel *latestVersion, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BookingViewController *bookingViewController=  [self.storyboard instantiateViewControllerWithIdentifier:@"BookingViewController"];
                    bookingViewController.bookingModel=latestVersion;
                    [self.navigationController pushViewController:bookingViewController animated:YES];
                                });
             
                
            }];
        }
    }else{
        
        SignViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SIgnVC"];
        vc.viewFrom = FromOther;
        NSLog(@"%lu",(unsigned long)vc.viewFrom);
        [self.navigationController pushViewController:vc animated:NO];
    }
}

@end
