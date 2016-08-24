//
//  SignInDetailHandler.h
//  StyleMyBody
//
//  Created by sipani online on 4/25/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginResponseModel.h"

@interface SignInDetailHandler : NSObject


@property (nonatomic, strong) LoginResponseModel *loginResModel;

@property (nonatomic, assign) BOOL isSignin;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *userType;
@property (nonatomic, strong) NSString *accessToken;


+ (id)sharedInstance;

@end
