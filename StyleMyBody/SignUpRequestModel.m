//
//  SignUpRequestModel.m
//  StyleMyBody
//
//  Created by sipani online on 4/20/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "SignUpRequestModel.h"

@implementation SignUpRequestModel

- (NSData *)getLoginRequest {
    NSError *error;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.signupType],@"signupType",self.firstName,@"firstName",self.lastName,@"lastName",self.appId,@"appId",self.email,@"email",self.phone,@"phone",self.gender,@"gender",self.photo,@"photo",self.password,@"password", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    return data;
}

@end
