//
//  BookingOfferModel.h
//  StyleMyBody
//
//  Created by sipani online on 02/08/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookingOfferModel : NSObject

@property (nonatomic, strong) NSNumber *offerId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *descriptionOffer;
@property (nonatomic, strong) NSNumber *offerCategory;
@property (nonatomic, strong) NSString *offerCategoryValue;
@property (nonatomic, strong) NSNumber *offerEnd;
@property (nonatomic, strong) NSString *offerEndValue;
@property (nonatomic, strong) NSNumber *offerFlag;
@property (nonatomic, strong) NSArray *offerServices;
@property (nonatomic, strong) NSNumber *offerValue;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSNumber  *discountPrice;

@end
