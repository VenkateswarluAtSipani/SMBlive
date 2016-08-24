//
//  AppointmentReqModel.h
//  StyleMyBody
//
//  Created by apple on 19/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentReqModel : NSObject
@property (nonatomic,strong)NSArray *bookedServices;
@property (nonatomic,strong)NSString *bookingDate;
@property (nonatomic,strong)NSNumber *centerId;
@property (nonatomic,strong)NSNumber *centerStylistId;
@property (nonatomic,strong)NSNumber *offerId;
@property (nonatomic,strong)NSNumber *offset;
@property (nonatomic,strong)NSNumber *packageId;
@property (nonatomic,strong)NSNumber *startTimeIndex;
@property (nonatomic,strong)NSNumber *stylistId;
@property (nonatomic,strong)NSNumber *totalAmount;
@property (nonatomic,strong)NSNumber *travelTime;
@property (nonatomic,strong)NSNumber *walkIn;
@end
