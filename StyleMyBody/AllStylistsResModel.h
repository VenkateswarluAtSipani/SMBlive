//
//  AllStylistsResModel.h
//  StyleMyBody
//
//  Created by sipani online on 5/18/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllStylistsResModel : NSObject

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *opDay;
@property (nonatomic, strong) NSNumber *travelTime;
@property (nonatomic, strong) NSNumber *advanceBookingPeriod;
@property (nonatomic, strong) NSNumber *startHour;
@property (nonatomic, strong) NSNumber *offset;
@property (nonatomic, strong) NSArray *stylistResArr;     //StylistResModel

@end
