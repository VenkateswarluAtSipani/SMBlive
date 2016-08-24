//
//  OTPViewController.m
//  StyleMyBody
//
//  Created by sipani online on 4/21/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "OTPViewController.h"
#import "RestClient.h"
#import "MBProgressHUD.h"
#import "SignInDetailHandler.h"

@interface OTPViewController (){
    RestClient *restClient;
}

@end

@implementation OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];

    self.phoneNumberLbl.text = self.signUpModel.phone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickOnModify:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickOnResend:(id)sender
{

    self.signUpModel.otp = self.otpTF.text;
    if ([restClient rechabilityCheck]) {
    [restClient sendOTP:self.signUpModel callBackHandler:^(SignUpDetailsResModel *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errorMsg ;
            if (!error) {
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
                                         [self dismissViewControllerAnimated:NO completion:nil];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"POPTOVIEWCONTROLLER" object:nil];
                                     }
                                 }];
            [view addAction:ok];
            [self presentViewController:view animated:YES completion:nil];
        });
    }];
    }
}

- (void)sendOtpRequest {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
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
