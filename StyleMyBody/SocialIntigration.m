//
//  SocialIntigration.m
//  StyleMyBody
//
//  Created by sipani online on 06/08/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "SocialIntigration.h"


@implementation SocialIntigration


- (void)faceBookLoginWithParent:(UIViewController*)ParentView callBackHandler:(void(^)(SocialResponseModel *response, NSError *error))handler{
    SocialResponseModel *socialModel=[[SocialResponseModel alloc]init];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email",@"public_profile"] fromViewController:ParentView handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)  {
        
        if (error) {
            // Process error
            NSLog(@"error %@",error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else {
            // [self fetchUserInfo];
            
            if ([result.grantedPermissions containsObject:@"email"]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                   parameters:@{@"fields": @"first_name,last_name, picture, email,gender"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     
                     
                     if (!error) {
                        
                         if (![result objectForKey:@"email"]) {
                             
                            
                              handler(nil,error);
                             
//                             UIAlertController * view=   [UIAlertController
//                                                          alertControllerWithTitle:@"Style My Body"
//                                                          message:@"Please try with different credintials"
//                                                          preferredStyle:UIAlertControllerStyleAlert];
//                             
//                             UIAlertAction* ok = [UIAlertAction
//                                                  actionWithTitle:@"OK"
//                                                  style:UIAlertActionStyleDefault
//                                                  handler:^(UIAlertAction * action)
//                                                  {
//                                                      
//                                                  }];
//                             [view addAction:ok];
//                             [self presentViewController:view animated:YES completion:nil];
                             
                             
                             [FBSDKAccessToken setCurrentAccessToken:nil];
                             [login logOut];
                             return;
                         }else{
                             FBSDKAccessToken *token= [FBSDKAccessToken currentAccessToken];
                             
                             NSString *FBappID=token.appID;
                             NSSet *declinedPermissions=token.declinedPermissions;
                             NSDate *expirationDate=token.expirationDate;
                             NSSet *permissions=token.permissions;
                             NSDate *refreshDate=token.refreshDate;
                             NSString *tokenString=token.tokenString;
                             NSString *userID=token.userID;
                             socialModel.firstName = [NSString stringWithFormat:@"%@",[result objectForKey:@"first_name"]];
                             NSLog(@"%@",result);
                             socialModel.lastName = [NSString stringWithFormat:@"%@",[result objectForKey:@"last_name"]];
                             socialModel.email = [NSString stringWithFormat:@"%@",[result objectForKey:@"email"]];
                             
                             
                             //                         FBSDKAccessToken *token= [FBSDKAccessToken currentAccessToken];
                             //                         NSString *FBappID=token.appID;
                             //                         //  self.reqModel.appId=FBappID;
                             //                         NSSet *declinedPermissions=token.declinedPermissions;
                             //                         NSDate *expirationDate=token.expirationDate;
                             //                         NSSet *permissions=token.permissions;
                             //                         NSDate *refreshDate=token.refreshDate;
                             //                         NSString *tokenString=token.tokenString;
                             //                         NSString *userID=token.userID;
                             socialModel.appId=userID;
                             socialModel.loginToken=tokenString;
                             socialModel.signupType=[NSNumber numberWithInteger:2];
                             NSString *gender=[NSString stringWithFormat:@"%@",[result objectForKey:@"gender"]];
                             if ([gender isEqual:@"male"]) {
                                socialModel.gender = [NSNumber numberWithInt:0];
                                 
                             }else{
                                 socialModel.gender = [NSNumber numberWithInt:1];
                             }
                             
                             socialModel.picUrl = [NSString stringWithFormat:@"%@",[[[result valueForKey:@"picture"] valueForKey:@"data"] objectForKey:@"url"]];
                             
                             
                             
                             //                         NSString *fbId=[result valueForKey:@"id"];
                             //
                             //                         FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                             //                                                       initWithGraphPath:[NSString stringWithFormat:@"me/picture?type=large&redirect=false"]
                             //                                                       parameters:nil
                             //                                                       HTTPMethod:@"GET"];
                             //                         [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                             //                                                               id result,
                             //                                                               NSError *error) {
                             //                             if (!error){
                             //
                             //                                 NSString *imgUrlStr=[[result  valueForKey:@"data"]valueForKey:@"url"];
                             //                                 NSURL *imgUrl=[NSURL URLWithString:imgUrlStr];
                             //                                 NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:imgUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                             //                                     if (data) {
                             //                                         UIImage *image = [UIImage imageWithData:data];
                             //                                         selectedImgBase64Str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                             //                                         if (image) {
                             //                                             dispatch_async(dispatch_get_main_queue(), ^{
                             //                                                 socialModel.picImg=image;
                             //                                                 [self.uploadBtn setBackgroundImage:image forState:UIControlStateNormal];
                             //                                             });
                             //                                         }
                             //                                     }
                             //                                 }] ;
                             //                                 [task resume];
                             //                                 
                             //                             }else {
                             //                                 NSLog(@"result: %@",[error description]);
                             //                             }}];
                             
                              handler(socialModel,error);
                             [FBSDKAccessToken setCurrentAccessToken:nil];
                             [login logOut];
                             
                         }
                      
                     }
                     else{
                         NSLog(@"%@", [error localizedDescription]);
                         handler(nil,error);
                     }
                 }];
            }
        }
    }];
}
- (void)GoogleLogincallBackHandler:(void(^)(SocialResponseModel *response, NSError *error))handler{
    [self setUpTheGooglePlus];
    [signIn authenticate];
}
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    
    SocialResponseModel *socialModel=[[SocialResponseModel alloc]init];
    
    
    socialModel.signupType=[NSNumber numberWithInteger:3];
    socialModel.firstName=signIn.googlePlusUser.name.familyName;
    socialModel.lastName=signIn.googlePlusUser.name.givenName;
    GTLPlusPersonEmailsItem *emailItem=[signIn.googlePlusUser.emails objectAtIndex:0];
    NSString *email=emailItem.value;
    socialModel.email=email;
//    passwordsView.hidden=YES;
//    passwordsViewHeight.constant=0;
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
        [self signOut];
    } else {
        
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        [plusService setAuthorizer:auth];
        NSLog(@"%@",signIn.googlePlusUser.name);
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        GTMLoggerError(@"Error: %@", error);
                        [self signOut];
                    } else {
                        // Retrieve the display name and "about me" text
                        
                        NSString *description = [NSString stringWithFormat:
                                                 @"%@\n%@", person.displayName,
                                                 person.aboutMe];
                        NSLog( @"%@",person.image.url);
                        NSLog( @"%@", person.identifier);
                        NSLog(@"%@",signIn.idToken);
                        socialModel.appId=person.identifier;
                        socialModel.loginToken=signIn.idToken;
                        NSString *gender= person.gender;
                        if ([gender isEqualToString:@"male"] || gender.length==0) {
                            
                            socialModel.gender=[NSNumber numberWithInteger:0];
                        }else{
                          socialModel.gender=[NSNumber numberWithInteger:1];
                            
                        }
                        if (person.image.url.length>0) {
                            
                            NSRange range = NSMakeRange(person.image.url.length-2,2);
                            NSString *newText = [person.image.url stringByReplacingCharactersInRange:range withString:@"100"];
                            
                            
                            NSURL *imgUrl=[NSURL URLWithString:newText];
                            socialModel.picUrl=newText;
//                            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:imgUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                                if (data) {
//                                    UIImage *image = [UIImage imageWithData:data];
//                                    if (image) {
//                                        selectedImgBase64Str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//                                        
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            [self.uploadBtn setBackgroundImage:image forState:UIControlStateNormal];
//                                        });
//                                    }
//                                }
//                            }] ;
                           // [task resume];
                        }
                        //    [self.uploadBtn setBackgroundImage:chosenImage forState:UIControlStateNormal];;
                        
                        NSLog(@"%@",description);
                        // [self callSignupRequest];
                        
                        
                        [self signOut];
                        [self.delegates gettingSocialResponseModel:socialModel];
                    }
                }];
        
        // [self refreshInterfaceBasedOnSignIn];
    }
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}
-(void)setUpTheGooglePlus{
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = @"91044725520-eg55bs3iik2s8npf3qia2etgqdvffa6i.apps.googleusercontent.com";
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
}


@end
