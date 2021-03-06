//
//  UserProfileModel.h
//  StyleMyBody
//
//  Created by sipani online on 05/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfileModel : NSObject


@property (nonatomic, strong) NSNumber *customerRegId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *isNotification;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *signupType;




@end
