//
//  SignViewController.m
//  StyleMyBody
//
//  Created by sipani online on 4/19/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "SignViewController.h"
#import "CAPSPageMenu.h"
#import "RestClient.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "OTPViewController.h"


@interface SignViewController ()

@property (nonatomic) CAPSPageMenu *pageMenu;
@property (nonatomic) LoginViewController *signInController;
@property (nonatomic) SignUpViewController *signUpController;
@property (nonatomic) IBOutlet UIView *otpView;
@property (nonatomic, strong) OTPViewController *otpController;
@property (nonatomic, weak) IBOutlet UILabel *headerLbl;


- (IBAction)clickOnDone:(id)sender;
@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerLbl.font = [UIFont fontWithName:@"Pacifico" size:24];

    self.signInController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"loginVC"];
    self.signInController.title = @"LOG IN";
    
    self.signUpController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"signUp"];
    self.signUpController.title = @"JOIN US";
    

    NSArray *controllerArray = @[self.signInController,self.signUpController];
    [self setUpTabMenuWithControllers:controllerArray withIndex:0];
}
-(void)setUpTabMenuWithControllers:(NSArray*)controllerArray withIndex:(NSInteger)index{
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:255.0/255.0 green:105.0/255.0 blue:66.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithRed:232.0/255.0 green:223.0/255.0 blue:23.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:238.0/255.0 green:241.0/255.0 blue:246.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:14.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(self.view.bounds.size.width/2),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [_pageMenu moveToPage:index];
    [self.view addSubview:_pageMenu.view];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOTPView:) name:@"OTPNOTIFICATION" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToBack) name:@"POPTOVIEWCONTROLLER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToSignUpPage:) name:@"goToSignUpPage" object:nil];
    
    
}
-(IBAction)goToSignUpPage:(NSNotification*)sender{
    
    
    self.signUpController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"signUp"];
    self.signUpController.title = @"JOIN US";
    
    SocialResponseModel *social=sender.object;
    self.signUpController.socialResponseModel=social;
    self.signInController =[_pageMenu.controllerArray objectAtIndex:0];
    NSArray *controllerArray = @[self.signInController,self.signUpController];
    
    [self setUpTabMenuWithControllers:controllerArray withIndex:1];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showOTPView:(NSNotification*)sender{
   
    OTPViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"otpVC"];
    controller.signUpModel = sender.object;;
    [self presentViewController:controller animated:YES completion:nil];
   // self.otpView.hidden = NO;
   // self.otpView.backgroundColor = [UIColor redColor];
//    OTPViewController *otpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"otpVC"];
//    otpVC.otpTF.hidden = YES;
//    otpVC.lineView.hidden = YES;
//    
//    [self.view addSubview:otpVC.view];

}

- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickOnDone:(id)sender {
    if (self.pageMenu.currentPageIndex == 0) {
        [self.signInController callLoginRequestwithSocialModel:nil];
    }else{
        [self.signUpController callSignupRequest];
    }
}

- (IBAction)clickOnBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.otpController = segue.destinationViewController;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
