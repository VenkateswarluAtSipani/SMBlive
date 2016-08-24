//
//  RegisterRequestModel.m
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "RegisterRequestModel.h"

@implementation RegisterRequestModel

- (NSData *)getRegisterRequest {
    NSError *error;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.signupType],@"signupType",self.phone,@"phone",self.password,@"password",self.appId,@"appId",self.firstName,@"firstName",self.lastName,@"lastName",self.email,@"email", [NSNumber numberWithInt:self.genderType],@"gender",self.photo,@"photo", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"signup Request = %@",dict);
    
    return data;
}

@end
