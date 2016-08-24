//
//  SocialIntigration.h
//  StyleMyBody
//
//  Created by sipani online on 06/08/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialResponseModel.h"
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>



@class CustomDelegates;

@protocol GooglePlusDelegates <NSObject>
@optional
-(void)gettingSocialResponseModel:(SocialResponseModel *)socialResponseModel;
@end



@interface SocialIntigration : NSObject<GPPSignInDelegate>

{
     GPPSignIn *signIn;
}
@property (nonatomic, weak) id <GooglePlusDelegates> delegates;
- (void)faceBookLoginWithParent:(UIViewController*)ParentView callBackHandler:(void(^)(SocialResponseModel *response, NSError *error))handler;
- (void)GoogleLogincallBackHandler:(void(^)(SocialResponseModel *response, NSError *error))handler;

@end
