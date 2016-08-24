//
//  BookingResponseModel.h
//  StyleMyBody
//
//  Created by sipani online on 26/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookingOfferModel.h"

@interface BookingResponseModel : NSObject

@property (nonatomic,strong)NSArray *address;
@property (nonatomic,strong)NSArray *bookedServices;
@property (nonatomic,strong)NSString *bookingDate1;
@property (nonatomic,strong)NSString *bookingId;
@property (nonatomic,strong)NSString *displayName;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSNumber *isHomeService;
@property (nonatomic,strong)NSString *latitude;
@property (nonatomic,strong)NSString *longitude;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSNumber *offerId;
@property (nonatomic,strong)NSNumber *packageId;
@property (nonatomic,strong)NSNumber *offset;
@property (nonatomic,strong)NSNumber *oldAmountPaid;
@property (nonatomic,strong)NSNumber *discountedPrice;
@property (nonatomic,strong)NSNumber *phone;
@property (nonatomic,strong)NSNumber *planType;
@property (nonatomic,strong)NSString *rescheduleCount;
@property (nonatomic,strong)NSString *serviceTax;
@property (nonatomic,strong)NSString *startTimeIndex;
@property (nonatomic,strong)NSNumber *totalAmount;
@property (nonatomic,strong)NSNumber *travelTime;
@property (nonatomic,strong)NSArray *OfferModelsArray;
@property (nonatomic,strong)BookingOfferModel *selectedOfferModel;
@property (nonatomic,strong)NSString *title;
//    address =     {
//        addressId = 188;
//        addressOne = "15, Arakere Bannerghatta Rd";
//        addressTwo = "Araka Mico Layout, Arekere";
//        city = "Bangalore Urban";
//        latitude = "12.886592";
//        longitude = "77.594977";
//        pincode = 560076;
//        state = Karnataka;
//        tagName = ven;
//    };
//    bookedServices =     (
//                          {
//                              name = "Head Massage";
//                              price = 500;
//                              serviceId = 6;
//                              time = 5;
//                          },
//                          {
//                              name = "Body Massage";
//                              price = 500;
//                              serviceId = 7;
//                              time = 10;
//                          }
//                          );



@end
