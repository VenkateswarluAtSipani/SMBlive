//
//  SignUpViewController.m
//  StyleMyBody
//
//  Created by sipani online on 4/19/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "SignUpViewController.h"
#import "RestClient.h"
#import "RegisterRequestModel.h"
#import "SignUpResModel.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "GKImagePicker.h"
#import "AppDelegate.h"
#import "NSData+Base64.h"
#import "OTPViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "SocialIntigration.h"


@interface SignUpViewController ()<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,GPPSignInDelegate,UIPopoverPresentationControllerDelegate,GooglePlusDelegates>{
    NSString *appId;
    NSInteger signUptype;
    
    
    
    BOOL isMaleSelected;
    GPPSignIn *signIn;
    NSString *selectedImgBase64Str;
    RestClient *restClient;
    SocialIntigration *socialIntigration;
    MBProgressHUD *hud;
}

@property (nonatomic, assign) BOOL isPasswordShow;
@property (nonatomic, assign) BOOL isConfirmPasswordShow;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIImage *selectedImage;
//@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIImagePickerController *ctr;
@property (nonatomic, strong) RegisterRequestModel *reqModel;


- (IBAction)tapOnGesture:(id)sender;

@end

@implementation SignUpViewController
@synthesize signInButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];
    socialIntigration=[[SocialIntigration alloc]init];
    socialIntigration.delegates=self;
    isMaleSelected=YES;
    maleBtn.selected=YES;
    signUptype=1;
    NSData *htmlData=[self readStringFromFileWIthName:@"termsAndConditions"];
    [signInButton setImage:nil forState:UIControlStateNormal];
    signIn.delegate=socialIntigration;
    NSString *htmlStr= [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    [termsAndConditionsWebView loadHTMLString:htmlStr baseURL:nil];
    [termsAndConditionsWebView setTintColor:[UIColor blackColor]];
    termsAndConditionsWebView.scrollView.scrollEnabled=NO;
    
    self.reqModel = [[RegisterRequestModel alloc]init];
    self.reqModel.signupType = Login;
    self.reqModel.genderType = Male;
    self.appDelegate = [UIApplication sharedApplication].delegate;
   // [self setUpTheGooglePlus];
    
    if (self.socialResponseModel) {
        [self gettingSocialResponseModel:self.socialResponseModel];
        
    }
    
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [self.scrollView setContentSize:CGSizeMake(320, termsAndConditionsWebView.frame.origin.y+termsAndConditionsWebView.frame.size.height + 300)];
}

- (void)callSignupRequest {
    [self.view endEditing:YES];
    
    RegisterRequestModel *requestModel = [[RegisterRequestModel alloc]init];
    requestModel.signupType = signUptype;
    requestModel.firstName  = self.firstNameTF.text;
    requestModel.lastName   = self.lastNameTF.text;
    requestModel.email      = self.emailTF.text;
    requestModel.phone      = self.mobileNumTF.text;
    //requestModel.genderType = self.reqModel.genderType;
    requestModel.photo=selectedImgBase64Str;
    if (isMaleSelected) {
        requestModel.genderType =Male;
    }else{
        requestModel.genderType=Female;
    }
    if (signUptype==1) {
        requestModel.appId      = @""; ///venky self.reqModel.appId
        requestModel.password   = self.passwordTF.text;
    }else {
        requestModel.appId=appId;
        requestModel.password=@"";
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.firstNameTF.text forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSData *imgData = UIImageJPEGRepresentation(self.selectedImage, 1.0);
    
//    [self callRegisterAPI:requestModel];
    
//    requestModel.photo = [imgData base64EncodedString];
    

    hud = [MBProgressHUD showHUDAddedTo:self.view.superview.superview animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    if ([restClient rechabilityCheck]) {
    [restClient registerUser:requestModel callBackHandler:^(SignUpResModel *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];

            NSString *errorMsg ;
            if (!error) {
                errorMsg = @"Successfully Signup";
                
                self.appDelegate.isSignIn = YES;
            }else{
                NSDictionary *dict = [error userInfo];
                errorMsg = dict[@"ErrorReason"];
            }
        
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
                    
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"OTPNOTIFICATION" object:response];
                                     }
                                 }];
            [view addAction:ok];
            [self presentViewController:view animated:YES completion:nil];
        });
    }];
    }
}
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==_mobileNumTF) {
        
        
        NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        
        if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound)
        {
            return NO;
        }
        
        
        NSInteger length = [textField.text length];
        if (length>9 && ![string isEqualToString:@""]) {
            return NO;
        }
        // This code will provide protection if user copy and paste more then 10 digit text
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([textField.text length]>10) {
                textField.text = [textField.text substringToIndex:10];
                
            }
        });

    }
    return YES;
}

- (IBAction)clickOnPAsswordShow:(UIButton *)sender {
    
    if (sender.tag == 1) {
        self.isPasswordShow = !self.isPasswordShow;
        
        if (self.isPasswordShow == YES) {
            [sender setTitle:@"HIDE" forState:UIControlStateNormal];
            self.passwordTF.secureTextEntry = NO;
        }else{
            [sender setTitle:@"SHOW" forState:UIControlStateNormal];
            self.passwordTF.secureTextEntry = YES;
        }
        self.passwordTF.text = self.passwordTF.text;
    }else{
        self.isPasswordShow = !self.isPasswordShow;
        if (self.isPasswordShow == YES) {
            [sender setTitle:@"HIDE" forState:UIControlStateNormal];
            self.confirmPasswordTF.secureTextEntry = NO;
        }else{
            [sender setTitle:@"SHOW" forState:UIControlStateNormal];
            self.confirmPasswordTF.secureTextEntry = YES;
        }
        self.confirmPasswordTF.text = self.confirmPasswordTF.text;
    }
}

- (IBAction)selectOnUploadImg:(id)sender;
{
    
//    self.imagePicker = [[GKImagePicker alloc] init];
//    self.imagePicker.cropSize = self.view.bounds.size;
//    self.imagePicker.delegate = self;
//    self.imagePicker.resizeableCropArea = YES;

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"Select" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *galary = [UIAlertAction actionWithTitle:@"Galary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [appDelegate.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }];
    
    UIAlertAction *cemera = [UIAlertAction actionWithTitle:@"Cemara" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [appDelegate.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [alertControl addAction:galary];
    [alertControl addAction:cemera];
    [alertControl addAction:cancel];

    
    [self presentViewController:alertControl animated:YES completion:nil];

}
- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController{
    
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

//- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
//    [self hideImagePicker];
//}
//
//- (void)hideImagePicker{
//    [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    selectedImgBase64Str = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    [self.uploadBtn setBackgroundImage:chosenImage forState:UIControlStateNormal];
    self.selectedImage = chosenImage;

    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.firstNameTF) {
        textField.returnKeyType = UIReturnKeyNext;
    }else   if (textField == self.lastNameTF) {
        textField.returnKeyType = UIReturnKeyNext;
        self.scrollView.contentOffset = CGPointMake(0, 100);
    }else if ( textField == self.emailTF) {
        textField.returnKeyType = UIReturnKeyNext;
       self.scrollView.contentOffset = CGPointMake(0, 200);
    } else if (textField == self.mobileNumTF) {
        textField.returnKeyType = UIReturnKeyNext;
         self.scrollView.contentOffset = CGPointMake(0, 150);
    }else if (textField == self.passwordTF ) {
        textField.returnKeyType = UIReturnKeyNext;
        self.scrollView.contentOffset = CGPointMake(0, 300);
    }else if (textField == self.confirmPasswordTF) {
        self.scrollView.contentOffset = CGPointMake(0, 320);
        textField.returnKeyType = UIReturnKeyDone;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.firstNameTF) {
        [self.lastNameTF becomeFirstResponder];
    }else   if (textField == self.lastNameTF) {
        [self.mobileNumTF becomeFirstResponder];
    }else if ( textField == self.emailTF) {
        if (_isPasswordShow==NO) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
            [self callSignupRequest];
        }
         [self.mobileNumTF becomeFirstResponder];
    } else if (textField == self.mobileNumTF) {
         [self.passwordTF becomeFirstResponder];
    }else if (textField == self.passwordTF ) {
         [self.confirmPasswordTF becomeFirstResponder];
    }else if (textField == self.confirmPasswordTF) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self callSignupRequest];
    }
    return YES;
}


- (IBAction)tapOnGesture:(id)sender {
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.view endEditing:YES];
}





- (void)callRegisterAPI:(RegisterRequestModel *)model {
    hud = [MBProgressHUD showHUDAddedTo:self.view.superview.superview animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    if ([restClient rechabilityCheck]) {
    [restClient registerUser:model callBackHandler:^(SignUpResModel *response, NSError *error) {
        NSString *errorMsg ;
        if (!error) {
            errorMsg = @"Successfully Signup";
            self.appDelegate.isSignIn = YES;
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
                                     OTPViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"otpVC"];
                                     controller.signUpModel = response;
                                     [self presentViewController:controller animated:YES completion:nil];
                                     //                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"POPTOVIEWCONTROLLER" object:nil];
                                 }
                             }];
        [view addAction:ok];
        [self presentViewController:view animated:YES completion:nil];
    }];
    }
}
- (NSData*)readStringFromFileWIthName:(NSString*)filename {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"Txt"];
    // The main act...
    return [NSData dataWithContentsOfFile:path];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sexBtnAction:(id)sender {
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==1) {
        if (!isMaleSelected) {
            isMaleSelected=YES;
            maleBtn.selected=YES;
            femaleBtn.selected=NO;
        }
    }else if (btn.tag==2){
        if (isMaleSelected) {
            isMaleSelected=NO;
            maleBtn.selected=NO;
            femaleBtn.selected=YES;
        }
    }
}


#pragma mark FbSignUp

- (IBAction)selectOnFaceBook:(id)sender{
    
    passwordsView.hidden=YES;
    passwordsViewHeight.constant=0;
    _passwordTF.text=@"";
    _confirmPasswordTF.text=@"";
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view.superview.superview animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    [socialIntigration faceBookLoginWithParent:self.ParentView callBackHandler:^(SocialResponseModel *response, NSError *error) {
        [hud hideAnimated:YES];
        [self gettingSocialResponseModel:response];
    }];

}

#pragma mark Google SIgnUp

- (IBAction)gAction:(id)sender {
    passwordsView.hidden=YES;
    passwordsViewHeight.constant=0;
    _passwordTF.text=@"";
    _confirmPasswordTF.text=@"";
    
    static NSString * const kClientId = @"91044725520-eg55bs3iik2s8npf3qia2etgqdvffa6i.apps.googleusercontent.com";
    hud = [MBProgressHUD showHUDAddedTo:self.view.superview.superview animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    [socialIntigration GoogleLogincallBackHandler:^(SocialResponseModel *response, NSError *error) {
        
    }];
    
}

-(void)gettingSocialResponseModel:(SocialResponseModel *)socialResponseModel{
    NSLog(@"%@",socialResponseModel);
    
    if (socialResponseModel) {
    
        passwordsView.hidden=YES;
        passwordsViewHeight.constant=0;
        _passwordTF.text=@"";
        _confirmPasswordTF.text=@"";
        
        
        
        //////---------to load images of fb and g+ ----------////
        
        if ([socialResponseModel.signupType integerValue]==2) {
            
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:[NSString stringWithFormat:@"me/picture?type=large&redirect=false"]parameters:nil HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result,NSError *error) {
                if (!error){
                    
                    NSString *imgUrlStr=[[result  valueForKey:@"data"]valueForKey:@"url"];
                    NSURL *imgUrl=[NSURL URLWithString:imgUrlStr];
                    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:imgUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        if (data) {
                            UIImage *image = [UIImage imageWithData:data];
                            selectedImgBase64Str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                            if (image) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.uploadBtn setBackgroundImage:image forState:UIControlStateNormal];
                                });
                            }
                        }
                    }] ;
                    [task resume];
                }
                
            }];
            
        }else if ([socialResponseModel.signupType integerValue]==3){
            [hud hideAnimated:YES];
            if (socialResponseModel.picUrl.length>0) {
                
                NSRange range = NSMakeRange(socialResponseModel.picUrl.length-2,2);
                NSString *newText = [socialResponseModel.picUrl stringByReplacingCharactersInRange:range withString:@"100"];
                
                
                NSURL *imgUrl=[NSURL URLWithString:newText];
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:imgUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data) {
                        UIImage *image = [UIImage imageWithData:data];
                        if (image) {
                            selectedImgBase64Str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.uploadBtn setBackgroundImage:image forState:UIControlStateNormal];
                            });
                        }
                    }
                }] ;
                [task resume];
            }
         }
        
        //////---------to load images of fb and g+ ----------////
        
        if ([socialResponseModel.gender integerValue]==0) {
            maleBtn.selected=YES;
            femaleBtn.selected=NO;
        }else{
            maleBtn.selected=NO;
            femaleBtn.selected=YES;
        }
        appId=socialResponseModel.appId;
        signUptype=[socialResponseModel.signupType integerValue];
        _firstNameTF.text=socialResponseModel.firstName;
        _lastNameTF.text=socialResponseModel.lastName;
        _emailTF.text=socialResponseModel.email;
        _firstNameTF.userInteractionEnabled=NO;
        _lastNameTF.userInteractionEnabled=NO;
        _emailTF.userInteractionEnabled=NO;
        
        
    }
   
}
@end
