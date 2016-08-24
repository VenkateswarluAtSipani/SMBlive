//
//  OfferFullDetailModel.h
//  StyleMyBody
//
//  Created by K venkateswarlu on 29/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferFullDetailModel : NSObject
@property (nonatomic, strong) NSNumber *offerId;
@property (nonatomic, strong) NSString *centerAddressOne;
@property (nonatomic, strong) NSString *centerAddressTwo;
@property (nonatomic, strong) NSArray *centerCoverImagesArray;
@property (nonatomic, strong) NSNumber *centerId;
@property (nonatomic, strong) NSString *centerLatitude;
@property (nonatomic, strong) NSString *centerLongitude;
@property (nonatomic, strong) NSString *centerLogo;
@property (nonatomic, strong) NSString *centerName;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *createdDateTime;
@property (nonatomic, strong) NSString *descriptio;
@property (nonatomic, strong) NSString *freeDetails;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSNumber *offerCategory;
@property (nonatomic, strong) NSNumber *offerCategoryValue;
@property (nonatomic, strong) NSNumber *offerEnd;
@property (nonatomic, strong) NSString *offerEndValue;
@property (nonatomic, strong) NSArray *offerHappyHours;
@property (nonatomic, strong) NSNumber *offerTypeValue;
@property (nonatomic, strong)  NSArray *servicesOfferArray;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *stylistOfferArray;


@property (nonatomic, strong) NSNumber *packageId;
@property (nonatomic,strong) NSNumber *sittingsType;
@property (nonatomic ,strong) NSNumber *price;
@property (nonatomic ,strong) NSNumber *discountedPrice ;
@property (nonatomic ,strong) NSNumber *packageEndType ;
@property (nonatomic ,strong) NSNumber *packageEndValue;

@end
