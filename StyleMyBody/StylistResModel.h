//
//  StylistResModel.h
//  StyleMyBody
//
//  Created by sipani online on 5/7/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StylistResModel : NSObject

@property (nonatomic, strong) NSNumber *stylistId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSNumber *centerStylistId;
@property (nonatomic, strong) NSNumber *isFavorite;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *designation;
@property (nonatomic, strong) NSString *workFrom;
@property (nonatomic, strong) NSString *empCode;
@property (nonatomic, strong) NSNumber *walkIn;
@property (nonatomic, strong) NSNumber *loyaltyScore;
@property (nonatomic, strong) NSNumber *demandScore;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *favoriteScore;
@property (nonatomic, strong) NSNumber *selfieScore;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSArray  *servicesIdArray;
@property (nonatomic, strong) NSSet  *folderIds;
@property (nonatomic, strong) NSArray *stylistServices;        //StylistServiceResModel
@property (nonatomic, strong) NSArray *stylistOperationHours; //StylistOperationHourResModel
@property (nonatomic, strong) NSArray *stylistPortfolios;



@end
