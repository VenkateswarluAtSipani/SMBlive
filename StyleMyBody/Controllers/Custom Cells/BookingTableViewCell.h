//
//  BookingTableViewCell.h
//  StyleMyBody
//
//  Created by K venkateswarlu on 07/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceLbl;
@property (weak, nonatomic) IBOutlet UILabel *duriationLbl;
@property (weak, nonatomic) IBOutlet UILabel *costLbl;


@property (weak, nonatomic) IBOutlet UILabel *offerNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *changeOfferBtn;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLbl;


@property (weak, nonatomic) IBOutlet UILabel *internetChargeLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLbl;


@property (weak, nonatomic) IBOutlet UIView *personalDetailsShowView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceToDisplayPersonalDetails;
@property (weak, nonatomic) IBOutlet UIView *personalDetailsEditView;
@property (weak, nonatomic) IBOutlet UIButton *changePersonalDetailsBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelChangeBtn;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *mobailTxt;

@property (weak, nonatomic) IBOutlet UILabel *AddressNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *addressEditBtn;
@property (weak, nonatomic) IBOutlet UILabel *fullAddressLbl;
@property (weak, nonatomic) IBOutlet UILabel *offerTitle;








@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceToEditPersonalDetails;


@end
