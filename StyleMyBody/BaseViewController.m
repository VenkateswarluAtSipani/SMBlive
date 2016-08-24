//
//  BaseViewController.m
//  CubeDemo
//
//  Created by Vikas Singh on 8/25/15.
//  Copyright (c) 2015 Vikas Singh. All rights reserved.
//

#import "BaseViewController.h"
#import "TestParams.h"
#import "MerchantConstants.h"
#import "AppDelegate.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initializeLayers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initializers

// Initialize the SDK layer viz CTSAuthLayer/CTSProfileLayer/CTSPaymentLayer
-(void)initializeLayers{
    
    
     AppDelegate *appDel=[UIApplication sharedApplication].delegate;
    NSDictionary *bookingInfo=  appDel.bookingInfo;
    NSDictionary *bookconfig=[bookingInfo valueForKey:@"bookconfig"];
    NSDictionary *identifier=[bookconfig valueForKey:@"identifier"];

    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    CTSKeyStore *keyStore = [[CTSKeyStore alloc] init];
    keyStore.signinId = [identifier valueForKey:@"signInKey"];
    keyStore.signinSecret = [identifier valueForKey:@"signInSecret"];
    keyStore.signUpId = [identifier valueForKey:@"signUpKey"];
    keyStore.signUpSecret = [identifier valueForKey:@"signUpSecret"];
    keyStore.vanity = [identifier valueForKey:@"vanity"];
    
#warning "set your required environment to see testing results"
#ifdef PRODUCTION_MODE
    [CitrusPaymentSDK initializeWithKeyStore:keyStore environment:CTSEnvProduction];
#else
    [CitrusPaymentSDK initializeWithKeyStore:keyStore environment:CTSEnvSandbox];
#endif

    [CitrusPaymentSDK enableDEBUGLogs];
    
    authLayer = [CTSAuthLayer fetchSharedAuthLayer];
    proifleLayer = [CTSProfileLayer fetchSharedProfileLayer];
    paymentLayer = [CTSPaymentLayer fetchSharedPaymentLayer];

    contactInfo = [[CTSContactUpdate alloc] init];
    
//    email = "harish.mullaputisoft@gmail.com";
//    firstname = @"";
//    phone = 9491339763;
//    txnId = 1663d2896dcd1d7;
    
    contactInfo.firstName = [bookingInfo valueForKey:@"firstname"];
    contactInfo.lastName = @"";
    contactInfo.email = [bookingInfo valueForKey:@"email"];
    contactInfo.mobile = [bookingInfo valueForKey:@"phone"];
    
    addressInfo = [[CTSUserAddress alloc] init];
//    addressInfo.city = TEST_CITY;
//    addressInfo.country = TEST_COUNTRY;
//    addressInfo.state = TEST_STATE;
//    addressInfo.street1 = TEST_STREET1;
//    addressInfo.street2 = TEST_STREET2;
//    addressInfo.zip = TEST_ZIP;
    
//    customParams = @{
//                     @"USERDATA2":@"MOB_RC|9988776655",
//                     @"USERDATA10":@"test",
//                     @"USERDATA4":@"MOB_RC|test@gmail.com",
//                     @"USERDATA3":@"MOB_RC|4111XXXXXXXX1111",
//                     };

    customParams=nil;

}

@end
