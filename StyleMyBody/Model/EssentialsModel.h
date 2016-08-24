//
//  EssentialsModel.h
//  StyleMyBody
//
//  Created by apple on 11/08/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EssentialsModel : NSObject

@property (nonatomic,strong) NSArray *IHC;
@property (nonatomic,strong) NSNumber *bookingBufferTime;
@property (nonatomic,strong) NSNumber *rescheduleBufferTime;
@property (nonatomic,strong) NSNumber *cancellationBufferTime;

@property (nonatomic,strong) NSNumber *forceUpdate;
@property (nonatomic,strong) NSNumber *maxOfferRescheduleCount;
@property (nonatomic,strong) NSNumber *maxPackageRescheduleCount;
@property (nonatomic,strong) NSNumber *maxRescheduleCount;

@property (nonatomic,strong) NSNumber *recommendUpdate;

@property (nonatomic,strong) NSString *aboutus;
@property (nonatomic,strong) NSString *merchantAgreement;
@property (nonatomic,strong) NSString *privacy;
@property (nonatomic,strong) NSString *rescheduleAndCancelText;
@property (nonatomic,strong) NSString *terms;





@end
