//
//  RegisterRequestModel.h
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRequestModel.h"

typedef enum : NSUInteger {
    Female,
    Male
} GenderType;

@interface RegisterRequestModel : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) GenderType genderType;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) SignupType signupType;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *accessToken;


- (NSData *)getRegisterRequest;

@end
