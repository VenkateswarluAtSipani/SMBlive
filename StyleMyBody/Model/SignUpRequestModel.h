//
//  SignUpRequestModel.h
//  StyleMyBody
//
//  Created by sipani online on 4/20/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpRequestModel : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSData *photo;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) int signupType;
@property (nonatomic, strong) NSString *appId;

- (NSData *)getSignupRequest;

@end
