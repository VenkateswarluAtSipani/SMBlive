//
//  CreditCardView.h
//  StyleMyBody
//
//  Created by K venkateswarlu on 08/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface CreditCardView : BaseViewController{
    NSArray *debitArray;
    NSArray *creditArray;
    NSMutableArray *_banksArray;
    NSDictionary *netBankingDict;
}

@property (nonatomic,strong)NSDictionary *bookingInfo;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextFiewld;
@property (weak, nonatomic) IBOutlet UIImageView *schemeTypeImageView;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;
@property (weak, nonatomic) IBOutlet UITextField *ownerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *expiryDateTextField;
@property (weak, nonatomic) IBOutlet UIButton *payNowBtn;
@property (nonatomic , strong) NSString  *bookingID;
@end
