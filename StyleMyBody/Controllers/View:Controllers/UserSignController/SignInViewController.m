//
//  SignInViewController.m
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "SignInViewController.h"
#import "LoginViewController.h"
#import "LoginResponseModel.h"
#import "LoginRequestModel.h"
#import "RestClient.h"
#import "OTPViewController.h"



@interface SignInViewController ()<UIScrollViewDelegate>{
    RestClient *restClient;
}

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *loginView;

@property (nonatomic, weak) IBOutlet UITextField *phoneTF;
@property (nonatomic, weak) IBOutlet UITextField *passwordTF;
@property (nonatomic, assign) BOOL isPasswordShow;

- (IBAction)clickOnBack:(id)sender;
- (IBAction)clickOnDone:(id)sender;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];
    self.scrollView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoveToOTPview:) name:@"MoveToOTPview" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:@"keypadHide" object:nil];

}
-(IBAction)MoveToOTPview:(id)sender{
//    OTPViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"otpVC"];
//    controller.signUpModel = sender;
//    [self presentViewController:controller animated:YES completion:nil];
}
- (void)viewDidLayoutSubviews
{
    [self.scrollView setContentSize:CGSizeMake(1024, 0)];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    _xCoord = scrollView.contentOffset.x;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if (_xCoord > scrollView.contentOffset.x) {
//        //right
//    } else if (_xCoord < scrollView.contentOffset.x) {
//        //LEFT
//        
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)keyboardShow:(NSNotification *)sender {
//    [self.scrollView setContentOffset:CGPointMake(0, 100)];
//}
//
//- (void)keyboardHide:(NSNotification *)sender {
//    [self.scrollView setContentOffset:CGPointMake(0, 0)];
//}

- (IBAction)clickOnBack:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickOnDone:(id)sender {
    [self callLoginRequest];
}

- (void)callLoginRequest{
    LoginRequestModel *requestModel = [[LoginRequestModel alloc]init];
    requestModel.signupType = Login;
    requestModel.phone = self.phoneTF.text;
    requestModel.password = self.passwordTF.text;
    if ([restClient rechabilityCheck]) {
    [restClient login:requestModel callBackHandler:^(LoginResponseModel *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errorMsg ;
            if (!error) {
                errorMsg = @"Successfully Login";
            }else{
                NSDictionary *dict = [error userInfo];
                errorMsg = dict[@"Error reason"];
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
                                         [self.navigationController popViewControllerAnimated:YES];
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
    if (textField == self.phoneTF) {
        textField.returnKeyType = UIReturnKeyNext;
        [self.scrollView setContentOffset:CGPointMake(0, 100)];
    }else {
        textField.returnKeyType = UIReturnKeyDone;
        [self.scrollView setContentOffset:CGPointMake(0, 100)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.phoneTF) {
        [self.passwordTF becomeFirstResponder];
    }else {
        [self.passwordTF resignFirstResponder];
        [self.scrollView setContentOffset:CGPointMake(0, 0)];

//        [[NSNotificationCenter defaultCenter] postNotificationName:@"keypadHide" object:nil];
        [self callLoginRequest];
    }
    
    return YES;
}


//- (void)didLogin:(LoginResponseModel *)resModel error:(NSError *)error
//{
//    NSString *errorMsg ;
//    if (!error) {
//        errorMsg = @"Successfully Login";
//    }else{
//        NSDictionary *dict = [error userInfo];
//        errorMsg = dict[@"Error reason"];
//    }
//    
//    UIAlertController * view=   [UIAlertController
//                                 alertControllerWithTitle:@""
//                                 message:errorMsg
//                                 preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction
//                         actionWithTitle:@"OK"
//                         style:UIAlertActionStyleDefault
//                         handler:^(UIAlertAction * action)
//                         {
//                             if (!error) {
//                                 [self.navigationController popViewControllerAnimated:YES];
//                             }
//                         }];
//    [view addAction:ok];
//    [self presentViewController:view animated:YES completion:nil];
//}

//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"loginVC"]) {
//        LoginViewController *controller = segue.destinationViewController;
//        controller.delegate = self;
//    }
//}


@end
