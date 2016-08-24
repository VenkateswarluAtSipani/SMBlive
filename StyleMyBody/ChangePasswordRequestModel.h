//
//  ChangePasswordRequestModel.h
//  StyleMyBody
//
//  Created by sipani online on 07/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangePasswordRequestModel : NSObject

@property (nonatomic, strong) NSString *oldpassword;
@property (nonatomic, strong) NSString *newpassword;

@end
