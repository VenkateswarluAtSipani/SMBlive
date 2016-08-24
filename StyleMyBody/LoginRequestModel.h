//
//  LoginRequestModel.h
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignUpResModel.h"

typedef enum : NSUInteger {
    Login = 1,
    FBLogin = 2,
    GooglePlusLogin = 3
} SignupType;

@interface LoginRequestModel : NSObject

@property (nonatomic, assign) SignupType signupType;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSString *email;

- (NSData *)getLoginRequest;

@end
