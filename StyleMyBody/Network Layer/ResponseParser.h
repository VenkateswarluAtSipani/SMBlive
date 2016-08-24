//
//  ResponseParser.h
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginResponseModel.h"
#import "SignUpResModel.h"
#import "GetcategoryResponceModel.h"
#import "HomeCatagoryResModel.h"
#import "CenterListResModel.h"
#import "OffersListResModel.h"
#import "StylistOfferResModel.h"
#import "FoldersResModel.h"
#import "ServiceResModel.h"
#import "SignUpDetailsResModel.h"
#import "CenterDetailResModel.h"
#import "ServiceResModel.h"
#import "StylistResModel.h"
#import "StylistOperationHourResModel.h"
#import "StylistServiceResModel.h"
#import "ReviewResModel.h"
#import "AllFoldersResModel.h"
#import "AllStylistsResModel.h"
#import "OfferFullDetailModel.h"
#import "UserProfileModel.h"
#import "ContactUsModel.h"
#import "AppointmentsResModel.h"
#import "BookingResponseModel.h"
#import "SearchAndFilterModel.h"
#import "EssentialsModel.h"

@interface ResponseParser : NSObject

+ (LoginResponseModel *)getLoginResponseModel:(NSDictionary *)dict;
+ (SignUpResModel *)getRegisterResponseModel:(NSDictionary *)dict;
+ (SignUpDetailsResModel *)getSignUpDetailResponseModel:(NSDictionary *)dict;
+ (GetcategoryResponceModel *)getCategoryResponseModel:(NSDictionary *)dict;
+ (NSArray *)getHomeCategoryResponseModel:(NSDictionary *)dict;
+ (NSArray *)getCenterListResponseModel:(NSDictionary *)dict withFilterParametersModel:(SearchAndFilterModel*)model;
+ (NSArray *)getOffersListResponseModel:(NSArray* )offers;
+ (CenterDetailResModel *)getOneCenterDetailResponseModel:(NSDictionary *)dict;
+ (NSArray *)getServiceResponseModel:(NSDictionary *)dict;
+ (NSArray *)getStylistsList:(NSDictionary *)dict;
+ (NSArray *)getServicesList:(NSDictionary *)dict;
+ (AllFoldersResModel *)getFoldersList:(NSDictionary *)dict;
+ (NSArray *)getReviewList:(NSDictionary *)dict;
+ (AllStylistsResModel *)getallstylists:(NSDictionary *)dict;
+ (NSArray *)getAutoSearchResult:(NSDictionary *)dict;
+ (OfferFullDetailModel *)getOffersDetailModel:(NSDictionary *)catDict withType:(NSString *)type;
+ (UserProfileModel* )getUserDetailModel:(NSDictionary* )userDetailDict;
+ (ContactUsModel *)contactUsModel:(NSDictionary *)userDetailDict;
+ (AppointmentsResModel *)appointmentsModel:(NSDictionary *)appointmentsDict;
+ (NSArray *)getServicesWithoutFolders:(NSDictionary *)dict;
+ (BookingResponseModel *)getBookingResponseModel:(NSDictionary *)tempDict
;
+ (NSArray *)getAddressListModel:(NSDictionary *)addressListDict;
+ (NSArray *)getMultiOffersListResponseModel:(NSArray* )multiOffers;
+ (EssentialsModel *)getEssentialsModelModel:(NSDictionary *)addressListDict;
+ (BookingResponseModel *)getPackageBookingResponseModel:(NSDictionary *)tempDict;
@end
