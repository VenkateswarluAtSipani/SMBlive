//
//  OTPViewController.h
//  StyleMyBody
//
//  Created by sipani online on 4/21/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpResModel.h"
@interface OTPViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLbl;
@property (nonatomic, weak) IBOutlet UILabel *sendingOTPLbl;
@property (nonatomic, weak) IBOutlet UITextField *otpTF;
@property (nonatomic, weak) IBOutlet UIView *lineView;

@property (nonatomic, weak) IBOutlet UIButton *modifyBtn;
@property (nonatomic, weak) IBOutlet UIButton *resendBtn;
@property (nonatomic, strong) SignUpResModel *signUpModel;

- (IBAction)clickOnModify:(id)sender;
- (IBAction)clickOnResend:(id)sender;
@end
