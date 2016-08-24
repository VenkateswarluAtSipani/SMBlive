//
//  OfferCenterViewController.h
//  PageMenuDemoStoryboard
//
//  Created by sipani online on 4/14/16.
//  Copyright © 2016 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferCenterViewController : UIViewController
@property (nonatomic, strong) NSArray *offerCenterListModel;
@property (nonatomic,assign)BOOL isBookNowNeeded;
@property (nonatomic, strong) NSNumber *centerId;
@property (nonatomic, strong) NSNumber *categoryId;
@end
