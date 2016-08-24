//
//  MyProfileViewController.m
//  StyleMyBody
//
//  Created by sipani online on 01/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "MyProfileViewController.h"
#import "RestClient.h"
#import "ResponseParser.h"
#import "UserProfileModel.h"

@interface MyProfileViewController ()
{
    UserProfileModel*model;
    RestClient *restClient;
    
}
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];

    if ([restClient rechabilityCheck]) {
    [restClient getProfileDetails:^(UserProfileModel *userProfileList, NSError *error) {
        model=userProfileList;
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           [self showUserDetails];
        });
       
    }];
    }
    
}
-(void)showUserDetails{
    self.firstNameTF.text=model.firstName;
    self.lastNameTF.text=model.lastName;
    self.mobileTF.text=model.phone;
    self.emaiTF.text=model.email;
    [RestClient loadImageinImgView:_photo withUrlString:model.photo];

}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveBTNaction:(UIButton *)sender {
    ProfileUpdateReuestModel*profileModel=[[ProfileUpdateReuestModel alloc]init];
    
    profileModel.firstName=self.firstNameTF.text;
    profileModel.lastName=self.lastNameTF.text;
    profileModel.phone=self.mobileTF.text;
    profileModel.email=self.emaiTF.text;
    profileModel.signupType=model.signupType;
    profileModel.gender=model.gender;
    profileModel.isNotification=model.isNotification;
    profileModel.customerRegId=model.customerRegId;
    if ([restClient rechabilityCheck]) {
    [restClient ProfileDetailsUpdate:profileModel callBackHandler:^(NSString* response, NSError *error){
        
    }];
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
