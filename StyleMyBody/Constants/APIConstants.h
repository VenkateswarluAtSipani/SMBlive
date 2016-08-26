//
//  APIConstants.h
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#ifndef APIConstants_h
#define APIConstants_h

#define APIKEY @"765022d2f23b3ae5b24abcc6a165449dff002ee16080b232cb4119a449e4aa70"
#define PAYMENTKEY @"471612ce362f7fe104112965467367487e42d3a9f979a2c5094db7dee53b3052"

//#define BASEURL @"http://api.stylemybody.com/"

//#define BASEURL @"http://ec2-52-76-51-184.ap-southeast-1.compute.amazonaws.com/"

//#define BASEURL @"http://ec2-52-74-18-36.ap-southeast-1.compute.amazonaws.com/"

#define BASEURL @"http://ec2-52-76-234-1.ap-southeast-1.compute.amazonaws.com/"

//#define BASEURL @"http://ec2-52-76-234-1.ap-southeast-1.compute.amazonaws.com/"

#define AppId @"1056920780"
#define VersionCheckApi @"http://itunes.apple.com/lookup?id="

#define GetEssentials BASEURL @"customerapi/v1/essentials"

#define LOGIN_API BASEURL @"customerapi/v1/login"

#define LOGOUT_API BASEURL @"customerapi/v1/logout"

#define REGISTER_API BASEURL @"customerapi/v1/register"

#define FORGOTPASSWORD_API BASEURL @"customerapi/v1/forgotpassword"

#define OTP_API BASEURL @"customerapi/v1/otp"

#define HOME_CATEGORY_API BASEURL @"customerapi/v1/home?resolution=1"

#define ALL_CENTER_API BASEURL @"customerapi/v1/getallcenters"

#define ALL_RECENT_CENTER_API BASEURL @"customerapi/v1/center/recent"

#define ALL_OFFERS_API BASEURL @"customerapi/v1/offer/alloffers"

#define ONE_CENTER_DETAIL_API BASEURL @"customerapi/v1/getonecenter"

#define ALL_CENTER_STYLIST_LIST BASEURL @"customerapi/v1/getcenterstylists"

#define GET_FOLDER_LIST BASEURL @"customerapi/v1/getfolderlist"

#define GET_CENTER_REVIEW_LIST BASEURL @"customerapi/v1/review"

#define GET_ALL_STYLISTS_Offer BASEURL @"customerapi/v1/offerstylist"
#define GET_ALL_STYLISTS_LIST BASEURL @"customerapi/v1/getallstylists"

#define GET_ALL_SERVICE_LIST BASEURL @"customerapi/v1/getservicelist"
#define GET_ALL_SERVICE_LISTWITHGROUPS BASEURL @"customerapi/v1/getfolderlist"

#define GET_AUTO_SEARCH BASEURL @"customerapi/v1/autosearch"

#define FEV_CENTER BASEURL @"customerapi/v1/center/favorite"
#define FEV_STYLIST BASEURL @"customerapi/v1/stylist/favorite"


#define  OFFER_FULL_DETAILS @"customerapi/v1/offer/getoffer"

#define PACKAGE_FULL_DETAILS @"customerapi/v1/package/getpackage"

#define  GET_PROFILE_DETAILS @"customerapi/v1/profile"

#define  CONTACTUS_DETAILS @"customerapi/v1/contactus"

#define RESEND_OTP_API BASEURL @"customerapi/v1/resendotp"

#define  CHANGE_PASSWORD BASEURL @"customerapi/v1/changepassword"

#define  PROFILE_DETAILS_UPDATE BASEURL @"customerapi/v1/profile"

#define  APPOINTEMENT BASEURL @"customerapi/v1/appointment"
#define  BOOKINGDETAILS BASEURL @"customerapi/v1/bookingdetails"

#define  CancleAPPOINTEMENT BASEURL @"customerapi/v1/booking/cancel"

#define GET_APPOINTEMENTS_DETAILS @"customerapi/v1/appointments?type="

#define GET_SLIDERDETAILS @"customerapi/v1/booking?centerId="
#define  GET_ADDRESS_LIST @"customerapi/v1/address/list"

#define  GET_MultiOffers BASEURL @"customerapi/v1/multioffers"
#define UpdateAddress BASEURL @"customerapi/v1/address/update"
#define AddAddress BASEURL @"customerapi/v1/address/add"
#define DeleteAddress BASEURL @"customerapi/v1/address"
//http://ec2-52-76-234-1.ap-southeast-1.compute.amazonaws.com/customerapi/v1/booking?centerId=1&centerStylistId=1&dateTime=2016-07-19&serviceId=5%2C3&stylistId=1

#define claimPackage BASEURL @"customerapi/v1/packageclaim?packageId=%@"

#define GoToPayment BASEURL @"customerapi/v1/gotopayment"
#define GetBookingInfo BASEURL @"customerapi/v1/bookinginfo"

#define BillUrl BASEURL @"customerapi/v1/citruspay"

#endif /* APIConstants_h */
