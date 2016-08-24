//
//  SignUpViewController.h
//  StyleMyBody
//
//  Created by sipani online on 4/19/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LoginRequestModel.h"
#import "SocialResponseModel.h"

@class GPPSignInButton;


@interface SignUpViewController : UIViewController{
    
    __weak IBOutlet UIWebView *termsAndConditionsWebView;
    
    __weak IBOutlet UIView *passwordsView;
    __weak IBOutlet NSLayoutConstraint *passwordsViewHeight;
    
    
    __weak IBOutlet UIButton *maleBtn;
    
    __weak IBOutlet UIButton *femaleBtn;
}

@property (nonatomic, weak) IBOutlet UITextField *firstNameTF;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTF;
@property (nonatomic, weak) IBOutlet UITextField *mobileNumTF;
@property (nonatomic, weak) IBOutlet UITextField *emailTF;
@property (nonatomic, weak) IBOutlet UITextField *passwordTF;
@property (nonatomic, weak) IBOutlet UITextField *confirmPasswordTF;
@property (nonatomic, weak) IBOutlet UIButton *uploadBtn;
@property (nonatomic, weak) IBOutlet UIButton *passwordBtn;
@property (nonatomic, weak) IBOutlet UIButton *confirmPasswordBtn; 
@property (nonatomic, weak) IBOutlet UIButton *facebookBtn;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property(strong ,nonatomic) NSString *name;
@property(strong ,nonatomic) NSString *surname;
@property(strong ,nonatomic) NSString *email;
@property(strong ,nonatomic) NSString *userid;
@property(strong ,nonatomic) NSString *picurl;
@property(strong ,nonatomic) NSString *gender;
@property(strong ,nonatomic) NSString *mobileNumber;
@property (retain, nonatomic)  UIViewController *ParentView;

@property (retain, nonatomic)  SocialResponseModel *socialResponseModel;

- (IBAction)selectOnFaceBook:(id)sender;
- (IBAction)selectOnGoogle:(id)sender;
- (IBAction)selectOnUploadImg:(id)sender;
- (IBAction)selectPasswordShow:(id)sender;
- (IBAction)selectConfirmPasswordShow:(id)sender;

- (void)callSignupRequest;

@end
