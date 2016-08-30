//
//  AppDelegate.m
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GooglePlus/GooglePlus.h>
#import "RestClient.h"
#import "EssentialsModel.h"
#import "APIConstants.h"
#import <GooglePlaces/GooglePlaces.h>

@interface AppDelegate ()
{
    RestClient *restClient;
    
}
// Instantiate a pair of UILabels in Interface Builder

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    restClient=[[RestClient alloc]init];
    
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
        [FBSDKAppLinkUtility fetchDeferredAppInvite:^(NSURL *url) {
            if (url) {
                // { process url }
            }
        }];
    }
    
    [GMSServices provideAPIKey:@"AIzaSyDmHZeQUjsytw7bxbEB5YKjn2UsC5eTVsk"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyDmHZeQUjsytw7bxbEB5YKjn2UsC5eTVsk"];
     NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    [restClient getLatestVersionOfAPPcallBackRes:^(NSString *latestVersion, NSError *error) {
        
        
        [restClient getAccentials:^(EssentialsModel *essentialsModel, NSError *error) {
            
            
                if (![latestVersion isEqualToString:appVersion])
                {
                    UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"New Version!!" message: @"A new version of app is available to download" delegate:self cancelButtonTitle:nil otherButtonTitles: @"Update", nil];
                      //  [createUserResponseAlert show];
                }
        }];
        
        
    }];

    
    
    return YES;
}

-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *iTunesLink = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/app-name/id%@?ls=1&mt=8",AppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    //    return [[FBSDKApplicationDelegate sharedInstance] application:application
    //                                                          openURL:url
    //                                                sourceApplication:sourceApplication
    //                                                       annotation:annotation];
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    
    
    BOOL handled1= [GPPURLHandler handleURL:url
                           sourceApplication:sourceApplication
                                  annotation:annotation];
    
    if (handled) {
        return handled;
    }
    if (handled1) {
        return handled1;
    }
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    
//    ASIFormDataRequest* versionRequest = [ASIFormDataRequest requestWithURL:url];
//    versionRequest setRequestMethod:@"GET"];
//    versionRequest setDelegate:self];
//    versionRequest setTimeOutSeconds:100];
//    [versionRequest addRequestHeader:@"Content-Type" value:@"application/json"];
//    [versionRequest startSynchronous];
//    Response string of our REST call
//    NSString* jsonResponseString = [versionRequest responseString];
//    NSDictionary *loginAuthenticationResponse = [jsonResponseString objectFromJSONString];
//    NSArray *configData = [loginAuthenticationResponse valueForKey:@"results"];
//    for (id config in configData)
//    {
//        version = [config valueForKey:@"version"];
//        
//    }
//    Compare Both Versions
//    NSString *version = @"1.0";
//    if (![version isEqualToString:[itsUserDefaults objectForKey:@"version"]])
//    {
//        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"New Version!!" message: @"A new version of app is available to download" delegate:self cancelButtonTitle:nil otherButtonTitles: @”Update", nil];
//                                                [createUserResponseAlert show];
//                                                [createUserResponseAlert release];//Avoid if using Automatic reference counting
//                                                }
//                                                
//                                                Redirect User
//                                                
//                                                -(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//        {
//            NSString *iTunesLink = @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=<appid>&mt=8";
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
//        }
//    
//    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
   
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Sipani.StyleMyBody" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StyleMyBody" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"StyleMyBody.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
