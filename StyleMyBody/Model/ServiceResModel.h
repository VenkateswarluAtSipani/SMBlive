//
//  ServiceResModel.h
//  StyleMyBody
//
//  Created by sipani online on 4/16/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceResModel : NSObject

@property (nonatomic, strong) NSNumber *folderId;
@property (nonatomic, strong) NSNumber *serviceId;
@property (nonatomic, strong) NSNumber *isOffer;
@property (nonatomic, strong) NSNumber *isPackage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *serDescription;
@property (nonatomic, strong) NSString *daysOfOp;
@property (nonatomic,strong )  NSNumber *isNotMappedServices;
@property (nonatomic, strong) NSNumber *isHomeService;



@end
