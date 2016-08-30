//
//  RestClient.h
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginResponseModel.h"
#import "LoginRequestModel.h"
#import "RegisterRequestModel.h"
#import "SignUpResModel.h"
#import "GetcategoryResponceModel.h"
#import "SignUpDetailsResModel.h"
#import "CenterDetailResModel.h"
#import "AllFoldersResModel.h"
#import "AllStylistsResModel.h"
#import "OfferFullDetailModel.h"
#import "UserProfileModel.h"
#import "ContactUsModel.h"
#import "AppointmentsResModel.h"
#import "ProfileUpdateReuestModel.h"
#import "ChangePasswordRequestModel.h"
#import "TimeSlotReqModel.h"
#import "AppointmentReqModel.h"
#import "BookingResponseModel.h"
#import "SearchAndFilterModel.h"
#import "AddressListModel.h"
#import "EssentialsModel.h"

@interface RestClient : NSObject


- (void)login:(LoginRequestModel *)requestModel callBackHandler:(void(^)(LoginResponseModel *response, NSError *error))handler;

- (void)logout:(NSNumber *)channelId callBackHandler:(void(^)(NSDictionary *res , NSError *error))handler;

- (void)registerUser:(RegisterRequestModel *)requestModel callBackHandler:(void(^)(SignUpResModel *response, NSError *error))handler;

- (void)forgotPassword:(NSString *)requestModel callBackHandler:(void(^)(NSString *response, NSError *error))handler;


- (void)sendOTP:(SignUpResModel *)requestModel callBackHandler:(void(^)(SignUpDetailsResModel *response, NSError *error))handler;

- (void)ReSendOTP:(NSString *)PhNo callBackRes:(void(^)(AllFoldersResModel *foldersResModel, NSError *error))handler;

- (void)category:(void(^)(SignUpResModel *response, NSError *error))handler;

- (void)getHomeCategoryList:(void(^)(NSArray *catList, NSError *error))handler;

- (void)getCenterList:(SearchAndFilterModel *)searchAndFilterModel callBackRes:(void(^)(NSArray *centerList, NSError *error))handler;

- (void)getRecentCenterList:(NSNumber *)categoryID callBackRes:(void(^)(NSArray *recentCenterList, NSError *error))handler;

- (void)getOneCenterDetail:(NSNumber *)centerID callBackRes:(void(^)(CenterDetailResModel *centerDetail, NSError *error))handler;

- (void)getAllOffersList:(NSNumber *)categoryID withCenterId:(NSNumber *)centerId callBackRes:(void(^)(NSArray *centerList, NSError *error))handler;

- (void)getCenterStylistList:(NSNumber *)centerID callBackRes:(void(^)(NSArray *stylistArr, NSError *error))handler;

- (void)getCenterServiceList:(NSNumber *)centerID callBackRes:(void(^)(NSArray *serviceArr, NSError *error))handler;

- (void)getAllFoldersList:(NSNumber *)centerID callBackRes:(void(^)(AllFoldersResModel *foldersResModel, NSError *error))handler;

- (void)getCenterReviewsList:(NSNumber *)centerID callBackRes:(void(^)(NSArray *reviewList, NSError *error))handler;

- (void)getAllStylists:(NSNumber *)centerID andOfferId:(NSNumber*)offerId andDate:(NSString*)dateStr callBackRes:(void(^)(AllStylistsResModel *allStylistsResModel, NSError *error))handler;

- (void)getAllServicelists:(NSNumber *)centerID callBackRes:(void(^)(NSArray *serviceListArr, NSError *error))handler;
- (void)getAllServicelistsWithoutGroups:(NSNumber *)centerID callBackRes:(void(^)(NSArray *serviceListArr, NSError *error))handler;
- (void)setFev:(NSNumber *)centerID isFev:(NSNumber *)isFev callBackRes:(void(^)(NSString *resStr, NSError *error))handler;

- (void)getAutoSearch:(NSNumber *)centerID isFev:(NSString *)searchStr callBackRes:(void(^)(NSArray *autoSearchArr, NSError *error))handler;

- (void)getOfferDetails:(NSNumber *)offerId withCenterId:(NSNumber *)centerId withType:(NSString*)type callBackRes:(void(^)(OfferFullDetailModel *centerList, NSError *error))handler;
- (void)getProfileDetails:(void(^)(UserProfileModel *userProfileList, NSError *error))handler;

- (void)getContactUsDetails:(void(^)(ContactUsModel* contactUsList, NSError *error))handler;
- (void)reSendOTP:(SignUpResModel *)requestModel callBackHandler:(void(^)(SignUpDetailsResModel* response, NSError *error))handler;
- (void)ProfileDetailsUpdate:(ProfileUpdateReuestModel *)requestModel callBackHandler:(void(^)(NSString* response, NSError *error))handler;
- (void)getAppointmentsDetails:(NSInteger )type callBackHandler:(void(^)(AppointmentsResModel*appointments, NSError *error))handler;
- (void)changePassword:(ChangePasswordRequestModel *)requestModel callBackHandler:(void(^)(NSString *response, NSError *error))handler;
- (void)getTimeSlotDetails:(TimeSlotReqModel* )type callBackHandler:(void(^)(NSDictionary*appointments, NSError *error))handler;
- (void)getBookingId:(AppointmentReqModel *)appointmentReqModel callBackRes:(void(^)(NSData *data, NSError *error))handler ;
- (void)CancleBookingId:(NSString *)bookingId callBackRes:(void(^)(NSData *data, NSError *error))handler;
- (void)getBookingDetails:(NSString *)BookingId callBackHandler:(void(^)(BookingResponseModel *model , NSError *error))handler;
- (void)getAddressList:(void(^)(NSArray *addressList, NSError *error))handler;
-(BOOL)rechabilityCheck;
+ (BOOL)validateEmailWithString:(NSString*)email;
- (void)getMultiOffers:(NSString *)bookingId withOfferId:(NSNumber*)offerId callBackRes:(void(^)(NSArray *data, NSError *error))handler;

- (void)UpdaterAddress:(AddressListModel *)addressListModel callBackRes:(void(^)(NSData *data, NSError *error))handler;
- (void)deleteAddress:(NSNumber *)addressId callBackRes:(void(^)(NSDictionary *responce, NSError *error))handler;
- (void)addAddress:(AddressListModel *)addressListModel callBackRes:(void(^)(NSData *data, NSError *error))handler;
- (void)setFevStylist:(NSNumber *)centerStylistId centerId:(NSNumber *)centerID isFev:(NSNumber *)isFev callBackRes:(void(^)(NSString *resStr, NSError *error))handler;
- (void)goToPaymentWithParameters:(NSDictionary *)goToPaymentDict callBackHandler:(void(^)( NSDictionary *response, NSError *error))handler ;
- (void)getBookingInfo:(NSDictionary *)BookingInfo callBackHandler:(void(^)( NSDictionary *response, NSError *error))handler;
-(NSString *)getBillGenerateUrlVerifier:(NSString*)TxId;
- (void)getLatestVersionOfAPPcallBackRes:(void(^)(NSString *latestVersion, NSError *error))handler;
- (void)getAccentials:(void(^)(EssentialsModel *latestVersion, NSError *error))handler;
+(void)loadImageinImgView:(UIImageView*)ImgView withUrlString:(NSString*)urlStr;
- (void)claimPackageWithID:(NSNumber*)packageID callBackRes:(void(^)(BookingResponseModel *latestVersion, NSError *error))handler;
@end
