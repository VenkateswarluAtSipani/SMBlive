//
//  BookingViewController.h
//  StyleMyBody
//
//  Created by sipani online on 4/29/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentReqModel.h"
#import "StylistResModel.h"
#import "BookingResponseModel.h"

@interface BookingViewController : UIViewController
{
    __weak IBOutlet UILabel *salonName;
    
    __weak IBOutlet UILabel *dateLbl;
    
    __weak IBOutlet UILabel *timeLbl;
    
    __weak IBOutlet UITableView *bookingDetailsTbl;
    
    __weak IBOutlet NSLayoutConstraint *bottomSpacetoPaymentBtn;
    
    
    __weak IBOutlet UIView *addressConformationPopUp;
    __weak IBOutlet UIButton *addressConfirmationBlurBtn
    ;
    __weak IBOutlet UILabel *addressConfirmationAddressLbl;
   __weak IBOutlet UIButton * addressConfirmationConfirm;
    __weak IBOutlet UIButton *addressConfirmationChange;
    
    
    __weak IBOutlet UIView *addressSelectionPopUpView;
    __weak IBOutlet UIView *addressSelectionBlurBtn;
    
    __weak IBOutlet UITableView *selectAddresstbl;
   
    __weak IBOutlet NSLayoutConstraint *heightOfSelectAddressTbl;
    
    
    __weak IBOutlet UIButton *addressSelectionSelectBtn;
     __weak IBOutlet UIButton *addressSelectionCancelBtn;
    
    
    
    __weak IBOutlet UIView *offerPopUpView;
    
    
    __weak IBOutlet UITableView *offersTblView;
    __weak IBOutlet UIButton *offerBlurBtn;
    
    
    __weak IBOutlet UIButton *offersSelectBtn;
    
    
    __weak IBOutlet UIButton *offersCancelBtn;
    
    __weak IBOutlet UILabel *dateTitle;
    
    __weak IBOutlet UILabel *timeTitle;
    
 
    __weak IBOutlet UIButton *packageTitleLbl;
    
}
- (IBAction)addressSelectionSelectBtnAction:(id)sender;
- (IBAction)addressConfirmationConfirmAction:(id)sender;

- (IBAction)addressConfirmationChangeAction:(id)sender;

- (IBAction)addressSelectionCancelBtnAction:(id)sender;


@property (nonatomic,strong)BookingResponseModel *bookingModel;
@property (nonatomic,strong)NSDictionary *appointmentDict;

//@property (nonatomic,strong)NSArray *SelectedServicesArray;
//@property (nonatomic,strong)StylistResModel *stylist;
//@property (nonatomic,strong)NSString *bookingDate;
//@property (nonatomic,strong)NSNumber *centerId;
//@property (nonatomic,strong)NSNumber *offerId;
//@property (nonatomic,strong)NSNumber *startTimeIndex;
//@property (nonatomic,strong)NSNumber *offset;
//@property (nonatomic,strong)NSNumber *packageId;
//@property (nonatomic,strong)NSNumber *totalAmount;
//@property (nonatomic,strong)NSNumber *travelTime;
//@property (nonatomic,strong)NSNumber *walkIn;

@property (nonatomic,assign)bool fromPackage;

- (IBAction)backBtnACtion:(id)sender;

@end
