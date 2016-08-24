//
//  SignUpDetailsResModel.h
//  StyleMyBody
//
//  Created by sipani online on 4/29/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpDetailsResModel : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) NSString *gender;
@property (nonatomic, strong) NSString *photo;

@end
