//
//  LoginRequestModel.m
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "LoginRequestModel.h"

@implementation LoginRequestModel

- (NSData *)getLoginRequest {
    NSError *error;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.signupType],@"signupType",self.phone,@"phone",self.password,@"password",self.appId,@"appId",self.accessToken,@"accessToken", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    return data;
}

@end
