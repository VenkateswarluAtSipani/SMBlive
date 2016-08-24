//
//  CreditCardView.m
//  StyleMyBody
//
//  Created by K venkateswarlu on 08/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "CreditCardView.h"
#import "RestClient.h"
#import "MBProgressHUD.h"
#import <CitrusPay/CitrusPay.h>
#import "CitrusPaymentHandler.h"


@interface CreditCardView ()<UITextFieldDelegate>
{
    RestClient *restClient;
    CitrusPaymentHandler *citrusPaymentHandler;
}
@end

@implementation CreditCardView

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];
    [self getBookingInfo];
  
   // [citrusPaymentHandler requestLoadMoneyPgSettings];
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
    
    if (self.bookingInfo) {
        citrusPaymentHandler=[[CitrusPaymentHandler alloc]init];
        UISegmentedControl *segControl=[[UISegmentedControl alloc]init];
        segControl.selectedSegmentIndex=2;
        citrusPaymentHandler.bookingID=self.bookingID;
        citrusPaymentHandler.controller=self;
        citrusPaymentHandler.landingScreen=1;
        citrusPaymentHandler.bookingInfo=_bookingInfo;
        citrusPaymentHandler.segControl=segControl;
        citrusPaymentHandler.loadButton=self.payNowBtn;
        citrusPaymentHandler.cvvTextField=_cvvTextField;
        citrusPaymentHandler.expiryDateTextField=_expiryDateTextField;
        citrusPaymentHandler.ownerNameTextField=_ownerNameTextField;
        citrusPaymentHandler.cardNumberTextField=_cardNumTextFiewld;
        citrusPaymentHandler.amount=[self.bookingInfo valueForKey:@"amount"];
        [citrusPaymentHandler setUpCitrusPay];

    }
        
    
        

}

#pragma mark - TextView Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    if (textField.tag == 2000) {
        __block NSString *text = [textField text];
        if ([textField.text isEqualToString:@""] || ( [string isEqualToString:@""] && textField.text.length==1)) {
           // self.schemeTypeImageView.image = [CTSUtility getSchmeTypeImage:string];
        }
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (text.length>1) {
            self.schemeTypeImageView.image = [CTSUtility getSchmeTypeImage:text];
        }
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        if (newString.length>1) {
            NSString* scheme = [CTSUtility fetchCardSchemeForCardNumber:[newString stringByReplacingOccurrencesOfString:@" " withString:@""]];
            if ([scheme isEqualToString:@"MTRO"]) {
                if (newString.length >= 24) {
                    return NO;
                }
            }
            else{
                if (newString.length >= 20) {
                    return NO;
                }
            }
        }
        
        [textField setText:newString];
        return NO;
        
    }
    else if (textField==self.cvvTextField) {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        int length = (int)[currentString length];
        if (length > 4) {
            return NO;
        }
    }
    else if (textField==self.expiryDateTextField) {
        __block NSString *text = [textField text];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789/"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        NSArray* subStrings = [text componentsSeparatedByString:@"/"];
        int month = [[subStrings objectAtIndex:0] intValue];
        if(month > 12){
            NSString *string=@"";
            string = [string stringByAppendingFormat:@"0%@",text];
            text = string;
        }
        text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if ([string isEqualToString:@""]) {
            return YES;
        }
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 2)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 2 && ![newString containsString:@"/"]) {
                newString = [newString stringByAppendingString:@"/"];
            }
            text = [text substringFromIndex:MIN(text.length, 2)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if (newString.length >=6) {
            return NO;
        }
        
        [textField setText:newString];
        
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        else{
            return NO;
        }
    }
    
    return YES;
    
}

//-(void)requestLoadMoneyPgSettings {
//    
//    [paymentLayer requestLoadMoneyPgSettingsCompletionHandler:^(CTSPgSettings *pgSettings, NSError *error){
//        if(error){
//            //handle error
//            LogTrace(@"[error localizedDescription] %@ ", [error localizedDescription]);
//        }
//        else {
//            debitArray = [CTSUtility fetchMappedCardSchemeForSaveCards:[[NSSet setWithArray:pgSettings.debitCard] allObjects] ];
//            creditArray = [CTSUtility fetchMappedCardSchemeForSaveCards:[[NSSet setWithArray:pgSettings.creditCard] allObjects] ];
//            
//            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
//            
//            
//            LogTrace(@" pgSettings %@ ", pgSettings);
//            for (NSString* val in creditArray) {
//                LogTrace(@"CC %@ ", val);
//            }
//            
//            for (NSString* val in debitArray) {
//                LogTrace(@"DC %@ ", val);
//            }
//            
//            _banksArray = pgSettings.netBanking;
//            
//            for (NSDictionary* arr in pgSettings.netBanking) {
//                //setting the object for Issuer bank code in Dictionary
//                [tempDict setObject:[arr valueForKey:@"issuerCode"] forKey:[arr valueForKey:@"bankName"]];
//                
//                LogTrace(@"bankName %@ ", [arr valueForKey:@"bankName"]);
//                LogTrace(@"issuerCode %@ ", [arr valueForKey:@"issuerCode"]);
//                
//            }
//            netBankingDict = tempDict;
//        }
//        
//    }];
//    
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
