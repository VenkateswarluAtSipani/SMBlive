//
//  DebitCardView.m
//  StyleMyBody
//
//  Created by K venkateswarlu on 08/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "DebitCardView.h"
#import "RestClient.h"
#import "MBProgressHUD.h"


@interface DebitCardView ()
{
    RestClient *restClient;
   }
@end

@implementation DebitCardView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBookingInfo];
    restClient=[[RestClient alloc]init];

    // Do any additional setup after loading the view.
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getBookingInfo{
    
//    NSDictionary *bookingInfoDict=[NSDictionary dictionaryWithObjectsAndKeys:[self.bookingIdDict valueForKey:@"bookingId"],@"bookingId",[NSNumber numberWithInt:1],@"transactionType",[NSNumber numberWithInt:2],@"paymentMode", nil];
//    
//    [restClient getBookingInfo:bookingInfoDict callBackHandler:^(NSDictionary *response, NSError *error) {
//        
//    }];
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
