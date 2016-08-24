//
//  PaymentView.m
//  StyleMyBody
//
//  Created by K venkateswarlu on 08/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "PaymentView.h"
#import "InternetBankingVC.h"
#import "CreditCardView.h"
#import "DebitCardView.h"
#import "RestClient.h"
#import "AppDelegate.h"


@interface PaymentView ()<UIApplicationDelegate>
{
    NSString *bookingId;
    NSMutableArray *optionsArray;
    RestClient* restClient;
}
@end

@implementation PaymentView

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];
    if ([self.bookingIdDict valueForKey:@"bookingId"]) {
        bookingId=[self.bookingIdDict valueForKey:@"bookingId"];
        amountLbl.text=[NSString stringWithFormat:@"%@",[self.bookingIdDict valueForKey:@"amountPaid"]];
    }
    
    
    optionsArray=[[NSMutableArray alloc]initWithObjects:@"Credit Card",@"Debit Card",@"Internet Banking",@"Mobail Wallets",@"PayTm", nil];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return optionsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PaymentOptionsCell"];
    UILabel *nameLbl = (UILabel *)[cell viewWithTag:1];
    nameLbl.text=[optionsArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<=2) {
       
        NSDictionary *bookingInfoDict=[NSDictionary dictionaryWithObjectsAndKeys:[self.bookingIdDict valueForKey:@"bookingId"],@"bookingId",[NSNumber numberWithInteger:indexPath.row+1],@"transactionType",[NSNumber numberWithInt:1],@"paymentMode", nil];
        
        [restClient getBookingInfo:bookingInfoDict callBackHandler:^(NSDictionary *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                UIApplication *app= [UIApplication sharedApplication];
                AppDelegate *appDelegate=app.delegate;
                appDelegate.bookingInfo=response;
//                appDelegate.signinIdPay=[identifier valueForKey:@""];
//                appDelegate.signUpIdPay=[identifier valueForKey:@""];
//                appDelegate.signinSecretPay=[identifier valueForKey:@""];
//                appDelegate.signUpSecretPay=[identifier valueForKey:@""];
                
                
                if (indexPath.row==0) {
                    
                    CreditCardView *creditCardView=  [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardView"];
                    creditCardView.bookingInfo=response;
                    creditCardView.bookingID=bookingId;
                    [self.navigationController pushViewController:creditCardView animated:YES];
                }else if (indexPath.row==1) {
                    DebitCardView *debitCardView=  [self.storyboard instantiateViewControllerWithIdentifier:@"DebitCardView"];
                    debitCardView.bookingInfo=response;
                    [self.navigationController pushViewController:debitCardView animated:YES];
                    
                }else if (indexPath.row==2) {
                    
                    InternetBankingVC *internetBankingVC=  [self.storyboard instantiateViewControllerWithIdentifier:@"InternetBankingVC"];
                    internetBankingVC.bookingInfo=response;
                    
                    [self.navigationController pushViewController:internetBankingVC animated:YES];
                }

            });
            
           
            
        }];

    }
    else if (indexPath.row==3) {
        
    }else if (indexPath.row==4) {
        
    }


    

}


- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
