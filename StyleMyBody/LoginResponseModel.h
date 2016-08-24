//
//  LoginResponseModel.h
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginUserResModel.h"

@interface LoginResponseModel : NSObject

@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) LoginUserResModel *userDetails;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSNumber *userType;

@end
