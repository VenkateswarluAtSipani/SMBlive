//
//  ChangePasswordViewController.m
//  StyleMyBody
//
//  Created by sipani online on 01/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ChangePasswordRequestModel.h"
#import "RestClient.h"

@interface ChangePasswordViewController ()
{
    RestClient*restClient;
}
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc ]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveBTN:(UIButton *)sender {
    ChangePasswordRequestModel*model=[[ChangePasswordRequestModel alloc]init];
    
    model.oldpassword=self.oldpasswordTF.text;
    model.newpassword=self.newpasswordTF.text;
    
    if ([restClient rechabilityCheck]) {
    [restClient changePassword:model callBackHandler:^(NSString* response, NSError* error) {
        
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
