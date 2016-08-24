//
//  AppontmentRequestModel.h
//  StyleMyBody
//
//  Created by sipani online on 13/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppontmentRequestModel : NSObject

@property (nonatomic, strong) NSNumber *centerId;
@property (nonatomic, strong) NSNumber *stylistId;
@property (nonatomic, strong) NSNumber *centerStylistId;
@property (nonatomic, strong) NSDate *bookingDate;
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSNumber *startTimeIndex;
@property (nonatomic, strong) NSNumber *offset;
@property (nonatomic, strong) NSNumber *packageId;
@property (nonatomic, strong) NSNumber *offerId;
@property (nonatomic, strong) NSNumber *walkIn;
@property (nonatomic, strong) NSNumber *travelTime;
@property (nonatomic, strong) NSNumber *bookedServicesserviceId;
@property (nonatomic, strong) NSString *bookedServicesname;
@property (nonatomic, strong) NSString *bookedServicesprice;
@property (nonatomic, strong) NSNumber *bookedServicestime;
@property (nonatomic, strong) NSNumber *bookedServicesisHomeService;

@property (nonatomic, strong) NSArray *bookedServicesArr;


@end
