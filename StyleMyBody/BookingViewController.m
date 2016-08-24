//
//  BookingViewController.m
//  StyleMyBody
//
//  Created by sipani online on 4/29/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "BookingViewController.h"
#import "BookingTableViewCell.h"
#import "RestClient.h"
#import "APIConstants.h"
#import "BookingResponseModel.h"
#import "AddressListModel.h"
#import "AddressListModel.h"
#import "BookingOfferCell.h"
#import "BookingOfferModel.h"
#import "BookingOfferCell.h"
#import "BookingAddressView.h"
#import "ServiceResModel.h"
#import "MBProgressHUD.h"
#import "PaymentView.h"


@interface BookingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *identifiersArray;
    RestClient *restClient;
    NSString *bookingId;
    NSNumber *centerId;
    
    NSString *rupee;
    BOOL isPersonalDetailsEdditing;
   // NSMutableArray *addressArray;
    AddressListModel *selectedAddressModel;
    NSNumber *checkedAddressId;
    UITapGestureRecognizer *tap;
    NSNumber *selectedOfferId;
    NSNumber *resultAmount;
}
@end

@implementation BookingViewController
@synthesize bookingModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    rupee=@"\u20B9";
    restClient=[[RestClient alloc]init];
  //  addressArray=[[NSMutableArray alloc]init];
    [self setSectionHederViewsWithIdentifiers];
    bookingDetailsTbl.rowHeight = UITableViewAutomaticDimension;
    bookingDetailsTbl.estimatedRowHeight = 1000;
    bookingDetailsTbl.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
   
    
    if (!([bookingModel.packageId integerValue]>0)) {
        [self callAppointmentApi];
    }else{
        salonName.text=bookingModel.displayName;
        dateLbl.hidden=YES;
        timeLbl.hidden=YES;
        dateTitle.hidden=YES;
        timeTitle.hidden=YES;
        [packageTitleLbl setTitle:bookingModel.title forState:UIControlStateNormal];
    }
    
  
    
    [self setNotificationsForKeyboard];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidUpdateAddress:) name:@"DidUpdateAddress" object:nil];

}
-(void)DidUpdateAddress:(NSNotification*)notify{
    NSString *upadtedADdressId=notify.object;
    [self reloadAddress:upadtedADdressId];
}
-(void)setNotificationsForKeyboard{
  
    
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}
-(IBAction)Tapped:(id)sender{
    [self.view endEditing:YES];
}
-(IBAction)keyboardDidShow:(NSNotification*)sender{
    
    tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(Tapped:)];
    [self.view addGestureRecognizer:tap];
    
    CGRect keyboardFrame = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"keyboard frame raw %@", NSStringFromCGRect(keyboardFrame));
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
    NSLog(@"keyboard frame converted %@", NSStringFromCGRect(keyboardFrameConverted));
    
    bottomSpacetoPaymentBtn.constant=keyboardFrameConverted.size.height;
}
-(IBAction)keyboardDidHide:(NSNotification*)sender{
    bottomSpacetoPaymentBtn.constant=0;
}
-(void)callAppointmentApi{
    
    isPersonalDetailsEdditing=NO;
        if (!_fromPackage) {
            
            if ([restClient rechabilityCheck]) {
//            [restClient getBookingId:self.appointmentReqModel callBackRes:^(NSData *data, NSError *error) {
                
//                 NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
               
                    
                    bookingId=[self.appointmentDict valueForKey:@"bookingId"];
                    centerId=[self.appointmentDict valueForKey:@"centerId"];
                    if (bookingId.length>0) {
                       
                        if ([restClient rechabilityCheck]) {
                        [restClient getBookingDetails:bookingId callBackHandler:^(BookingResponseModel *model, NSError *error) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                            bookingModel=model;
                                 resultAmount=model.totalAmount;
                                selectedOfferId=bookingModel.offerId;
                                 [self callMultiOffersApi];
                                 //NSArray *array=[[bookingModel.address  objectAtIndex:0] allValues];
                                 if ([bookingModel.isHomeService integerValue]) {
                                    // addressConfirmationAddressLbl.font=[UIFont font];
                                     
                                     [restClient getAddressList:^(NSArray *addressList, NSError *error) {
                                         bookingModel.address=[NSMutableArray arrayWithArray:addressList];
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (bookingModel.address.count>0) {
                                                 
                                                 selectedAddressModel=[model.address objectAtIndex:0];
                                                 checkedAddressId=selectedAddressModel.addressId;
                                                 addressConfirmationAddressLbl.text=[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",selectedAddressModel.addressOne,selectedAddressModel.addressTwo,selectedAddressModel.city,selectedAddressModel.state,selectedAddressModel.pincode];
                                                 
                                                 [self showAddressConfirmationPopUp];
                                                
                                             }else{
                                                 [self showAddressSelectionPopUp];
                                                 selectedAddressModel=nil;
                                                 checkedAddressId=nil;
                                             }
                                             [selectAddresstbl reloadData];
                                             [bookingDetailsTbl reloadData];
                                         });
                                        
                                     }];
                                    
                                 }
                                 
                            [self setSectionHederViewsWithIdentifiers];
                            dateLbl.text=[NSString stringWithFormat:@"%@",[self getCorrectDate:model.bookingDate1]];
                               
                                 [self getCorrectDate:bookingModel.bookingDate1];
                            timeLbl.text=[NSString stringWithFormat:@"%@-%@",[self getTimeFromOffset:[bookingModel.startTimeIndex integerValue]],[self getTimeFromOffset:[bookingModel.startTimeIndex integerValue]+[bookingModel.offset integerValue]]];
                            [bookingDetailsTbl reloadData];
                             });
                        }];
                        }
                    }
//            }];
            }
        }
}
-(void)reloadDetailsWithOfferId{
    for (BookingOfferModel *offer in bookingModel.OfferModelsArray) {
        if ([offer.offerId integerValue] == [selectedOfferId integerValue]) {
            bookingModel.selectedOfferModel=offer;
            selectedOfferId=offer.offerId;
            resultAmount=[NSNumber numberWithInteger:[bookingModel.totalAmount integerValue]-[offer.discountPrice integerValue]];
            [bookingDetailsTbl reloadData];
            break;
        }
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==selectAddresstbl) {
        return 1;
    }else if (tableView==offersTblView) {
        return  1;
        
    }
    
    return identifiersArray.count+1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView==selectAddresstbl) {
        UIView *view=[[UIView alloc]init];

        return view;
    }else if (tableView==offersTblView) {
        UIView *view=[[UIView alloc]init];
        return view;
    }
    
    
    
    
    UIView *view=[[UIView alloc]init];
    if (section==0) {
        return view;
    }else{
//        NSString *identifier=[identifiersArray objectAtIndex:section-1];
//        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
//        cell.contentView.frame=CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);
//        view.frame=CGRectMake(0, 0, tableView.frame.size.width,cell.contentView.frame.size.height);
//        [view addSubview:cell.contentView];
        return view;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView==selectAddresstbl) {
        UIView *view=[[UIView alloc]init];
        return view;
    }else if (tableView==offersTblView) {
        UIView *view=[[UIView alloc]init];
        return view;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 5)];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (tableView==selectAddresstbl) {
        return  bookingModel.address.count+1;
    }else if (tableView==offersTblView) {
         return  bookingModel.OfferModelsArray.count;
   
    }else if (tableView==bookingDetailsTbl) {
        if (section==0) {
            return bookingModel.bookedServices.count;
        }else{
            return 1;
        }
    }else{
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==selectAddresstbl) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"addressCell"];

        if (indexPath.row==bookingModel.address.count) {
            if ([checkedAddressId integerValue]==0) {
                cell.imageView.image=[UIImage imageNamed:@"radio_btn_active"];
            }else{
                 cell.imageView.image=[UIImage imageNamed:@"radio_btn"];
            }
            cell.textLabel.text=@"Add New";
            
        }else{
            if (bookingModel.address.count>0) {
                
                AddressListModel* addressModel=[bookingModel.address objectAtIndex:indexPath.row];
                if ([checkedAddressId integerValue]==[addressModel.addressId integerValue]) {
                    cell.imageView.image=[UIImage imageNamed:@"radio_btn_active"];
                }else{
                    cell.imageView.image=[UIImage imageNamed:@"radio_btn"];
                }
                cell.textLabel.text=addressModel.tagName;
                
            }
        }
        heightOfSelectAddressTbl.constant=tableView.contentSize.height;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView==offersTblView) {
          BookingOfferCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BookingOfferCell"];
        BookingOfferModel *offerModel=[bookingModel.OfferModelsArray objectAtIndex:indexPath.row];
        if ([selectedOfferId integerValue]==[offerModel.offerId integerValue]) {
            cell.checkMarkImg.image=[UIImage imageNamed:@"radio_btn_active"];
        }else{
            cell.checkMarkImg.image=[UIImage imageNamed:@"radio_btn"];
        }
        cell.offerTitleLbl.text=offerModel.title;
        cell.discountLbl.text=[NSString stringWithFormat:@"- %@",offerModel.discountPrice];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    
    BookingTableViewCell *bookingCell;
    if (indexPath.section==0) {
        bookingCell=[tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
        NSDictionary *service=[bookingModel.bookedServices objectAtIndex:indexPath.row];
        bookingCell.serviceLbl.text=[service valueForKey:@"name"];
        if ([bookingModel.packageId integerValue]>0) {
            bookingCell.duriationLbl.text=[NSString stringWithFormat:@"%@ Sittings",[service valueForKey:@"noOfSittings"]];
            bookingCell.costLbl.hidden=YES;
        }else{
           bookingCell.duriationLbl.text=[NSString stringWithFormat:@"%@ mins",[service valueForKey:@"time"]];
             bookingCell.costLbl.text=[NSString stringWithFormat:@"%@ %@",rupee,[service valueForKey:@"price"]];
        }
        
       
    }else{
        NSString *identifier=[identifiersArray objectAtIndex:indexPath.section-1];
        bookingCell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if ([identifier isEqualToString:@"amountCell"]) {
            bookingCell.internetChargeLbl.text=[NSString stringWithFormat:@"%@",bookingModel.serviceTax];
            if ([bookingModel.packageId integerValue]>0) {
               bookingCell.totalAmountLbl.text=[NSString stringWithFormat:@"%@ %@",rupee,bookingModel.totalAmount];
            }else{
              bookingCell.totalAmountLbl.text=[NSString stringWithFormat:@"%@ %@",rupee,resultAmount];
            }
            
        }else if([identifier isEqualToString:@"discountCell"]){
            
            if ([bookingModel.packageId integerValue]>0) {
                bookingCell.changeOfferBtn.hidden=YES;
                bookingCell.offerTitle.text=@"Package discount";
                 bookingCell.discountPriceLbl.text=[NSString stringWithFormat:@"-%@ %ld",rupee,(long)[bookingModel.discountedPrice integerValue]];
            }else{
                if (bookingModel.OfferModelsArray.count<1) {
                     bookingCell.changeOfferBtn.hidden=YES;
                }
                bookingCell.discountPriceLbl.text=[NSString stringWithFormat:@"-%@ %ld",rupee,(long)[bookingModel.selectedOfferModel.discountPrice integerValue]];
                bookingCell.offerNameLbl.text=bookingModel.selectedOfferModel.title;
                [bookingCell.changeOfferBtn addTarget:self action:@selector(showOfferPopUp) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
           
        }
        else if([identifier isEqualToString:@"personalDetailsCell"]){
            bookingCell.nameLbl.text=bookingModel.name;
            bookingCell.phNoLbl.text=[NSString stringWithFormat:@"%@",bookingModel.phone];
            bookingCell.emailLbl.text=bookingModel.email;
            [bookingCell.editBtn addTarget:self action:@selector(EditpersonalDetails:) forControlEvents:UIControlEventTouchUpInside];
            bookingCell.editBtn.tag=indexPath.section;
            [bookingCell.changePersonalDetailsBtn addTarget:self action:@selector(PersonalDetailsChange:) forControlEvents:UIControlEventTouchUpInside];
            bookingCell.changePersonalDetailsBtn.tag=indexPath.section;
             bookingCell.cancelChangeBtn.tag=indexPath.section;
            [bookingCell.cancelChangeBtn addTarget:self action:@selector(cancelPersonalDetailsChange:) forControlEvents:UIControlEventTouchUpInside];
            
            bookingCell.firstNameTxt.text=bookingModel.name;
            bookingCell.mobailTxt.text=[NSString stringWithFormat:@"%@",bookingModel.phone];
            bookingCell.emailTxt.text=bookingModel.email;
           
            if (!isPersonalDetailsEdditing) {
                bookingCell.personalDetailsShowView.hidden=NO;
                bookingCell.bottomSpaceToEditPersonalDetails.active=NO;
                bookingCell.bottomSpaceToDisplayPersonalDetails.active=YES;
                bookingCell.personalDetailsEditView.hidden=YES;
            }else{
                bookingCell.personalDetailsShowView.hidden=YES;
                bookingCell.bottomSpaceToDisplayPersonalDetails.active=NO;
                bookingCell.bottomSpaceToEditPersonalDetails.active=YES;
                bookingCell.personalDetailsEditView.hidden=NO;
            }
        }else if ([identifier isEqualToString:@"addressCell"])
        {
           bookingCell.AddressNameLbl.text=@"Address";
            bookingCell.fullAddressLbl.textColor=[UIColor lightGrayColor];
            bookingCell.fullAddressLbl.text=[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",selectedAddressModel.addressOne,selectedAddressModel.addressTwo,selectedAddressModel.city,selectedAddressModel.state,selectedAddressModel.pincode];
            [bookingCell.addressEditBtn addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
            
            //bookingCell.AddressNameLbl
            
        }
    }
    bookingCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return bookingCell;
}
-(void)showOfferPopUp{
    offerPopUpView.hidden=NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
      if (tableView==selectAddresstbl) {
          if (indexPath.row==bookingModel.address.count) {
              checkedAddressId=nil;
          }else{
              AddressListModel *model=[bookingModel.address objectAtIndex:indexPath.row];
             checkedAddressId=model.addressId;
          }
          [selectAddresstbl reloadData];
          
      }else if (tableView==offersTblView) {

          BookingOfferModel *offerModel=[bookingModel.OfferModelsArray objectAtIndex:indexPath.row];
          if ([selectedOfferId integerValue]==[offerModel.offerId integerValue]) {
             
          }else{
              selectedOfferId=offerModel.offerId;
          }
         [offersTblView reloadData];
}
}
-(IBAction)cancelPersonalDetailsChange:(id)sender{
    
    [self EditpersonalDetails:sender];
}

-(IBAction)PersonalDetailsChange:(id)sender{
    UIButton *btn=(UIButton*)sender;
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:btn.tag];
    BookingTableViewCell *bookingCell=[bookingDetailsTbl  cellForRowAtIndexPath:indexpath];
    
    NSLog(@"name:%@ ,phone: %@, email:%@",bookingCell.firstNameTxt.text,bookingCell.phNoLbl.text,bookingCell.emailTxt.text);
    NSString* mobilNum=bookingCell.phNoLbl.text;
    if ([mobilNum integerValue]) {
        if (mobilNum.length==10) {
            if ([RestClient validateEmailWithString:bookingCell.emailTxt.text]) {
                bookingModel.name=bookingCell.firstNameTxt.text;
                 bookingModel.phone=[NSNumber numberWithInteger:[bookingCell.phNoLbl.text integerValue]];
                bookingModel.email=bookingCell.emailTxt.text;
                [self cancelPersonalDetailsChange:sender];
            }
        }
    }
}
-(IBAction)EditpersonalDetails:(id)sender{
    if (isPersonalDetailsEdditing) {
        isPersonalDetailsEdditing=NO;
    }else{
        isPersonalDetailsEdditing=YES;
    }
    UIButton *btn=(UIButton*)sender;
//    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:btn.tag];
    [bookingDetailsTbl reloadSections:[NSIndexSet indexSetWithIndex:btn.tag] withRowAnimation:UITableViewRowAnimationFade];
    //[bookingDetailsTbl reloadData];
}
-(NSMutableArray*)setSectionHederViewsWithIdentifiers{
   
    identifiersArray=[[NSMutableArray alloc]init];
    if ([bookingModel.packageId integerValue]>0) {
        [identifiersArray addObject:@"discountCell"];
    }else{
        if (bookingModel.OfferModelsArray.count>0) {
             [identifiersArray addObject:@"discountCell"];
        }
    }
    
    [identifiersArray addObject:@"amountCell"];
    [identifiersArray addObject:@"personalDetailsCell"];
    if ([bookingModel.isHomeService integerValue]) {
       [identifiersArray addObject:@"addressCell"];
    }
   
    
    
//     serviceCell
//    discountCell
//   amountCell
//     personalDetailsCell
//    addressCell
   return  identifiersArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnACtion:(id)sender {
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Style My Body"
                                 message:@"Are you sure about cancelling the process?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if ([restClient rechabilityCheck]) {
                             [restClient CancleBookingId:bookingId callBackRes:^(NSData *data, NSError *error) {
                                 
                                 NSMutableArray *viewControllers=[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                                 if (!_fromPackage) {
                                     [viewControllers removeObjectAtIndex:viewControllers.count-1];
                                     [viewControllers removeObjectAtIndex:viewControllers.count-1];
                                 }else{
                                     [viewControllers removeObjectAtIndex:viewControllers.count-1];
                                 }
                                 [self.navigationController setViewControllers:viewControllers];
                             }];
                             }
                         }];
    [view addAction:ok];
    [self presentViewController:view animated:YES completion:nil];
    
    
}
-(NSString* )getCorrectDate:(NSString*)rawDate{
    
    NSString * dateString = @"  2016-07-27T00:00:00+0530";
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    // [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date = [df dateFromString:dateString];
    //df.timeZone = [NSTimeZone systemTimeZone];
    [df setDateFormat:@"yyyy/MM/dd"] ;
    NSString *dateStr=[df stringFromDate:date];
    return dateStr;
}
- (IBAction)addressConfirmationConfirmAction:(id)sender{
    [addressConformationPopUp removeFromSuperview];
}

- (IBAction)addressConfirmationChangeAction:(id)sender{
     [addressConformationPopUp removeFromSuperview];
       [self showAddressSelectionPopUp];
}
- (IBAction)addressSelectionSelectBtnAction:(id)sender {
    if ([checkedAddressId integerValue]==0) {
        selectedAddressModel=nil;
        [self editAddress:nil];
    }else{
        for (AddressListModel *address in bookingModel.address ) {
            if ([checkedAddressId integerValue]==[address.addressId integerValue]) {
                selectedAddressModel=address;
                [bookingDetailsTbl reloadData];
                break;
            }
        }
       // selectedAddressModel=
    }
    [addressSelectionPopUpView removeFromSuperview];
}

- (IBAction)addressSelectionCancelBtnAction:(id)sender {
    [addressSelectionPopUpView removeFromSuperview];
}
-(void)showAddressConfirmationPopUp{
    addressConformationPopUp.hidden=NO;
}
-(void)showAddressSelectionPopUp{
    addressSelectionPopUpView.hidden=NO;
}
-(void)callMultiOffersApi{
    [restClient getMultiOffers:bookingModel.bookingId withOfferId:bookingModel.
     offerId callBackRes:^(NSArray *offers, NSError *error) {
     
         
        
         for (BookingOfferModel *offerModel in offers) {
             NSInteger discountAmount;
             
             
           offerModel.discountPrice=  [NSNumber numberWithInteger:[self getOfferSavePrice:offerModel]];
             
             
             
             
//             if ([offerModel.offerCategory integerValue] == 1) {
//                
//             }else if ([offerModel.offerCategory integerValue] == 2) {
//                 
//                 discountAmount=[offerModel.offerValue integerValue]*[offerModel.offerCategoryValue integerValue];
//                 
//                 offerModel.discountPrice=[NSNumber numberWithInteger:discountAmount];
//                 
//             }else if ([offerModel.offerCategory integerValue] == 3) {
//                 discountAmount=([bookingModel.totalAmount  integerValue]*[offerModel.offerValue integerValue])/100;
//                 
//                 offerModel.discountPrice=[NSNumber numberWithInteger:discountAmount];
//                 
//             }else if ([offerModel.offerCategory integerValue] == 4) {
//                 
//             }
             
         }
         bookingModel.OfferModelsArray=offers;
         [offersTblView reloadData];
         [self reloadDetailsWithOfferId];
         if (offers.count>1) {
             [self showOffersPopUp];
         }
         [self setSectionHederViewsWithIdentifiers];
         [bookingDetailsTbl reloadData];
        NSLog(@"%@",offers);

    }];
}
-(NSInteger)getOfferSavePrice:(BookingOfferModel*)offerItem{
    
    NSInteger selectedStartTime = [bookingModel.startTimeIndex integerValue];
    float amount = 0, totalAmount = 0, offerAmount = 0;
    NSInteger offerCategory = [offerItem.offerCategory integerValue];
    NSString* offerCategoryValue = offerItem.offerCategoryValue;
    NSString* offerValue = [NSString stringWithFormat:@"%@",offerItem.offerValue];
    NSInteger offerType = [offerItem.offerEnd integerValue];
    NSString* offerEndValue = offerItem.offerEndValue;
    NSMutableArray *selectedOfferServices=[[NSMutableArray alloc]init];
    
    for (NSDictionary* bookedService in bookingModel.bookedServices) {
        for (NSDictionary* offerService in offerItem.offerServices) {
            if ([[bookedService valueForKey:@"serviceId"] integerValue] == [[offerService valueForKey:@"serviceId"] integerValue]) {
                
                [selectedOfferServices addObject:bookedService];
                offerAmount += [[bookedService valueForKey:@"price"] integerValue];
            }
        }
        totalAmount += [[bookedService valueForKey:@"price"] integerValue];
    }
    
    switch (offerCategory) {
        case 1:
            if (offerAmount >= [offerCategoryValue floatValue]) {
                amount = [offerValue floatValue];
            }
            break;
        case 2:
            if ([offerCategoryValue integerValue] == selectedOfferServices.count) {
                amount = offerAmount - [offerValue floatValue];
            } else if ([offerCategoryValue integerValue] < selectedOfferServices.count) {
                NSInteger maxLen = selectedOfferServices.count;
                NSInteger minLen = [offerCategoryValue integerValue];
                
               
                NSMutableArray *offerPriceList=[[NSMutableArray alloc]init];
                
                
             
                int i;
                for ( i = 0; i < maxLen; i++) {
                    offerPriceList[i] = [NSNumber numberWithInteger:[[[selectedOfferServices objectAtIndex:i] valueForKey:@"price"] integerValue]];
                }
               // Arrays.sort(offerPriceList, Collections.reverseOrder());
                
//                NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self"
//                                                                            ascending: NO];
//                [offerPriceList sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
                
                
                NSArray *sortedArray = [offerPriceList sortedArrayUsingComparator:
                                        ^NSComparisonResult(id obj1, id obj2){
                                            return [obj2 compare:obj1];
                                        }];
                
                
                
                
                
                float noOfferAmount = 0;
                
                for (int i = 0; i < minLen; i++) {
                    noOfferAmount += [sortedArray[i] integerValue];
                }
                amount = noOfferAmount - [offerValue floatValue];
                
                
                
            }
            break;
        case 3:
            amount = offerAmount * ([offerValue floatValue] / 100);
            break;
        case 4:
            amount = offerAmount * ([offerValue floatValue] / 100);
            break;
        default:
            amount = 0;
    }
    return amount < 0 ? 0 : amount;
    
}
-(void)showOffersPopUp{
    offerPopUpView.hidden=NO;
}
-(void)hideOffersPopUp{
    offerPopUpView.hidden=YES;
}
- (IBAction)offersSelectBtnACtion:(id)sender {
    [self reloadDetailsWithOfferId];
    [offerPopUpView setHidden:YES];
    
}
- (IBAction)offersCancelBtn:(id)sender {
     [offerPopUpView setHidden:YES];
}
-(IBAction)editAddress:(id)sender{
    BookingAddressView *bookingAddressView=[self.storyboard instantiateViewControllerWithIdentifier:@"BookingAddressView"];
    bookingAddressView.addressListModel=selectedAddressModel ;
   [self.navigationController pushViewController:bookingAddressView animated:YES];
    
}
-(IBAction)reloadAddress:(id)sender{
    NSString * addressId=(NSString*)sender;
    [restClient getAddressList:^(NSArray *addressList, NSError *error) {
        bookingModel.address=[NSMutableArray arrayWithArray:addressList];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bookingModel.address.count>0) {
               //
                for (AddressListModel *model in bookingModel.address) {
                    if ([model.addressId integerValue]==[addressId integerValue]) {
                        selectedAddressModel=model;
                        break;
                    }else{
                        selectedAddressModel=[bookingModel.address objectAtIndex:0];
                    }
                }
//                selectedAddressModel=[bookingModel.address objectAtIndex:0];
//                checkedAddressId=selectedAddressModel.addressId;
                addressConfirmationAddressLbl.text=[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",selectedAddressModel.addressOne,selectedAddressModel.addressTwo,selectedAddressModel.city,selectedAddressModel.state,selectedAddressModel.pincode];
                
                //[self showAddressConfirmationPopUp];
                
            }else{
               // [self showAddressSelectionPopUp];
                selectedAddressModel=nil;
                checkedAddressId=nil;
            }
            [selectAddresstbl reloadData];
            [bookingDetailsTbl reloadData];
        });
        
    }];
}


- (IBAction)proceedToPaymentBtnAction:(id)sender {
    
    
    NSNumber *addressId=selectedAddressModel.addressId;
    if (![bookingModel.isHomeService integerValue]) {
        addressId=[NSNumber numberWithInt:0];
    }
    NSDictionary *goToPayDict=[NSDictionary dictionaryWithObjectsAndKeys:addressId,@"addressId",bookingId,@"bookingId",bookingModel.email,@"email",bookingModel.isHomeService,@"isHomeService",bookingModel.name,@"name",selectedOfferId,@"offerId",[NSNumber numberWithInt:0],@"packageId",bookingModel.phone,@"phone",resultAmount,@"totalAmount", nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the determinate mode to show task progress.
    //    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    [restClient goToPaymentWithParameters:goToPayDict callBackHandler:^(NSDictionary *response, NSError *error) {
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if (response != nil) {
                
             PaymentView*paymentView  = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentView"];
                paymentView.bookingIdDict=response;
                [self.navigationController pushViewController:paymentView animated:YES];
            }else{
                
            }

        });

        
    }];
    
    
}

@end
