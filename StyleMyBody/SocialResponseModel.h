//
//  SocialResponseModel.h
//  StyleMyBody
//
//  Created by sipani online on 06/08/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SocialResponseModel : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, assign) NSNumber *signupType;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *loginToken;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) UIImage *picImg;
@end
