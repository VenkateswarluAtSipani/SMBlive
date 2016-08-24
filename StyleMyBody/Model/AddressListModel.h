//
//  AddressListModel.h
//  StyleMyBody
//
//  Created by apple on 25/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressListModel : NSObject

@property (nonatomic,strong)NSMutableArray *addressListArray;

@property(nonatomic,strong)NSNumber *addressId;
@property(nonatomic,strong)NSString *tagName;
@property(nonatomic,strong)NSString *addressOne;
@property(nonatomic,strong)NSString *addressTwo;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *pincode;
@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *longitude;

@end
