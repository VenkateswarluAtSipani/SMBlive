//
//  Utility.m
//  StyleMyBody
//
//  Created by sipani online on 4/15/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "Utility.h"
#import <CoreLocation/CoreLocation.h>

@implementation Utility


+ (NSString *)getDistanceFromLocations:(CLLocation *)fromLocation :(CLLocation *)toLocation;
  {
//    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:startLatitude longitude:startLongitude];
//    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:endLatitude longitude:endLongitude];
    CLLocationDistance distance = [fromLocation distanceFromLocation:toLocation] / 1000;
    
    return [NSString stringWithFormat:@"%.1f", distance];
}

+ (NSString *)getDateWithSpecificFormat:(NSString *)date format:(NSString *)dateFormat {
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *dateVal = [format dateFromString:date];
    
    format.dateFormat = @"dd MMMM yyyy";
    
    return [format stringFromDate:dateVal];
    
}



@end
