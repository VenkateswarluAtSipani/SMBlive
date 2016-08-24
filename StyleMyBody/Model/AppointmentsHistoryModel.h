//
//  AppointmentsHistoryModel.h
//  StyleMyBody
//
//  Created by sipani online on 20/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentsHistoryModel : NSObject


@property (nonatomic ,strong)NSNumber *amountPaid;
@property (nonatomic ,strong)NSArray *bookedServices;
@property (nonatomic ,strong)NSString *bookingDate;
@property (nonatomic ,strong)NSString *bookingId;
@property (nonatomic ,strong)NSNumber *bookingTime;
@property (nonatomic ,strong)NSString *centerAddress;
@property (nonatomic ,strong)NSNumber *centerId;
@property (nonatomic ,strong)NSString *centerLatitude;
@property (nonatomic ,strong)NSString *centerLongitude;
@property (nonatomic ,strong)NSString *centerName;
@property (nonatomic ,strong)NSString *centerPhone;
@property (nonatomic ,strong)NSNumber *centerStylistId;
@property (nonatomic ,strong)NSString *displayName;
@property (nonatomic ,strong)NSNumber *isHomeService;
@property (nonatomic ,strong)NSNumber *isOffer;
@property (nonatomic ,strong)NSNumber *isPackage;
@property (nonatomic ,strong)NSNumber *oldAmountPaid;
@property (nonatomic ,strong)NSNumber *rescheduleCount;
@property (nonatomic ,strong)NSNumber *status;
@property (nonatomic ,strong)NSNumber *stylistId;
@property (nonatomic ,strong)NSNumber *travelTime;


@property (nonatomic ,strong)NSArray *appointmentdetailsArr;







@end
