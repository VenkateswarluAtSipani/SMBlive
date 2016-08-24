//
//  CenterDetailResModel.h
//  StyleMyBody
//
//  Created by sipani online on 5/6/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CenterDetailResModel : NSObject


@property (nonatomic, strong) NSNumber *centerId;
@property (nonatomic, strong) NSNumber *primaryCategoryId;
@property (nonatomic, strong) NSNumber *isFavorite;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *serveFor;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *catDescription;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSNumber *isOffer;
@property (nonatomic, strong) NSNumber *isHomeService;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *displayImage;
@property (nonatomic, strong) NSNumber *travelTime;
@property (nonatomic, strong) NSNumber *advanceBookingPeriod;
@property (nonatomic, strong) NSString *amenities;
@property (nonatomic, strong) NSNumber *walkIn;
@property (nonatomic, strong) NSNumber *loyatlyscore;
@property (nonatomic, strong) NSNumber *demandscore;
@property (nonatomic, strong) NSNumber *isPackage;

@property (nonatomic, strong) NSNumber *primaryCategory;
@property (nonatomic, strong) NSNumber *maxPrice;

@property (nonatomic, strong) NSNumber *currentDistance;

@property (nonatomic, strong) NSArray *services; // ServiceModel
@property (nonatomic, strong) NSArray *centerCoverImages;
@property (nonatomic, strong) NSArray *operationHours; //OperationHoursResModel

@end
