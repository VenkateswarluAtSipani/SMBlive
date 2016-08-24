//
//  StylistServiceResModel.h
//  StyleMyBody
//
//  Created by sipani online on 5/7/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StylistServiceResModel : NSObject

@property (nonatomic, strong) NSNumber *serviceId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *isHomeService;
@property (nonatomic, strong) NSNumber *isPackage;
@property (nonatomic,strong) NSNumber *isOffers;

@end
