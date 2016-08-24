//
//  ResponseParser.m
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "ResponseParser.h"
#import "ServiceResModel.h"
#import "OperationHoursResModel.h"
#import "FolderResModel.h"
#import "FolderCategoryModel.h"
#import "AllFoldersResModel.h"
#import "AllStylistsResModel.h"
#import "AutoSearchModel.h"
#import "ServicesFolderModel.h"
#import "AppointmentsHistoryModel.h"
#import "BookingResponseModel.h"
#import "AddressListModel.h"
#import "SearchAndFilterModel.h"
#import "BookingOfferModel.h"

@implementation ResponseParser


+ (LoginResponseModel *)getLoginResponseModel:(NSDictionary *)dict {
    LoginResponseModel *loginModel = [[LoginResponseModel alloc]init];
    loginModel.authToken = dict[@"token"];
    loginModel.phone = dict[@"phone"];
    loginModel.userType = dict[@"userType"];

    NSDictionary *userDict = dict[@"user"];
    
    LoginUserResModel *userModel = [[LoginUserResModel alloc]init];
    userModel.firstName = userDict[@"firstName"];
    userModel.lastName = userDict[@"lastName"];
    userModel.email = userDict[@"email"];
    userModel.phone = userDict[@"phone"];
    userModel.gender = userDict[@"gender"];
    userModel.photoUrl = userDict[@"photo"];
    
    loginModel.userDetails = userModel;
    
    return loginModel;
}

+ (SignUpResModel *)getRegisterResponseModel:(NSDictionary *)dict {
    SignUpResModel *resModel = [[SignUpResModel alloc]init];
//    NSArray *arr = dict[@"data"];
//    NSDictionary *resDict = arr[0];
    resModel.phone = dict[@"phone"];
    resModel.userType = dict [@"userType"];
    
    return resModel;
}
+ (SignUpDetailsResModel *)getSignUpDetailResponseModel:(NSDictionary *)dict
{
    SignUpDetailsResModel *resModel = [[SignUpDetailsResModel alloc]init];
    
    resModel.token = dict[@"token"];
    NSDictionary *tempDict = dict[@"user"];
    //    NSArray *arr = dict[@"data"];
    //    NSDictionary *resDict = arr[0];
    resModel.firstName = tempDict[@"firstName"];
    resModel.lastName = tempDict[@"lastName"];
    resModel.email = tempDict[@"email"];
    resModel.phone = tempDict[@"phone"];
    resModel.gender = tempDict[@"gender"];
    resModel.photo = tempDict[@"photo"];
    
    return resModel;
}


+ (BookingResponseModel *)getBookingResponseModel:(NSDictionary *)tempDict
{
    BookingResponseModel *resModel = [[BookingResponseModel alloc]init];
    
    if (tempDict[@"address"]) {
         resModel.address = @[tempDict[@"address"]];
    }
   
    //    NSArray *arr = dict[@"data"];
    //    NSDictionary *resDict = arr[0];
    resModel.bookedServices = tempDict[@"bookedServices"];
    resModel.bookingDate1 = tempDict[@"bookingDate"];
    resModel.bookingId = tempDict[@"bookingId"];
    resModel.displayName = tempDict[@"displayName"];
    resModel.email = tempDict[@"email"];
    resModel.isHomeService = tempDict[@"isHomeService"];
    resModel.latitude = tempDict[@"latitude"];
    resModel.longitude = tempDict[@"longitude"];
    resModel.name = tempDict[@"name"];
    resModel.offerId = tempDict[@"offerId"];
    resModel.offset = tempDict[@"offset"];
    resModel.oldAmountPaid = tempDict[@"oldAmountPaid"];
    resModel.phone = tempDict[@"phone"];
    resModel.planType = tempDict[@"planType"];
    resModel.rescheduleCount = tempDict[@"rescheduleCount"];
    resModel.serviceTax = tempDict[@"serviceTax"];
    resModel.startTimeIndex = tempDict[@"startTimeIndex"];
    resModel.totalAmount = tempDict[@"totalAmount"];
    resModel.travelTime = tempDict[@"travelTime"];
    return resModel;
}
+ (BookingResponseModel *)getPackageBookingResponseModel:(NSDictionary *)tempDict
{
    BookingResponseModel *resModel = [[BookingResponseModel alloc]init];
    
    //    NSArray *arr = dict[@"data"];
    //    NSDictionary *resDict = arr[0];
    resModel.bookedServices = tempDict[@"packageServices"];
    resModel.displayName = tempDict[@"displayName"];
    resModel.email = tempDict[@"email"];
    resModel.name = tempDict[@"name"];
    resModel.phone = tempDict[@"phone"];
    resModel.packageId = tempDict[@"packageId"];
    resModel.discountedPrice = [NSNumber numberWithInteger:[tempDict[@"price"] integerValue]-[tempDict[@"totalAmount"] integerValue]];
    resModel.serviceTax = tempDict[@"internetUsageCharges"];
    resModel.startTimeIndex = tempDict[@"startTimeIndex"];
    resModel.totalAmount = tempDict[@"totalAmount"];
    resModel.title= tempDict[@"title"];
    return resModel;
}



+ (NSArray *)getHomeCategoryResponseModel:(NSDictionary *)dict;
{
    NSMutableArray *modelListArr = [NSMutableArray array];
    for (NSDictionary *catDict in dict[@"categories"]) {
        HomeCatagoryResModel  *model = [[HomeCatagoryResModel alloc]init];
        model.categoryId = catDict[@"categoryId"];
        model.name = catDict[@"name"];
        model.image = catDict[@"image"];
        [modelListArr addObject:model];
    }
    
    return [modelListArr copy];
}

+ (NSArray *)getCenterListResponseModel:(NSDictionary *)dict withFilterParametersModel:(SearchAndFilterModel*)modelFilter
{
    NSMutableArray *modelListArr = [NSMutableArray array];
    for (NSDictionary *catDict in dict[@"centers"]) {
        CenterListResModel  *model = [[CenterListResModel alloc]init];
        model.centerId = catDict[@"centerId"];
        model.isFavorite = catDict[@"isFavorite"];
        model.displayName = catDict[@"displayName"];
        model.serveFor = catDict[@"serveFor"];
        model.rating = catDict[@"rating"];
        model.price = catDict[@"price"];
        model.address = catDict[@"address"];
        model.latitude = catDict[@"latitude"];
        model.longitude = catDict[@"longitude"];
        model.isOffer = catDict[@"isOffer"];
        model.isHomeService = catDict[@"isHomeService"];
        model.isPackage = catDict[@"isPackage"];
        model.logo = catDict[@"logo"];
        model.displayImage = catDict[@"displayImage"];
        model.travelTime = catDict[@"travelTime"];
        model.advanceBookingPeriod = catDict[@"advanceBookingPeriod"];
        model.primaryCategory = catDict[@"primaryCategory"];
        model.maxPrice = catDict[@"maxPrice"];
        model.location = catDict[@"location"];
        
        
    if ([modelFilter.maxPrice integerValue]>0) {
        NSRange a = NSMakeRange([modelFilter.minPrice integerValue], [modelFilter.maxPrice integerValue]-[modelFilter.minPrice integerValue]);
        NSRange b = NSMakeRange([model.price integerValue], [model.maxPrice integerValue]-[model.price integerValue]+1);
        NSRange intersection = NSIntersectionRange(a, b);
        if (intersection.length <= 0){
            NSLog(@"Ranges do not intersect");
        }
        else{
            NSLog(@"Intersection = %@", NSStringFromRange(intersection));
            [modelListArr addObject:model];
        }
    }else{
        [modelListArr addObject:model];
    }
        
    }
    
    
    if (modelFilter) {
        
        if (modelFilter.serveFor) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serveFor == %@",modelFilter.serveFor ];
            NSArray * arr = [modelListArr filteredArrayUsingPredicate:predicate];
            NSMutableArray *mutArray=[[NSMutableArray alloc]initWithArray:arr];
            modelListArr=mutArray;
             //return [arr copy];
        }
        if (modelFilter.preference) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rating > 0"];
            NSArray * arr = [modelListArr filteredArrayUsingPredicate:predicate];
            NSMutableArray *mutArray=[[NSMutableArray alloc]initWithArray:arr];
            modelListArr=mutArray;
            //return [arr copy];
        }
    }
    
    
    return [modelListArr copy];
}

+ (CenterDetailResModel *)getOneCenterDetailResponseModel:(NSDictionary *)dict
{
    NSDictionary *catDict = dict[@"center"];
       CenterDetailResModel  *model = [[CenterDetailResModel alloc]init];
        model.centerId = catDict[@"centerId"];
        model.primaryCategoryId = catDict[@"primaryCategoryId"];
        model.isFavorite = catDict[@"isFavorite"];
        model.name = catDict[@"name"];
        model.displayName = catDict[@"displayName"];
        model.serveFor = catDict[@"serveFor"];
        model.price = catDict[@"price"];
        model.address = catDict[@"address"];
        model.location = catDict[@"location"];
        model.latitude = catDict[@"latitude"];
        model.longitude = catDict[@"longitude"];
        model.catDescription = catDict[@"description"];
        model.travelTime = catDict[@"travelTime"];
        model.advanceBookingPeriod = catDict[@"advanceBookingPeriod"];
        model.isHomeService = catDict[@"isHomeService"];
        model.amenities = catDict[@"amenities"];
        model.logo = catDict[@"logo"];
        model.displayImage = catDict[@"displayImage"];
        model.walkIn = catDict[@"walkIn"];
        model.loyatlyscore = catDict[@"loyatlyscore"];
        model.demandscore = catDict[@"demandscore"];
        model.rating = catDict[@"rating"];
        model.isPackage = catDict[@"isPackage"];
        model.isOffer = catDict[@"isOffer"];
        model.centerCoverImages=catDict[@"centerCoverImages"];
    
   
       NSMutableArray *servicesArr = [[NSMutableArray alloc]init];
        for (NSDictionary *serviceDict in catDict[@"services"]) {
            ServiceResModel *serviceModel = [[ServiceResModel alloc]init];
            serviceModel.serviceId = serviceDict[@"serviceId"];
            serviceModel.name = serviceDict[@"name"];
            serviceModel.price = serviceDict[@"price"];
            serviceModel.time = serviceDict[@"time"];
            
            [servicesArr addObject:serviceModel];
        }
       model.services = [servicesArr copy];
    
    
    NSMutableArray *operationHourArr = [[NSMutableArray alloc]init];
    for (NSDictionary *operationHoursDict in catDict[@"operationHours"]) {
        OperationHoursResModel *openHoursModel = [[OperationHoursResModel alloc]init];
        openHoursModel.opDay = operationHoursDict[@"opDay"];
        openHoursModel.startTimeIndex = operationHoursDict[@"startTimeIndex"];
        openHoursModel.offset = operationHoursDict[@"offset"];
        
        [operationHourArr addObject:openHoursModel];
    }
    model.operationHours = [operationHourArr copy];
    
    
    return model;
}

+ (NSArray *)getOffersListResponseModel:(NSArray* )offers
{
    NSMutableArray *modelListArr = [NSMutableArray array];
    for (NSDictionary *catDict in offers) {
        OffersListResModel  *model = [[OffersListResModel alloc]init];
        
        model.title = catDict[@"title"];
        model.image = catDict[@"image"];
        model.centerName = catDict[@"centerName"];
        model.centerLatitude = catDict[@"centerLatitude"];
        model.centerLongitude = catDict[@"centerLongitude"];
        model.offerCategory = catDict[@"offerCategory"];
        model.offerCategoryValue = catDict[@"offerCategoryValue"];
        model.offerType = catDict[@"offerType"];
        model.offerTypeValue = catDict[@"offerTypeValue"];
        model.offerEnd = catDict[@"offerEnd"];
        model.offerEndValue = catDict[@"offerEndValue"];
        model.freeDetails = catDict[@"freeDetails"];
        model.descriptionOffer = catDict[@"description"];
        model.createdAt = catDict[@"createdAt"];
        model.discountedPrice = catDict[@"discountedPrice"];
        model.endType = catDict[@"endType"];
        model.endValue = catDict[@"endValue"];
        NSString *packageId=[NSString stringWithFormat:@"%@",catDict[@"packageId"]];
        NSString *offerId =[NSString stringWithFormat:@"%@",catDict[@"offerId"]];
        model.offerId=[NSNumber numberWithInteger:[offerId integerValue]];
        model.packageId = [NSNumber numberWithInteger:[packageId integerValue]];
        model.title = catDict[@"title"];
        model.price = catDict[@"price"];
        
        [modelListArr addObject:model];
    }
    
    return [modelListArr copy];
}

+ (NSArray *)getMultiOffersListResponseModel:(NSArray* )multiOffers
{
    NSMutableArray *modelListArr = [NSMutableArray array];
    for (NSDictionary *catDict in multiOffers) {
        BookingOfferModel  *model = [[BookingOfferModel alloc]init];
        
        model.descriptionOffer = catDict[@"description"];
        model.image = catDict[@"image"];
        model.offerCategory = catDict[@"offerCategory"];
        model.offerCategoryValue = catDict[@"offerCategoryValue"];
        model.offerEnd = catDict[@"offerEnd"];
        model.offerEndValue = catDict[@"offerEndValue"];
        model.offerFlag = catDict[@"offerFlag"];
        model.offerId = catDict[@"offerId"];
        model.offerServices = catDict[@"offerServices"];
        model.offerValue = catDict[@"offerValue"];
        model.startDate = catDict[@"startDate"];
        model.title = catDict[@"title"];
        [modelListArr addObject:model];
    }

        return modelListArr;
}
+ (OfferFullDetailModel *)getOffersDetailModel:(NSDictionary *)catDict withType:(NSString *)type
{
     OfferFullDetailModel *fullDetailsModel=[[OfferFullDetailModel alloc]init];
    if ([type isEqualToString:@"offer"]) {
       
    fullDetailsModel.offerId = catDict[@"offerId"] ;
    fullDetailsModel.centerAddressOne= catDict[@"centerAddressOne"];
    fullDetailsModel.centerAddressTwo= catDict[@"centerAddressTwo"];
    fullDetailsModel.centerCoverImagesArray= catDict[@"centerCoverImages"];
    fullDetailsModel.centerId= catDict[@"centerId"];
    fullDetailsModel.centerLatitude= catDict[@"centerLatitude"];
    fullDetailsModel.centerLongitude= catDict[@"centerLongitude"];
    fullDetailsModel.centerLogo= catDict[@"centerLogo"];
    fullDetailsModel.centerName= catDict[@"centerName"];
    fullDetailsModel.createdAt= catDict[@"createdAt"];
    fullDetailsModel.createdDateTime= catDict[@"createdDateTime"];
    fullDetailsModel.descriptio= catDict[@"description"];
    fullDetailsModel.freeDetails= catDict[@"freeDetails"];
    fullDetailsModel.image= catDict[@"image"];
    fullDetailsModel.offerCategory= catDict[@"offerCategory"];
    fullDetailsModel.offerCategoryValue= catDict[@"offerCategoryValue"];
    fullDetailsModel.offerEnd= catDict[@"offerEnd"];
    fullDetailsModel.offerEndValue= catDict[@"offerEndValue"];
    fullDetailsModel.offerHappyHours= catDict[@"offerHappyHours"];
    fullDetailsModel.offerTypeValue= catDict[@"offerTypeValue"];
    fullDetailsModel.servicesOfferArray= catDict[@"servicesOffer"];
    fullDetailsModel.startDate= catDict[@"startDate"];
    fullDetailsModel.title= catDict[@"title"];
    fullDetailsModel.stylistOfferArray= catDict[@"stylistOffer"];
    
    }else{
        fullDetailsModel.packageId = catDict[@"packageId"] ;
        fullDetailsModel.centerAddressOne= catDict[@"centerAddressOne"];
        fullDetailsModel.centerAddressTwo= catDict[@"centerAddressTwo"];
        fullDetailsModel.centerCoverImagesArray= catDict[@"centerCoverImages"];
        fullDetailsModel.centerId= catDict[@"centerId"];
        fullDetailsModel.centerLatitude= catDict[@"centerLatitude"];
        fullDetailsModel.centerLongitude= catDict[@"centerLongitude"];
        fullDetailsModel.centerLogo= catDict[@"centerLogo"];
        fullDetailsModel.centerName= catDict[@"centerName"];
        fullDetailsModel.createdAt= catDict[@"createdAt"];
        fullDetailsModel.createdDateTime= catDict[@"createdDateTime"];
        fullDetailsModel.descriptio= catDict[@"description"];
        fullDetailsModel.freeDetails= catDict[@"freeDetails"];
        fullDetailsModel.image= catDict[@"image"];
        fullDetailsModel.startDate= catDict[@"startDate"];
        fullDetailsModel.discountedPrice=catDict[@"discountedPrice"];
        fullDetailsModel.price=catDict[@"price"];
        fullDetailsModel.packageEndType=catDict[@"packageEndType"];
        fullDetailsModel.packageEndValue=catDict[@"packageEndValue"];
        fullDetailsModel.servicesOfferArray= catDict[@"servicesPackage"];
        fullDetailsModel.title= catDict[@"title"];
        fullDetailsModel.stylistOfferArray= catDict[@"stylistPackage"];
        
    }

    
    
    
    return fullDetailsModel ;
}
+ (NSArray *)getServiceResponseModel:(NSDictionary *)dict;
{
    NSMutableArray *modelArr = [[NSMutableArray alloc]init];
    NSArray *serviceArr = dict[@"services"];
    for (NSDictionary *tempDict in serviceArr) {
        ServiceResModel *model = [[ServiceResModel alloc]init];
        model.serviceId = tempDict[@"serviceId"];
        model.name = tempDict[@"name"];
        model.price = tempDict[@"price"];
        model.time = tempDict[@"time"];
        [modelArr addObject:model];
    }
    
    return [modelArr copy];
}

+ (NSArray *)getStylistsList:(NSDictionary *)dict {
    NSMutableArray *modelArr = [[NSMutableArray alloc]init];
    NSArray *arr = dict[@"stylists"];
    for (NSDictionary *tempDict in arr) {
        StylistResModel *model = [[StylistResModel alloc]init];
        model.stylistId = tempDict[@"stylistId"];
        model.phone = tempDict[@"phone"];
        model.centerStylistId = tempDict[@"centerStylistId"];
        model.isFavorite = tempDict[@"isFavorite"];
        model.name = tempDict[@"name"];
        model.designation = tempDict[@"designation"];
        model.workFrom = tempDict[@"workFrom"];
        model.empCode = tempDict[@"empCode"];
        model.walkIn = tempDict[@"walkIn"];
        model.loyaltyScore = tempDict[@"loyaltyScore"];
        model.demandScore = tempDict[@"demandScore"];
        model.rating = tempDict[@"rating"];
        model.favoriteScore = tempDict[@"favoriteScore"];
        model.selfieScore = tempDict[@"selfieScore"];
        
        NSArray *stylistServicesArr = tempDict[@"stylistServices"];
        NSMutableArray *serviceArr = [[NSMutableArray alloc]init];
        for (NSDictionary *serviceDict in stylistServicesArr) {
            StylistServiceResModel *serviceModel = [[StylistServiceResModel alloc]init];
            serviceModel.serviceId = serviceDict[@"serviceId"];
            serviceModel.name = serviceDict[@"name"];
            serviceModel.time = serviceDict[@"time"];
            serviceModel.price = serviceDict[@"price"];
            serviceModel.isHomeService = serviceDict[@"isHomeService"];
            [serviceArr addObject:serviceModel];
        }
        model.stylistServices = [serviceArr copy];
        
        
        NSArray *stylistOpenHourArr = tempDict[@"stylistOperationHours"];
        NSMutableArray *operationHoursArr = [[NSMutableArray alloc]init];
        for (NSDictionary *openHourDict in stylistOpenHourArr) {
            StylistOperationHourResModel *serviceModel = [[StylistOperationHourResModel alloc]init];
            serviceModel.opDay = openHourDict[@"opDay"];
            serviceModel.startTimeIndex = openHourDict[@"startTimeIndex"];
            serviceModel.offset = openHourDict[@"offset"];
            serviceModel.status = openHourDict[@"status"];
            [operationHoursArr addObject:serviceModel];
        }
        model.stylistOperationHours = [operationHoursArr copy];
        
        [modelArr addObject:model];
    }
    return modelArr;
}

+ (NSArray *)getReviewList:(NSDictionary *)dict {
    NSMutableArray *reviewsArr = [[NSMutableArray alloc]init];
    
    NSArray *reviewArr = dict[@"reviews"];
    
    for (NSDictionary *reviewDict in reviewArr) {
        ReviewResModel *model = [[ReviewResModel alloc]init];
        model.name = reviewDict[@"name"];
        model.photo = reviewDict[@"photo"];
        model.rating = reviewDict[@"rating"];
        model.services = reviewDict[@"services"];
        model.date = reviewDict[@"date"];
        model.review = reviewDict[@"review"];

        [reviewsArr addObject:model];
    }
    return reviewsArr;
}

+ (AllFoldersResModel *)getFoldersList:(NSDictionary *)dict {
    
    AllFoldersResModel *allFoldersModel = [[AllFoldersResModel alloc]init];
    
    NSMutableArray *foldersArr = [[NSMutableArray alloc]init];

    NSArray *folderArr = dict[@"folders"];
    
    for (NSDictionary *folderDict in folderArr) {
        FolderResModel *model = [[FolderResModel alloc]init];
        model.folderId = folderDict[@"folderId"];
        model.folderName = folderDict[@"folderName"];
        
        NSDictionary *categoryDict = folderDict[@"category"];
        FolderCategoryModel *categoryModel = [[FolderCategoryModel alloc]init];
        categoryModel.categoryId = categoryDict[@"categoryId"];
        categoryModel.name = categoryDict[@"name"];
        
        NSArray *serviceArr = folderDict[@"services"];
        NSMutableArray *serviceModelArr = [NSMutableArray array];
        for (NSDictionary *serviceDict in serviceArr) {
            ServiceResModel *serviceModel = [[ServiceResModel alloc]init];
            
            serviceModel.serviceId = serviceDict[@"serviceId"];
            serviceModel.isOffer = serviceDict[@"isOffer"];
            serviceModel.isPackage = serviceDict[@"isPackage"];
            serviceModel.name = serviceDict[@"name"];
            serviceModel.price = serviceDict[@"price"];
            serviceModel.time = serviceDict[@"time"];
            serviceModel.image = serviceDict[@"image"];
            serviceModel.serDescription = serviceDict[@"description"];
            serviceModel.daysOfOp = serviceDict[@"daysOfOp"];
            serviceModel.isHomeService = serviceDict[@"isHomeService"];
            
            [serviceModelArr addObject:serviceModel];
        }

        model.servicesArr = [serviceModelArr copy];
        
        [foldersArr addObject:model];
    }
    
    allFoldersModel.foldersModelArr = [foldersArr copy];
    
    NSArray *notMappedServicesArr = dict[@"notMappedServices"];
    
    NSMutableArray *notMappedServiceModelArr = [NSMutableArray array];
    for (NSDictionary *serviceDict in notMappedServicesArr) {
        ServiceResModel *serviceModel = [[ServiceResModel alloc]init];
        
        serviceModel.serviceId = serviceDict[@"serviceId"];
        serviceModel.isOffer = serviceDict[@"isOffer"];
        serviceModel.isPackage = serviceDict[@"isPackage"];
        serviceModel.name = serviceDict[@"name"];
        serviceModel.price = serviceDict[@"price"];
        serviceModel.time = serviceDict[@"time"];
        serviceModel.image = serviceDict[@"image"];
        serviceModel.serDescription = serviceDict[@"description"];
        serviceModel.daysOfOp = serviceDict[@"daysOfOp"];
        serviceModel.isHomeService = serviceDict[@"isHomeService"];
        
        [notMappedServiceModelArr addObject:serviceModel];
    }
    
    allFoldersModel.notMappedServicesArr = [notMappedServiceModelArr copy];
    
    
    return allFoldersModel;
}

+ (AllStylistsResModel *)getallstylists:(NSDictionary *)dict
{
    AllStylistsResModel *allStylistResModel = [[AllStylistsResModel alloc]init];
    
    NSDictionary *outletHourDict = dict[@"outletHour"];
    
    allStylistResModel.displayName = outletHourDict[@"displayName"];
    allStylistResModel.opDay = outletHourDict[@"opDay"];
    allStylistResModel.travelTime = outletHourDict[@"travelTime"];
    allStylistResModel.advanceBookingPeriod = outletHourDict[@"advanceBookingPeriod"];
    allStylistResModel.startHour = outletHourDict[@"startHour"];
    allStylistResModel.offset = outletHourDict[@"offset"];
    
    NSMutableArray *modelArr = [[NSMutableArray alloc]init];
    NSArray *arr = dict[@"data"];
    for (NSDictionary *tempDict in arr) {
        StylistResModel *model = [[StylistResModel alloc]init];
        model.stylistId = tempDict[@"stylistId"];
        model.phone = tempDict[@"phone"];
        model.centerStylistId = tempDict[@"centerStylistId"];
        model.isFavorite = tempDict[@"isFavorite"];
        model.name = tempDict[@"name"];
        model.designation = tempDict[@"designation"];
        model.workFrom = tempDict[@"workFrom"];
        model.empCode = tempDict[@"empCode"];
        model.walkIn = tempDict[@"walkIn"];
        model.loyaltyScore = tempDict[@"loyaltyScore"];
        model.demandScore = tempDict[@"demandScore"];
        model.rating = tempDict[@"rating"];
        model.favoriteScore = tempDict[@"favoriteScore"];
        model.selfieScore = tempDict[@"selfieScore"];
        model.photo = tempDict[@"photo"];
        
        NSArray *stylistServicesArr = tempDict[@"stylistServices"];
        NSMutableArray *serviceArr = [[NSMutableArray alloc]init];
        NSMutableSet *folderIDsSet=[[NSMutableSet alloc]init];
        for (NSDictionary *serviceDict in stylistServicesArr) {
//            StylistServiceResModel *serviceModel = [[StylistServiceResModel alloc]init];
            [serviceArr addObject:serviceDict[@"serviceId"]];
            [folderIDsSet addObject:serviceDict[@"folderId"]];
//            serviceModel.name = serviceDict[@"name"];
//            serviceModel.time = serviceDict[@"time"];
//            serviceModel.price = serviceDict[@"price"];
//            serviceModel.isHomeService = serviceDict[@"isHomeService"];
//            [serviceArr addObject:serviceModel];
            
            
        }
        model.servicesIdArray = [serviceArr copy];
        model.folderIds=folderIDsSet;
        
        NSArray *stylistOpenHourArr = tempDict[@"stylistOperationHours"];
        NSMutableArray *operationHoursArr = [[NSMutableArray alloc]init];
        for (NSDictionary *openHourDict in stylistOpenHourArr) {
            StylistOperationHourResModel *serviceModel = [[StylistOperationHourResModel alloc]init];
            serviceModel.opDay = openHourDict[@"opDay"];
            serviceModel.startTimeIndex = openHourDict[@"startTimeIndex"];
            serviceModel.offset = openHourDict[@"offset"];
            serviceModel.status = openHourDict[@"status"];
            [operationHoursArr addObject:serviceModel];
        }
        model.stylistOperationHours = [operationHoursArr copy];
        [modelArr addObject:model];
    }
    
    allStylistResModel.stylistResArr = [modelArr copy];

    return allStylistResModel;
}
+ (NSArray *)getServicesWithoutFolders:(NSDictionary *)dict;
{
    NSMutableArray *serviceArr = [[NSMutableArray alloc]init];
    NSArray *servicesArray=[dict valueForKey:@"services"];
    int serviceIndex;
    for (serviceIndex=0; serviceIndex<(servicesArray.count); serviceIndex++) {
        NSDictionary *serviceDict=[servicesArray objectAtIndex:serviceIndex];
        
            ServiceResModel *serviceModel = [[ServiceResModel alloc]init];
                serviceModel.serviceId = serviceDict[@"serviceId"];
                serviceModel.isOffer = serviceDict[@"isOffer"];
                serviceModel.isPackage = serviceDict[@"isPackage"];
                serviceModel.name = serviceDict[@"name"];
                serviceModel.price = serviceDict[@"price"];
                serviceModel.time = serviceDict[@"time"];
                serviceModel.image = serviceDict[@"image"];
                serviceModel.serDescription = serviceDict[@"description"];
                serviceModel.daysOfOp = serviceDict[@"daysOfOp"];
                serviceModel.isHomeService = serviceDict[@"isHomeService"];
        serviceModel.folderId=[NSNumber numberWithInteger:0];
                serviceModel.isNotMappedServices=[NSNumber numberWithInt:0];
                [serviceArr addObject:serviceModel];
            }
    
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"name"
                                  ascending:YES
                                   selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortedServicesArray = [serviceArr sortedArrayUsingDescriptors:@[sortDescriptor]];
    return  sortedServicesArray;
    
    
}



+ (NSArray *)getServicesList:(NSDictionary *)dict;
{
    
    NSMutableArray *foldersModelsMutArray=[[NSMutableArray alloc]init];
   
    NSArray *foldersArray=[dict valueForKey:@"folders"];
    NSArray *notMappedServicesArray=[dict valueForKey:@"notMappedServices"];
    int folderIndex;
    for (folderIndex=0; folderIndex<(foldersArray.count+1); folderIndex++) {
        ServicesFolderModel *folderModel=[[ServicesFolderModel alloc]init];
        if (folderIndex==foldersArray.count) {
            folderModel.folderId=[NSNumber numberWithInt:0];
            folderModel.folderName=@"Other Services";
            NSMutableArray *serviceArr = [[NSMutableArray alloc]init];
            for (NSDictionary *serviceDict in notMappedServicesArray) {
                
                ServiceResModel *serviceModel = [[ServiceResModel alloc]init];
                serviceModel.folderId=[NSNumber numberWithInteger:0];
                serviceModel.serviceId = serviceDict[@"serviceId"];
                serviceModel.isOffer = serviceDict[@"isOffer"];
                serviceModel.isPackage = serviceDict[@"isPackage"];
                serviceModel.name = serviceDict[@"name"];
                serviceModel.price = serviceDict[@"price"];
                serviceModel.time = serviceDict[@"time"];
                serviceModel.image = serviceDict[@"image"];
                serviceModel.serDescription = serviceDict[@"description"];
                serviceModel.daysOfOp = serviceDict[@"daysOfOp"];
                serviceModel.isHomeService = serviceDict[@"isHomeService"];
                
                serviceModel.isNotMappedServices=[NSNumber numberWithInt:1];
                [serviceArr addObject:serviceModel];
            }
            NSSortDescriptor *sortDescriptor =
            [NSSortDescriptor sortDescriptorWithKey:@"name"
                                          ascending:YES
                                           selector:@selector(caseInsensitiveCompare:)];
            NSArray *sortedServicesArray = [serviceArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            folderModel.servicesArray=sortedServicesArray;

        }else{
            NSDictionary *folderDict=[foldersArray objectAtIndex:folderIndex];
            NSArray *servicesArray=[folderDict valueForKey:@"services"];
            folderModel.folderId=[folderDict valueForKey:@"folderId"];
            folderModel.folderName=[folderDict valueForKey:@"folderName"];
             NSMutableArray *serviceArr = [[NSMutableArray alloc]init];
            for (NSDictionary *serviceDict in servicesArray) {
                
                ServiceResModel *serviceModel = [[ServiceResModel alloc]init];
                serviceModel.folderId=folderModel.folderId;
                serviceModel.serviceId = serviceDict[@"serviceId"];
                serviceModel.isOffer = serviceDict[@"isOffer"];
                serviceModel.isPackage = serviceDict[@"isPackage"];
                serviceModel.name = serviceDict[@"name"];
                serviceModel.price = serviceDict[@"price"];
                serviceModel.time = serviceDict[@"time"];
                serviceModel.image = serviceDict[@"image"];
                serviceModel.serDescription = serviceDict[@"description"];
                serviceModel.daysOfOp = serviceDict[@"daysOfOp"];
                serviceModel.isHomeService = serviceDict[@"isHomeService"];
                serviceModel.isNotMappedServices=[NSNumber numberWithInt:0];
                [serviceArr addObject:serviceModel];
            }
            NSSortDescriptor *sortDescriptor =
            [NSSortDescriptor sortDescriptorWithKey:@"name"
                                          ascending:YES
                                           selector:@selector(caseInsensitiveCompare:)];
            NSArray *sortedServicesArray = [serviceArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            
           folderModel.servicesArray=sortedServicesArray;
        }
        [foldersModelsMutArray addObject:folderModel];
    }
    
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"folderName"
                                  ascending:YES
                                   selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortedArray = [foldersModelsMutArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return sortedArray;
   
}

+ (NSArray *)getAutoSearchResult:(NSDictionary *)dict
{
    NSMutableArray *searchArr = [[NSMutableArray alloc]init];
    NSArray *autosearchArr = dict[@"data"];
    for (NSDictionary *reviewDict in autosearchArr) {
        AutoSearchModel *model = [[AutoSearchModel alloc]init];
        model.centerID = reviewDict[@"id"];
        model.type = reviewDict[@"type"];
        model.search = reviewDict[@"search"];
        [searchArr addObject:model];
    }
    return searchArr;
}
+ (UserProfileModel *)getUserDetailModel:(NSDictionary *)userDetailDict
{
    
    UserProfileModel*userProfilrModel=[[UserProfileModel alloc]init];
    userProfilrModel.customerRegId=userDetailDict[@"customerRegId"];
    userProfilrModel.firstName=userDetailDict[@"firstName"];
    userProfilrModel.lastName=userDetailDict[@"lastName"];
    userProfilrModel.email=userDetailDict[@"email"];
    userProfilrModel.isNotification=userDetailDict[@"isNotification"];
    userProfilrModel.phone=userDetailDict[@"phone"];
    userProfilrModel.photo=userDetailDict[@"photo"];
    userProfilrModel.gender=userDetailDict[@"gender"];
    userProfilrModel.signupType=userDetailDict[@"signupType"];
    
    return userProfilrModel;
}
+ (ContactUsModel *)contactUsModel:(NSDictionary *)contactUsDict
{
    
    ContactUsModel*contactUsModel=[[ContactUsModel alloc]init];
    contactUsModel.tollFreeNumber=contactUsDict[@"tollFreeNumber"];
    contactUsModel.emailAddress=contactUsDict[@"emailAddress"];
    contactUsModel.phoneNumber=contactUsDict[@"phoneNumber"];
    contactUsModel.subjectsArray=contactUsDict[@"subjects"];
    
    return contactUsModel;
    
}
+ (GetcategoryResponceModel*)getCategoryResponseModel:(NSDictionary *)dict
{
    GetcategoryResponceModel *getModel = [[GetcategoryResponceModel alloc]init];
    
    return getModel;

}
+ (AppointmentsResModel *)appointmentsModel:(NSDictionary *)appointmentsDict
{
    AppointmentsResModel*appointmentsModel=[[AppointmentsResModel alloc]init];
    appointmentsModel.type=appointmentsDict[@"type"];
    NSArray *appointmentsArray=[appointmentsDict valueForKey:@"appointments"];
    NSMutableArray *AppointmentsMutArray=[[NSMutableArray alloc]init];
    for (NSDictionary *appointmentDict in appointmentsArray) {
        AppointmentsHistoryModel *appointment =[[AppointmentsHistoryModel alloc]init];
        appointment.amountPaid=[appointmentDict valueForKey:@"amountPaid"];
        appointment.bookedServices=[appointmentDict valueForKey:@"bookedServices"];
        appointment.bookingDate=[appointmentDict valueForKey:@"bookingDate"];
        appointment.bookingId=[appointmentDict valueForKey:@"bookingId"];
        appointment.bookingTime=[appointmentDict valueForKey:@"bookingTime"];
        appointment.centerAddress=[appointmentDict valueForKey:@"centerAddress"];
        appointment.centerId=[appointmentDict valueForKey:@"centerId"];
        appointment.centerLatitude=[appointmentDict valueForKey:@"centerLatitude"];
        appointment.centerLongitude=[appointmentDict valueForKey:@"centerLongitude"];
        appointment.centerName=[appointmentDict valueForKey:@"centerName"];
        appointment.centerPhone=[appointmentDict valueForKey:@"centerPhone"];
        appointment.centerStylistId=[appointmentDict valueForKey:@"centerStylistId"];
        appointment.displayName=[appointmentDict valueForKey:@"displayName"];
        appointment.isHomeService=[appointmentDict valueForKey:@"isHomeService"];
        appointment.isOffer=[appointmentDict valueForKey:@"isOffer"];
        appointment.isPackage=[appointmentDict valueForKey:@"isPackage"];
        appointment.oldAmountPaid=[appointmentDict valueForKey:@"oldAmountPaid"];
        appointment.rescheduleCount=[appointmentDict valueForKey:@"rescheduleCount"];
        appointment.status=[appointmentDict valueForKey:@"status"];
        appointment.stylistId=[appointmentDict valueForKey:@"stylistId"];
        appointment.travelTime=[appointmentDict valueForKey:@"travelTime"];

        [AppointmentsMutArray addObject:appointment];
    }
    appointmentsModel.AppointmentsArray=AppointmentsMutArray;
    return appointmentsModel;
}
+ (NSArray *)getAddressListModel:(NSDictionary *)addressListDict
{
    
    NSMutableArray *addressListMutArray=[[NSMutableArray alloc]init];
    
    //    addressListModel.type=appointmentsDict[@"type"];
    NSArray *addressListArray=[addressListDict valueForKey:@"address"];
    for (NSDictionary *addressListDict in addressListArray) {
        AddressListModel *addressListModel =[[AddressListModel alloc]init];
        addressListModel.addressId=[addressListDict valueForKey:@"addressId"];
        addressListModel.tagName=[addressListDict valueForKey:@"tagName"];
        addressListModel.addressOne=[addressListDict valueForKey:@"addressOne"];
        NSString *addressLine2=[addressListDict valueForKey:@"addressTwo"];
        if (addressLine2.length>0) {
            addressListModel.addressTwo=[addressListDict valueForKey:@"addressTwo"];
        }else{
            addressListModel.addressTwo=@"";
        }
        
        addressListModel.city=[addressListDict valueForKey:@"city"];
        addressListModel.state=[addressListDict valueForKey:@"state"];
        addressListModel.pincode=[NSString stringWithFormat:@"%@",[addressListDict valueForKey:@"pincode"]];
        addressListModel.latitude=[addressListDict valueForKey:@"latitude"];
        addressListModel.longitude=[addressListDict valueForKey:@"longitude"];
        
        [addressListMutArray addObject:addressListModel];
    }
    
    //    AddressListMutArray=addressListModel.addressListArray;
    return addressListMutArray.copy;
    
    
}
+ (EssentialsModel *)getEssentialsModelModel:(NSDictionary *)addressListDict
{
    
   
        EssentialsModel *essentialsModel =[[EssentialsModel alloc]init];
        essentialsModel.IHC=[addressListDict valueForKey:@"IHC"];
        essentialsModel.aboutus=[addressListDict valueForKey:@"aboutus"];
        essentialsModel.bookingBufferTime=[addressListDict valueForKey:@"bookingBufferTime"];
        essentialsModel.cancellationBufferTime=[addressListDict valueForKey:@"cancellationBufferTime"];
        essentialsModel.forceUpdate=[addressListDict valueForKey:@"forceUpdate"];
        essentialsModel.maxOfferRescheduleCount=[addressListDict valueForKey:@"maxOfferRescheduleCount"];
        essentialsModel.maxPackageRescheduleCount=[addressListDict valueForKey:@"maxPackageRescheduleCount"];
        essentialsModel.maxRescheduleCount=[addressListDict valueForKey:@"maxRescheduleCount"];
        
    essentialsModel.merchantAgreement=[addressListDict valueForKey:@"merchantAgreement"];
    essentialsModel.privacy=[addressListDict valueForKey:@"privacy"];
    essentialsModel.recommendUpdate=[addressListDict valueForKey:@"recommendUpdate"];
    essentialsModel.rescheduleAndCancelText=[addressListDict valueForKey:@"rescheduleAndCancelText"];
    essentialsModel.rescheduleBufferTime=[addressListDict valueForKey:@"rescheduleBufferTime"];
    essentialsModel.terms=[addressListDict valueForKey:@"terms"];
   
    
    //    AddressListMutArray=addressListModel.addressListArray;
    return essentialsModel;
    
    
}



@end
