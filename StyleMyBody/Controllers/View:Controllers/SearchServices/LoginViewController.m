//
//  LoginViewController.m
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginResponseModel.h"
#import "LoginRequestModel.h"
#import "RestClient.h"
#import "AppDelegate.h"
#import "SignInDetailHandler.h"
#import "MBProgressHUD.h"
#import "OTPViewController.h"
#import "SocialResponseModel.h"
#import "SocialIntigration.h"

@interface LoginViewController ()<UITextFieldDelegate, GPPSignInDelegate,UIPopoverPresentationControllerDelegate,GooglePlusDelegates>{
    RestClient *restClient;
    GPPSignIn *signIn;
    NSInteger logInType;
    NSString *accessToken;
    NSString *appID;
   // NSString *_gender;
    NSString *_email;
    SocialIntigration *socialIntigration;
    NSInteger signUptype;
  
}

@property (nonatomic, weak) IBOutlet UITextField *phoneTF;
@property (nonatomic, weak) IBOutlet UITextField *passwordTF;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isPasswordShow;
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, weak) IBOutlet UIView *layerView;
@property (nonatomic, strong) UIView *layerView1;

@property (nonatomic, weak) IBOutlet UIView *popUpView;
@property (nonatomic, weak) IBOutlet UITextField *forgotPasswordTF;


@end

@implementation LoginViewController
@synthesize signInButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    socialIntigration=[[SocialIntigration alloc]init];
    socialIntigration.delegates=self;
     restClient=[[RestClient alloc]init];
    signIn.delegate=socialIntigration;
    logInType=1;
    self.appDelegate = [UIApplication sharedApplication].delegate;
    
    self.layerView1 = [[ UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.layerView1.backgroundColor = [UIColor grayColor];
    self.layerView1.alpha = 0.6;
    [self.appDelegate.window addSubview:self.layerView1];
    [self.appDelegate.window addSubview:self.popUpView];
    self.layerView1.hidden = YES;
    self.phoneTF.text = @"9491339763";
    self.passwordTF.text = @"123456";
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBordShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBordHide) name:UIKeyboardDidHideNotification object:nil];
    
    
    
    [signInButton setImage:nil forState:UIControlStateNormal];
    
    //self.reqModel.signupType = Login;
    //self.reqModel.genderType = Male;
    self.appDelegate = [UIApplication sharedApplication].delegate;
   
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)callLoginRequestwithSocialModel:(SocialResponseModel*)socialModel {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview.superview animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    LoginRequestModel *requestModel = [[LoginRequestModel alloc]init];
//    requestModel.signupType = Login;
     requestModel.channelId=@"";
    
    
    requestModel.email=_email;
    
//    if ([_gender isEqual:@"male"]) {
//        requestModel.gender = [NSNumber numberWithInt:0];
//        
//    }else{
//        requestModel.gender = [NSNumber numberWithInt:1];
//    }
//
    if (socialModel) {
        
        requestModel.gender=socialModel.gender;
        requestModel.signupType=[socialModel.signupType integerValue];
        requestModel.phone = @"";
        requestModel.password = @"";
        requestModel.email=socialModel.email;
        requestModel.appId=socialModel.appId;
        requestModel.accessToken=socialModel.loginToken;
        
        
    }else{
        
        requestModel.signupType=Login;
        requestModel.phone = self.phoneTF.text;
        requestModel.password = self.passwordTF.text;
        requestModel.appId=@"";
        requestModel.accessToken=@"";
    }
    
    
   if ([restClient rechabilityCheck]) {
    [restClient login:requestModel callBackHandler:^(LoginResponseModel *response, NSError *error) {
        
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];

                    
                    NSString *errorMsg ;
                    if (!error && response.authToken.length>0) {
                        errorMsg = @"Successfully Login";
                        SignInDetailHandler *handler = [SignInDetailHandler sharedInstance];
                        handler.loginResModel = response;
                        handler.isSignin = YES;
                    }else if (!error && response.authToken.length==0) {
                        
                    }else{
                        NSDictionary *dict = [error userInfo];
                        
                        errorMsg = dict[@"ErrorReason"];
                    }
                    
                    [hud hideAnimated:YES];
    
                    UIAlertController * view=   [UIAlertController
                                                 alertControllerWithTitle:@""
                                                 message:errorMsg
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             
                                             NSInteger errorCode=error.code;
                                             if (errorCode==401) {
                                                 if (requestModel.signupType>1) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToSignUpPage" object:socialModel];
                                                 }
                                                 
                                             }
                                             
                                             
                                             if (!error) {
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"POPTOVIEWCONTROLLER" object:nil];
                                             }
                                         }];
                    [view addAction:ok];
                    [self presentViewController:view animated:YES completion:nil];
                    
                });
    }];
}
}

- (IBAction)clickOnPAsswordShow:(UIButton *)sender {
    
    self.isPasswordShow = !self.isPasswordShow;
    
    if (self.isPasswordShow == YES) {
        [sender setTitle:@"HIDE" forState:UIControlStateNormal];
        self.passwordTF.secureTextEntry = NO;
    }else{
        [sender setTitle:@"SHOW" forState:UIControlStateNormal];
        self.passwordTF.secureTextEntry = YES;
    }
    self.passwordTF.text = self.passwordTF.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.forgotPasswordTF) {
        [self updatePopUpFrame];

//        self.scrollView.contentOffset = CGPointMake(0, 100);
        return;
    }
    
    if (textField == self.phoneTF) {
        textField.returnKeyType = UIReturnKeyNext;
    }else {
        textField.returnKeyType = UIReturnKeyDone;
        self.scrollView.contentOffset = CGPointMake(0, 100);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.forgotPasswordTF) {
        
        [self.forgotPasswordTF resignFirstResponder];
        [self updatePopUpFrame];

        return YES;
    }
    
    if (textField == self.phoneTF) {
        [self.passwordTF becomeFirstResponder];
    }else {
        [self.passwordTF resignFirstResponder];
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self callLoginRequestwithSocialModel:nil];
    }
    return YES;
}

- (IBAction)tapOnGesture:(id)sender {
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [self.scrollView setContentSize:CGSizeMake(320, self.passwordTF.frame.origin.y+self.passwordTF.frame.size.height + 500)];
}

- (IBAction)clickOnForgotPassword:(id)sender {
    [self updatePopUpFrame];

    self.layerView1.hidden = NO;
    self.popUpView.hidden = NO;
//    self.layerView.hidden = NO;
}

- (void)updatePopUpFrame {
    CGRect frm = [UIScreen mainScreen].bounds;
    
    float xAxis = (frm.size.width - self.popUpView.frame.size.width)/2;
    float yAxis = (frm.size.height - self.popUpView.frame.size.height)/2;
    
    self.popUpView.frame = CGRectMake(xAxis, yAxis, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
}

- (void)keyBordShow {
    [self updatePopUpFrame];
}

- (void)keyBordHide {
    [self updatePopUpFrame];
}

- (IBAction)clickOnPasswordSend:(id)sender {
    [self.view endEditing:YES];
    [self.forgotPasswordTF resignFirstResponder];
    self.popUpView.hidden = YES;
    self.layerView1.hidden = YES;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview.superview animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");

    NSString *phNo=[self.forgotPasswordTF.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([restClient rechabilityCheck]) {
    [restClient forgotPassword:phNo callBackHandler:^(NSString *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errorMsg ;
            if (!error) {
                errorMsg = @"Password sent successfully";
            }else{
                NSDictionary *dict = [error userInfo];
                errorMsg = dict[@"ErrorReason"];
            }
            
            [hud hideAnimated:YES];
            
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:errorMsg
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     if (!error) {
//                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"POPTOVIEWCONTROLLER" object:nil];
                                     }
                                 }];
            [view addAction:ok];
            [self presentViewController:view animated:YES completion:nil];
            
        });

    }];
    }
}

#pragma mark FbSignUp

- (IBAction)selectOnFaceBook:(id)sender{
    
    [socialIntigration faceBookLoginWithParent:self.ParentView callBackHandler:^(SocialResponseModel *response, NSError *error) {
        NSLog(@"%@",response);
        [self gettingSocialResponseModel:response];
    }];
}



#pragma mark Google SIgnUp

- (IBAction)gAction:(id)sender {
    static NSString * const kClientId = @"91044725520-eg55bs3iik2s8npf3qia2etgqdvffa6i.apps.googleusercontent.com";
    //  [signIn authenticate];
    [socialIntigration GoogleLogincallBackHandler:^(SocialResponseModel *response, NSError *error) {
        
    }];
    
}


-(void)gettingSocialResponseModel:(SocialResponseModel *)socialResponseModel{
    NSLog(@"%@",socialResponseModel);
    
    if (socialResponseModel) {
        
        appID=socialResponseModel.appId;
        accessToken=socialResponseModel.loginToken;
        signUptype=[socialResponseModel.signupType integerValue];
        [self callLoginRequestwithSocialModel:socialResponseModel];
        
        
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
