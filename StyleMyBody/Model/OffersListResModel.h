//
//  OffersListResModel.h
//  StyleMyBody
//
//  Created by sipani online on 4/16/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OffersListResModel : NSObject

@property (nonatomic, strong) NSNumber *offerId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *centerName;
@property (nonatomic, strong) NSString *centerLatitude;
@property (nonatomic, strong) NSString *centerLongitude;
@property (nonatomic, strong) NSNumber *offerCategory;
@property (nonatomic, strong) NSString *offerCategoryValue;
@property (nonatomic, strong) NSNumber *offerType;
@property (nonatomic, strong) NSString *offerTypeValue;
@property (nonatomic, strong) NSNumber *offerEnd;
@property (nonatomic, strong) NSString *offerEndValue;
@property (nonatomic, strong) NSString *freeDetails;
@property (nonatomic, strong) NSString *descriptionOffer;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *discountedPrice;
@property (nonatomic, strong) NSString *endType;
@property (nonatomic, strong) NSString *endValue;
@property (nonatomic, strong) NSNumber *packageId;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSNumber *currentDistance;

@property (nonatomic, strong) NSArray *stylistOffer; // StylelistOfferResModel
@property (nonatomic, strong) NSArray *servicesOffer;
@property (nonatomic, strong) NSArray *centerCoverImages;
@property (nonatomic, strong) NSString *centerLogo;
@property (nonatomic, strong) NSString *centerAddressOne;
@property (nonatomic, strong) NSString *centerAddressTwo;
@property (nonatomic, strong) NSArray *folders; // FoldersResModel
@property (nonatomic, strong) NSArray *notMappedServices;

@end
