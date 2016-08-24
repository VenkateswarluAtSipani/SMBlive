//
//  TimeSlotReqModel.h
//  StyleMyBody
//
//  Created by apple on 19/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeSlotReqModel : NSObject
@property (nonatomic,strong) NSNumber *centerId;
@property (nonatomic,strong) NSNumber *centerStylistId;
@property (nonatomic,strong) NSString *dateTime;
@property (nonatomic,strong) NSString *serviceId;
@property (nonatomic,strong) NSNumber *stylistId;

@end
