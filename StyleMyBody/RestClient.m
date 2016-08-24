//
//  RestClient.m
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "RestClient.h"
#import "ResponseParser.h"
#import "APIConstants.h"
#import "SignInDetailHandler.h"
#import "LoginResponseModel.h"
#import "OfferFullDetailModel.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "Reachability.h"
#import "TimeSlotReqModel.h"
#import "AppointmentReqModel.h"
#import <UIKit/UIKit.h>

@implementation RestClient

- (void)login:(LoginRequestModel *)requestModel callBackHandler:(void(^)(LoginResponseModel *response, NSError *error))handler {
    NSData *postData = [requestModel getLoginRequest];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:LOGIN_API withDta:postData type:@"POST"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        LoginResponseModel *model;
        if (httpResponse.statusCode == 200) {
            model = [ResponseParser getLoginResponseModel:resDict];
            handler(model,error);
        }else  {
            NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":resDict[@"message"] }];
            NSLog(@"%@",[error localizedDescription]);
            handler(model,manualerror);
        }
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
    [postDataTask resume];
}


-(NSURLRequest*)postRequestWithUrl:(NSString*)urlStr withDta:(NSData*)postData type:(NSString*)postOrPut{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *timeStampStr = [NSString stringWithFormat:@"%.0f",timeStamp];
    // timeStampStr = @"1451388009";
    //    NSString * newCountryString = [self hma]; //[s stringByAddingPercentEncodingForRFC3986:4];
    NSString * newCountryString =[self hmac:timeStampStr withKey:APIKEY];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:newCountryString forHTTPHeaderField:@"Signature"];
    [request addValue:timeStampStr forHTTPHeaderField:@"Timestamp"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:postOrPut];
    SignInDetailHandler *handler1 = [SignInDetailHandler sharedInstance];
    LoginResponseModel *resModel = handler1.loginResModel;
    [request addValue:resModel.authToken forHTTPHeaderField:@"token"];
    [request setHTTPBody:postData];
    return request;
}
//- (void)checkFbUserOrGoogleUserAlreadyExisted:(LoginRequestModel *)requestModel callBackHandler:(void(^)(bool isAlreadySignedUp, NSError *error))handler {
//    
//   
//    
//    NSError *error;
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:requestModel.signupType],@"signupType", nil];
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURL *url = [NSURL URLWithString:LOGIN_API];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval:60.0];
//    [request addValue:newCountryString forHTTPHeaderField:@"Signature"];
//    [request addValue:timeStampStr forHTTPHeaderField:@"Timestamp"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:postData];
//    
//    
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        
//        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//      
//        if (httpResponse.statusCode == 200) {
//           
//            handler(YES,error);
//        }else  {
////            NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":resDict[@"message"] }];
////            NSLog(@"%@",[error localizedDescription]);
//            handler(YES,error);
//        }
//        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        
//    }];
//    
//    [postDataTask resume];
//}
-(NSURLRequest*)getRequestWithUrl:(NSString*)urlStr{
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *timeStampStr = [NSString stringWithFormat:@"%.0f",timeStamp];
    // timeStampStr = @"1451388009";
    //    NSString * newCountryString = [self hma]; //[s stringByAddingPercentEncodingForRFC3986:4];
    
    NSString * newCountryString =[self hmac:timeStampStr withKey:APIKEY];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:newCountryString forHTTPHeaderField:@"Signature"];
    [request addValue:timeStampStr forHTTPHeaderField:@"Timestamp"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    SignInDetailHandler *handler1 = [SignInDetailHandler sharedInstance];
    LoginResponseModel *resModel = handler1.loginResModel;
    [request addValue:resModel.authToken forHTTPHeaderField:@"token"];
    return request;
}
- (void)logout:(NSNumber *)channelId callBackHandler:(void(^)(NSDictionary *res , NSError *error))handler;
{
 
   
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?channelId=%@",LOGOUT_API,[channelId  stringValue]];
   

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (httpResponse.statusCode == 200) {
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            handler(res,error);
        }else  {
            NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":resDict[@"message"] }];
            NSLog(@"%@",[error localizedDescription]);
            handler(nil,manualerror);
        }
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
    [postDataTask resume];
}

- (void)registerUser:(RegisterRequestModel *)requestModel callBackHandler:(void(^)(SignUpResModel *response, NSError *error))handler {
   
    
    NSData *postData = [requestModel getRegisterRequest];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:REGISTER_API withDta:postData type:@"POST"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *resDict;
         SignUpResModel *model;
        NSError *error;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

        if (data != nil) {
            resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (httpResponse.statusCode == 200) {
                    model = [ResponseParser getRegisterResponseModel:resDict];
                    handler(model,error);
                }else  if (httpResponse.statusCode == 400) {
//                    NSDictionary *dict = resDict[@"errors"];
//                    NSDictionary * dictTemp = dict[@"field_errors"];
                    NSString *msg = [resDict objectForKey:@"message"];
                    NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":msg }];
                    handler(model,manualerror);
                }
        }else{
            NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":@"Request timed out" }];
            NSLog(@"%@",[error localizedDescription]);
            handler(model,manualerror);

        }
    });

        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [postDataTask resume];
}

- (void)forgotPassword:(NSString *)requestModel callBackHandler:(void(^)(NSString *response, NSError *error))handler;
{
  
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:requestModel,@"phone", nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:FORGOTPASSWORD_API withDta:postData type:@"PUT"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *resDict;
            SignUpResModel *model;
            NSError *error;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            if (data != nil) {
                resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (httpResponse.statusCode == 200) {
                    model = [ResponseParser getRegisterResponseModel:resDict];
                    handler(@"Success",error);
                }else  if (httpResponse.statusCode == 400) {
                    //                    NSDictionary *dict = resDict[@"errors"];
                    //                    NSDictionary * dictTemp = dict[@"field_errors"];
                    NSString *msg = [resDict objectForKey:@"message"];
                    NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":msg }];
                    handler(@"",manualerror);
                }
            }else{
                NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":@"Request timed out" }];
                NSLog(@"%@",[error localizedDescription]);
                handler(@"",manualerror);
                
            }
        });
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [postDataTask resume];
}

- (void)sendOTP:(SignUpResModel *)requestModel callBackHandler:(void(^)(SignUpDetailsResModel *response, NSError *error))handler;
{
    NSDictionary *resDict = [NSDictionary dictionaryWithObjectsAndKeys:requestModel.phone,@"phone",requestModel.userType,@"userType",requestModel.otp,@"otp", nil];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:resDict options:NSJSONWritingPrettyPrinted error:&error];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:OTP_API withDta:postData type:@"POST"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SignUpDetailsResModel *model;
            if (httpResponse.statusCode == 200) {
                model = [ResponseParser getSignUpDetailResponseModel:resDict];
                handler(model,error);
            }else  {
                NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":resDict[@"message"] }];
                NSLog(@"%@",[error localizedDescription]);
                handler(model,manualerror);
            }
        });
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [postDataTask resume];
}

- (void)getHomeCategoryList:(void(^)(NSArray *catList, NSError *error))handler;
{

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:HOME_CATEGORY_API] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data) {
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSArray *categoryList = [ResponseParser getHomeCategoryResponseModel:resDict];
            
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            handler(categoryList,error);
        }else{
            handler(nil,error);
        }
    }];
    [postDataTask resume];
        

}

- (void)getCenterList:(SearchAndFilterModel *)searchAndFilterModel callBackRes:(void(^)(NSArray *centerList, NSError *error))handler{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *searchStr;
    if (!searchAndFilterModel.search) {
        searchStr=@"";
    }else{
       searchStr= [self urlencode:searchAndFilterModel.search];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@?categoryId=%ld&id=%ld&search=%@&type=%ld",ALL_CENTER_API,(long)[searchAndFilterModel.categoryId integerValue],(long)[searchAndFilterModel.Id integerValue],searchStr,(long)[searchAndFilterModel.type integerValue]];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSArray *categoryList = [ResponseParser getCenterListResponseModel:resDict withFilterParametersModel:searchAndFilterModel];
            
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            handler(categoryList,error);
        }else{
        handler(nil,error);
        }
    }];
    [postDataTask resume];
}

- (void)getRecentCenterList:(NSNumber *)categoryID callBackRes:(void(^)(NSArray *recentCenterList, NSError *error))handler
{

    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@?categoryId=%@",ALL_RECENT_CENTER_API,categoryID];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *categoryList = [ResponseParser getCenterListResponseModel:resDict withFilterParametersModel:nil];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(categoryList,error);
    }];
    [postDataTask resume];
    
}


- (void)getAllOffersList:(NSNumber *)categoryID withCenterId:(NSNumber *)centerId callBackRes:(void(^)(NSArray *centerList, NSError *error))handler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlStr ;
    if (centerId) {
        urlStr = [NSString stringWithFormat:@"%@?centerId=%@",ALL_OFFERS_API,centerId];
    }else{
        urlStr = [NSString stringWithFormat:@"%@?offerCategoryId=%@",ALL_OFFERS_API,categoryID];
    }
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *categoryList = [ResponseParser getOffersListResponseModel:resDict[@"offers"]];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(categoryList,error);
        });
        
    }];
    [postDataTask resume];

}
- (void)getOfferDetails:(NSNumber *)offerId withCenterId:(NSNumber *)centerId withType:(NSString*)type callBackRes:(void(^)(OfferFullDetailModel *centerList, NSError *error))handler {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr;
    if ([type isEqualToString:@"offer"]) {
        urlStr = [NSString stringWithFormat:@"%@%@?offerId=%@",BASEURL,OFFER_FULL_DETAILS,offerId];
    }else{
         urlStr = [NSString stringWithFormat:@"%@%@?packageId=%@",BASEURL,PACKAGE_FULL_DETAILS,offerId];
    }
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        OfferFullDetailModel *categoryList = [ResponseParser getOffersDetailModel:resDict withType:type];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(categoryList,error);
        });
        
    }];
    [postDataTask resume];
    
}

- (void)getOneCenterDetail:(NSNumber *)centerID callBackRes:(void(^)(CenterDetailResModel *centerDetail, NSError *error))handler
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@?centerId=%@",ONE_CENTER_DETAIL_API,centerID];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        CenterDetailResModel *detailModel = [ResponseParser getOneCenterDetailResponseModel:resDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(detailModel,error);
    }];
    [postDataTask resume];
    
}

- (void)getCenterStylistList:(NSNumber *)centerID callBackRes:(void(^)(NSArray *stylistArr, NSError *error))handler
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@?centerId=%@",ALL_CENTER_STYLIST_LIST,centerID];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *stylistArr = [ResponseParser getStylistsList:resDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(stylistArr,error);
    }];
    [postDataTask resume];
}

- (void)setFev:(NSNumber *)centerID isFev:(NSNumber *)isFev callBackRes:(void(^)(NSString *resStr, NSError *error))handler {
    
    NSError *error;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:centerID,@"centerId",isFev,@"isFavorite", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:FEV_CENTER withDta:data type:@"POST"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(@"",error);
    }];
    [postDataTask resume];
}


- (void)setFevStylist:(NSNumber *)centerStylistId centerId:(NSNumber *)centerID isFev:(NSNumber *)isFev callBackRes:(void(^)(NSString *resStr, NSError *error))handler {
    
    NSError *error;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:centerStylistId,@"centerStylistId",centerID,@"centerId",isFev,@"isFavorite", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    //    NSString *urlStr = [NSString stringWithFormat:@"%@?centerId=%@",ALL_CENTER_STYLIST_LIST,centerID];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:FEV_STYLIST withDta:data type:@"POST"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //        NSArray *stylistArr = [ResponseParser getStylistsList:resDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(@"",error);
    }];
    [postDataTask resume];
}
//+ (void)getCenterServiceList:(NSNumber *)centerID callBackRes:(void(^)(NSArray *serviceArr, NSError *error))handler;
//{
//    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
//    NSString *timeStampStr = [NSString stringWithFormat:@"%.0f",timeStamp];
//    timeStampStr = @"1451388009";
//    NSString * newCountryString = @"ZRBWsdZK%2FQVQdayJv4eWT%2BLb7PqdhTJhFMlQwaMKth0%3D"; //[s stringByAddingPercentEncodingForRFC3986:4];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSString *urlStr = [NSString stringWithFormat:@"%@?centerId=%@",STYLIST_LIST,centerID];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval:60.0];
//    [request addValue:newCountryString forHTTPHeaderField:@"Signature"];
//    [request addValue:timeStampStr forHTTPHeaderField:@"Timestamp"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPMethod:@"GET"];
//    
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//        NSArray *stylistArr = [ResponseParser getStylistsList:resDict];
//        
//        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        handler(stylistArr,error);
//    }];
//    [postDataTask resume];
//}

- (void)getAllFoldersList:(NSNumber *)centerID callBackRes:(void(^)(AllFoldersResModel *foldersResModel, NSError *error))handler
{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?centerId=%@",GET_FOLDER_LIST,centerID];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        AllFoldersResModel *folderModel = [ResponseParser getFoldersList:resDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(folderModel,error);
    }];
    [postDataTask resume];
}

- (void)getCenterReviewsList:(NSNumber *)centerID callBackRes:(void(^)(NSArray *reviewList, NSError *error))handler
{
  
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?centerId=%@",GET_CENTER_REVIEW_LIST,centerID];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *reviewList = [ResponseParser getReviewList:resDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(reviewList,error);
    }];
    [postDataTask resume];
}

- (void)getAllStylists:(NSNumber *)centerID andOfferId:(NSNumber*)offerId andDate:(NSString*)dateStr callBackRes:(void(^)(AllStylistsResModel *allStylistsResModel, NSError *error))handler
 {
     NSURLSession *session = [NSURLSession sharedSession];
     if (dateStr.length==0) {
         dateStr=[RestClient getCurrentDate];
     }
     NSString *urlStr;
     if (offerId>0) {
    urlStr = [NSString stringWithFormat:@"%@?date=%@&offerId=%@",GET_ALL_STYLISTS_Offer,dateStr,offerId];
     }else{
    urlStr = [NSString stringWithFormat:@"%@?centerId=%@&dateTime=%@",GET_ALL_STYLISTS_LIST,centerID,dateStr];
     }
     
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        AllStylistsResModel *model = [ResponseParser getallstylists:resDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(model,error);
    }];
    [postDataTask resume];

}
- (void)getAllServicelistsWithoutGroups:(NSNumber *)centerID callBackRes:(void(^)(NSArray *serviceListArr, NSError *error))handler
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@?centerId=%@",GET_ALL_SERVICE_LIST,centerID];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *servicesArray = [ResponseParser getServicesWithoutFolders:resDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(servicesArray,error);
    }];
    [postDataTask resume];
}

- (void)getAllServicelists:(NSNumber *)centerID callBackRes:(void(^)(NSArray *serviceListArr, NSError *error))handler
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@?centerId=%@",GET_ALL_SERVICE_LISTWITHGROUPS,centerID];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *foldersModelsArray = [ResponseParser getServicesList:resDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(foldersModelsArray,error);
    }];
    [postDataTask resume];
    
}

- (void)getAutoSearch:(NSNumber *)centerID isFev:(NSString *)searchStr callBackRes:(void(^)(NSArray *autoSearchArr, NSError *error))handler {
    NSURLSession *session = [NSURLSession sharedSession];
    searchStr=[self urlencode:searchStr];
    NSString *urlStr = [NSString stringWithFormat:@"%@?categoryId=%ld&search=%@",GET_AUTO_SEARCH,(long)[centerID integerValue],searchStr];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary  *SearchDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//        AllStylistsResModel *model = [ResponseParser getAutoSearchResult:resDict];
        NSArray *searchArray=[ResponseParser getAutoSearchResult:SearchDict];

        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(searchArray,error);
    }];
    [postDataTask resume];
}

+ (NSString *)getCurrentDate {
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;

}
- (void)getProfileDetails:(void(^)(UserProfileModel *userProfileList, NSError *error))handler{

    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,GET_PROFILE_DETAILS];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse* response, NSError* error) {
        
        NSDictionary  *userProfileDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //        AllStylistsResModel *model = [ResponseParser getAutoSearchResult:resDict];
        UserProfileModel *userProfileModel=[ResponseParser getUserDetailModel:userProfileDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(userProfileModel,error);
    }];
    [postDataTask resume];
    
    
}
- (void)getContactUsDetails:(void(^)(ContactUsModel* contactUsList, NSError *error))handler{

    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,CONTACTUS_DETAILS];
    NSURLSessionDataTask* postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData* data, NSURLResponse* response, NSError *error) {
        
        NSDictionary  *contactUsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //        AllStylistsResModel *model = [ResponseParser getAutoSearchResult:resDict];
        ContactUsModel *contactUsModel=[ResponseParser contactUsModel:contactUsDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(contactUsModel,error);
    }];
    [postDataTask resume];
    
    
}

- (void)changePassword:(ChangePasswordRequestModel *)requestModel callBackHandler:(void(^)(NSString *response, NSError *error))handler

{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:requestModel.oldpassword,@"oldPassword",requestModel.newpassword,@"password", nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:CHANGE_PASSWORD withDta:postData type:@"PUT"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *resDict;
            
            SignUpResModel *model;
            
            NSError *error;
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (data != nil) {
                
                resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                
                if (httpResponse.statusCode == 200) {
                    
                    model = [ResponseParser getRegisterResponseModel:resDict];
                    
                    handler(@"Success",error);
                    
                }else  if (httpResponse.statusCode == 400) {
                    
                    //                    NSDictionary *dict = resDict[@"errors"];
                    
                    //                    NSDictionary * dictTemp = dict[@"field_errors"];
                    
                    NSString *msg = [resDict objectForKey:@"message"];
                    
                    NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":msg }];
                    
                    handler(@"",manualerror);
                    
                }
                
            }else{
                
                NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":@"Request timed out" }];
                
                NSLog(@"%@",[error localizedDescription]);
                
                handler(@"",manualerror);
                
                
                
            }
            
        });
        
        
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
    
    
    [postDataTask resume];
    
    
    
    
    
}

- (void)ProfileDetailsUpdate:(ProfileUpdateReuestModel *)requestModel callBackHandler:(void(^)(NSString *response, NSError *error))handler

{
    
    NSString *str;
    if (requestModel.photo.length>0) {
        str=[NSString stringWithFormat:@"%@",requestModel.photo];
    }else{
        str=@"";
    }
    
    NSString*firstname=requestModel.firstName;
    NSString*capitalname=[firstname uppercaseString];
    NSString*lastname=requestModel.lastName;
    NSString*capitalLastName=[lastname uppercaseString];
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:capitalname,@"firstName",capitalLastName,@"lastName",requestModel.email,@"email",requestModel.phone,@"phone",str,@"photo",requestModel.signupType,@"signupType",requestModel.gender,@"gender",requestModel.isNotification,@"isNotification",requestModel.customerRegId,@"customerRegId",nil];
    
    NSError *error;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",PROFILE_DETAILS_UPDATE];

    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:urlStr withDta:postData type:@"PUT"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *resDict;
            
            SignUpResModel *model;
            
            NSError *error;
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            
            
            if (data != nil) {
                
                resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                
                if (httpResponse.statusCode == 200) {
                    
                    model = [ResponseParser getRegisterResponseModel:resDict];
                    
                    handler(@"Success",error);
                    
                }else  if (httpResponse.statusCode == 400) {
                    
                    //                    NSDictionary *dict = resDict[@"errors"];
                    
                    //                    NSDictionary * dictTemp = dict[@"field_errors"];
                    
                    NSString *msg = [resDict objectForKey:@"message"];
                    
                    NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":msg }];
                    
                    handler(@"",manualerror);
                }
                
            }else{
                
                NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":@"Request timed out" }];
                NSLog(@"%@",[error localizedDescription]);
                handler(@"",manualerror);
            }
            
        });
        
        
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
    [postDataTask resume];
}

- (void)getAppointmentsDetails:(NSInteger )type callBackHandler:(void(^)(AppointmentsResModel*appointments, NSError *error))handler

{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%ld",BASEURL,GET_APPOINTEMENTS_DETAILS,type];
    NSURLSessionDataTask* postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData* data, NSURLResponse* response, NSError *error) {
        
        NSDictionary  *appointmentsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        //        AllStylistsResModel *model = [ResponseParser getAutoSearchResult:resDict];
        
        AppointmentsResModel *appointmentsModel=[ResponseParser appointmentsModel:appointmentsDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        handler(appointmentsModel,error);
        
    }];
    
    [postDataTask resume];
   
}

- (void)getTimeSlotDetails:(TimeSlotReqModel* )type callBackHandler:(void(^)(NSDictionary*appointments, NSError *error))handler

{

    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@&centerStylistId=%@&dateTime=%@&serviceId=%@&stylistId=%@",BASEURL,GET_SLIDERDETAILS,type.centerId,type.centerStylistId,type.dateTime,type.serviceId,type.stylistId];
    
    NSURLSessionDataTask* postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData* data, NSURLResponse* response, NSError *error) {
        
        NSDictionary  *appointmentsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        handler(appointmentsDict,error);
        
    }];
    
    [postDataTask resume];
    
}

- (NSString *)hmac:(NSString *)timestamp withKey:(NSString *)key
{
    NSString *plaintext=[NSString stringWithFormat:@"%@%@",timestamp,key];
    const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *hash = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSLog(@"%@", hash);
    
    NSString* s = [self base64forData:hash];
   NSString* signsture=[self urlencode:s];
    return signsture;
    
}

- (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {  value |= (0xFF & input[j]);  }  }  NSInteger theIndex = (i / 3) * 4;  output[theIndex + 0] = table[(value >> 18) & 0x3F];
        output[theIndex + 1] = table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
- (NSString *)urlencode:(NSString*)unEncodedOne {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[unEncodedOne UTF8String];
    NSInteger sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
-(BOOL)rechabilityCheck{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        return NO;
    } else {
        NSLog(@"There IS internet connection");
        return YES;
    }
    
}
- (void)getBookingId:(AppointmentReqModel *)appointmentReqModel callBackRes:(void(^)(NSData *data, NSError *error))handler {
    
    NSError *error;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appointmentReqModel.centerId,@"centerId",appointmentReqModel.bookedServices,@"bookedServices",appointmentReqModel.bookingDate ,@"bookingDate",appointmentReqModel.centerStylistId,@"centerStylistId",appointmentReqModel.offerId,@"offerId",appointmentReqModel.offset,@"offset",appointmentReqModel.packageId,@"packageId",appointmentReqModel.startTimeIndex,@"startTimeIndex",appointmentReqModel.stylistId,@"stylistId",appointmentReqModel.totalAmount,@"totalAmount",appointmentReqModel.travelTime,@"travelTime",appointmentReqModel.walkIn,@"walkIn",nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:APPOINTEMENT withDta:data type:@"POST"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
                NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //        NSArray *stylistArr = [ResponseParser getStylistsList:resDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(data,error);
    }];
    [postDataTask resume];
}
- (void)getBookingDetails:(NSString *)BookingId callBackHandler:(void(^)(BookingResponseModel *model , NSError *error))handler;
{
   
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@?bookingId=%@",BOOKINGDETAILS,BookingId];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (httpResponse.statusCode == 200) {
            NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
           BookingResponseModel* model = [ResponseParser getBookingResponseModel:res];
            handler(model,error);
        }else  {
            NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":resDict[@"message"] }];
            NSLog(@"%@",[error localizedDescription]);
            handler(nil,manualerror);
        }
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
    [postDataTask resume];
}

- (void)CancleBookingId:(NSString *)bookingId callBackRes:(void(^)(NSData *data, NSError *error))handler {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:bookingId,@"bookingId", nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:CancleAPPOINTEMENT withDta:postData type:@"PUT"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *resDict;
            
            NSError *error;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
           
                resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (httpResponse.statusCode == 200) {
               
                    handler(data,error);
                }else  if (httpResponse.statusCode == 400) {
                    //                    NSDictionary *dict = resDict[@"errors"];
                    //                    NSDictionary * dictTemp = dict[@"field_errors"];
                    NSString *msg = [resDict objectForKey:@"message"];
                    NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":msg }];
                    handler(data,manualerror);
                }
            
        });
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [postDataTask resume];
   }
- (void)getAddressList:(void(^)(NSArray *addressList, NSError *error))handler{
  
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,GET_ADDRESS_LIST];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse* response, NSError* error) {
        
        NSDictionary  *addressListDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *addressList=[ResponseParser getAddressListModel:addressListDict];
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        handler(addressList,error);
    }];
    [postDataTask resume];
    
    
}

- (void)getMultiOffers:(NSString *)bookingId withOfferId:(NSNumber*)offerId callBackRes:(void(^)(NSArray *data, NSError *error))handler {

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:bookingId,@"bookingId",offerId ,@"offerId",nil];
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:GET_MultiOffers withDta:postData type:@"PUT"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *resDict;
            
            NSError *error;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            
            resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (httpResponse.statusCode == 200) {
                 NSArray *categoryList = [ResponseParser getMultiOffersListResponseModel:resDict[@"multiOffers"]];
                handler(categoryList,error);
            }else  if (httpResponse.statusCode == 400) {
                //                    NSDictionary *dict = resDict[@"errors"];
                //                    NSDictionary * dictTemp = dict[@"field_errors"];
                NSString *msg = [resDict objectForKey:@"message"];
                NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":msg }];
                handler(nil,manualerror);
            }
            
        });
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [postDataTask resume];
}


+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)UpdaterAddress:(AddressListModel *)addressListModel callBackRes:(void(^)(NSData *data, NSError *error))handler {

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:addressListModel.addressId,@"addressId",
                          addressListModel.pincode,@"pincode",
                          addressListModel.addressOne,@"addressOne",
                          addressListModel.addressTwo,@"addressTwo",
                          addressListModel.city,@"city",
                          addressListModel.tagName,@"tagName",
                          addressListModel.state,@"state",
                          addressListModel.latitude,@"latitude",
                          addressListModel.longitude,@"longitude", nil];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:UpdateAddress withDta:postData type:@"PUT"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *resDict;
            
            NSError *error;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            
            resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (httpResponse.statusCode == 200) {
                
                handler(data,error);
            }else  if (httpResponse.statusCode == 400) {
                //                    NSDictionary *dict = resDict[@"errors"];
                //                    NSDictionary * dictTemp = dict[@"field_errors"];
                NSString *msg = [resDict objectForKey:@"message"];
                NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":msg }];
                handler(data,manualerror);
            }
            
        });
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [postDataTask resume];
}

 - (void)addAddress:(AddressListModel *)addressListModel callBackRes:(void(^)(NSData *data, NSError *error))handler {
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          addressListModel.pincode,@"pincode",
                          addressListModel.addressOne,@"addressOne",
                          addressListModel.addressTwo,@"addressTwo",
                          addressListModel.city,@"city",
                          addressListModel.tagName,@"tagName",
                          addressListModel.state,@"state",
                          addressListModel.latitude,@"latitude",
                          addressListModel.longitude,@"longitude", nil];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:AddAddress withDta:postData type:@"POST"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
      //  NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        handler(data,error);

//        if (httpResponse.statusCode == 200) {
//           // model = [ResponseParser getLoginResponseModel:resDict];
//            handler(data,error);
//        }else  {
//            NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":resDict[@"message"] }];
//            NSLog(@"%@",[error localizedDescription]);
//            handler(data,manualerror);
//        }
//        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
    [postDataTask resume];
}
- (void)goToPaymentWithParameters:(NSDictionary *)goToPaymentDict callBackHandler:(void(^)( NSDictionary *response, NSError *error))handler {
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:goToPaymentDict options:NSJSONWritingPrettyPrinted error:&error];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:GoToPayment withDta:postData type:@"PUT"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *resDict;
            SignUpResModel *model;
            NSError *error;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            if (data != nil) {
                resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (httpResponse.statusCode == 200) {
                    
                    handler(resDict,error);
                }else  if (httpResponse.statusCode == 400) {
                    //                    NSDictionary *dict = resDict[@"errors"];
                    //                    NSDictionary * dictTemp = dict[@"field_errors"];
                    NSString *msg = [resDict objectForKey:@"message"];
                    NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":msg }];
                    handler(nil,manualerror);
                }
            }else{
                NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":@"Request timed out" }];
                NSLog(@"%@",[error localizedDescription]);
                handler(resDict,manualerror);
                
            }
        });
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [postDataTask resume];
}
- (void)getBookingInfo:(NSDictionary *)BookingInfo callBackHandler:(void(^)( NSDictionary *response, NSError *error))handler {
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:BookingInfo options:NSJSONWritingPrettyPrinted error:&error];
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self postRequestWithUrl:GetBookingInfo withDta:postData type:@"POST"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *resDict;
            SignUpResModel *model;
            NSError *error;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            if (data != nil) {
                resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (httpResponse.statusCode == 200) {
                    
                    handler(resDict,error);
                }else  if (httpResponse.statusCode == 400) {
                    //                    NSDictionary *dict = resDict[@"errors"];
                    //                    NSDictionary * dictTemp = dict[@"field_errors"];
                    NSString *msg = [resDict objectForKey:@"message"];
                    NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":msg }];
                    handler(nil,manualerror);
                }
            }else{
                NSError *manualerror = [[NSError alloc] initWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"ErrorReason":@"Request timed out" }];
                NSLog(@"%@",[error localizedDescription]);
                handler(resDict,manualerror);
                
            }
        });
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [postDataTask resume];
}

-(NSString *)getBillGenerateUrlVerifier:(NSString*)TxId{

    SignInDetailHandler *handler1 = [SignInDetailHandler sharedInstance];
    LoginResponseModel *resModel = handler1.loginResModel;
    NSString *TxIdAndAuthToken=[NSString stringWithFormat:@"%@%@",TxId,resModel.authToken];
    NSString *billUrlVerifier=[self hmac:TxIdAndAuthToken withKey:PAYMENTKEY];
    return billUrlVerifier;
}
- (void)getLatestVersionOfAPPcallBackRes:(void(^)(NSString *latestVersion, NSError *error))handler{
    
    NSError *error;
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *timeStampStr = [NSString stringWithFormat:@"%.0f",timeStamp];
    // timeStampStr = @"1451388009";
    //    NSString * newCountryString = [self hma]; //[s stringByAddingPercentEncodingForRFC3986:4];
    
    NSString * newCountryString =[self hmac:timeStampStr withKey:APIKEY];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",VersionCheckApi,AppId];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
   
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
           
            NSString*  version;
            NSArray *configData = [resDict valueForKey:@"results"];
            for (id config in configData)
            {
                version = [config valueForKey:@"version"];
                
            }
            
            handler(version,error);
        }else{
            handler(nil,error);
        }
    }];
    [postDataTask resume];
}
- (void)getAccentials:(void(^)(EssentialsModel *latestVersion, NSError *error))handler{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlStr = [NSString stringWithFormat:GetEssentials];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
           EssentialsModel *model= [ResponseParser getEssentialsModelModel:[resDict valueForKey:@"essentials"]];
            
            handler(model,error);
        }else{
            handler(nil,error);
        }
    }];
    [postDataTask resume];
}
- (void)claimPackageWithID:(NSNumber*)packageID callBackRes:(void(^)(BookingResponseModel *latestVersion, NSError *error))handler{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *urlStr = [NSString stringWithFormat:claimPackage,packageID];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:[self getRequestWithUrl:urlStr] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            BookingResponseModel* model = [ResponseParser getPackageBookingResponseModel:resDict];
            
            handler(model,error);
        }else{
            handler(nil,error);
        }
    }];
    [postDataTask resume];
}
+(void)loadImageinImgView:(UIImageView*)ImgView withUrlString:(NSString*)urlStr{
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ImgView.image = image;
                });
            }
        }
    }] ;
    [task resume];

}
@end
