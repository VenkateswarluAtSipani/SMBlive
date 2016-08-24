//
//  Utility.h
//  StyleMyBody
//
//  Created by sipani online on 4/15/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Utility : NSObject

+ (NSString *)getDistanceFromLocations:(CLLocation *)fromLocation :(CLLocation *)toLocation;

+ (NSString *)getDateWithSpecificFormat:(NSString *)date format:(NSString *)dateFormat;
@end
