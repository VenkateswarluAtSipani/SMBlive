//
//  SignInDetailHandler.m
//  StyleMyBody
//
//  Created by sipani online on 4/25/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "SignInDetailHandler.h"

static SignInDetailHandler *handler = nil;

@implementation SignInDetailHandler


+ (id)sharedInstance {
    
    static dispatch_once_t onceToken;
    
        dispatch_once(&onceToken, ^{
            handler = [[SignInDetailHandler alloc]init];
        });
    
    return handler;
}

@end
