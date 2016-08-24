//
//  LoginViewController.h
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginResponseModel.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "SocialResponseModel.h"

@protocol LoginDelegate <NSObject>

- (void)didLogin:(LoginResponseModel *)resModel error:(NSError *)error;

@end

@interface LoginViewController : UIViewController

@property (nonatomic, weak) id<LoginDelegate> delegate;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property (retain, nonatomic) IBOutlet UIViewController *ParentView;
- (void)callLoginRequestwithSocialModel:(SocialResponseModel*)socialModel ;

@end
