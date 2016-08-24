//
//  CitrusPaymentHandler.h
//  StyleMyBody
//
//  Created by apple on 10/08/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CitrusPay/CitrusPay.h>
#import "CreditCardView.h"
#import "DebitCardView.h"
#import "InternetBankingVC.h"
#import "BaseViewController.h"


@interface CitrusPaymentHandler :BaseViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (assign) int landingScreen;


@property (nonatomic , strong) UIImageView *schemeTypeImageView;

@property (nonatomic , weak) IBOutlet UITableView *saveCardsTableView;


@property (nonatomic , strong) UIPickerView *aPickerView;
@property (nonatomic , weak) IBOutlet UITableView *ccddtableView;


@property (nonatomic , weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic , strong) CTSRuleInfo *ruleInfo;

@property (assign) BOOL isDirectPaymentEnable;


@property (nonatomic,strong)UIViewController *controller;
@property (nonatomic, strong)UISegmentedControl *segControl;
@property (nonatomic , weak) UIButton *loadButton;
@property (nonatomic , strong) NSString *amount;
@property (nonatomic , strong) NSDictionary *bookingInfo;
@property (nonatomic , strong) NSString  *bookingID;

@property (nonatomic , strong) UITextField *cardNumberTextField;
@property (nonatomic , strong) UITextField *ownerNameTextField;
@property (nonatomic , strong)  UITextField *expiryDateTextField;
@property (nonatomic , strong)  UITextField *cvvTextField;
@property (nonatomic , weak) IBOutlet UITextField *netBankCodeTextField;



-(void)setUpCitrusPay;
- (void)requestPaymentModes;
-(void)requestLoadMoneyPgSettings ;

@end
