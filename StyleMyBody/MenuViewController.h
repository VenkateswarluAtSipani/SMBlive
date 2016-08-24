//
//  MenuViewController.h
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuSelectDelegate <NSObject>

- (void)didSelectMenuItem:(NSIndexPath *)indexPath;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id<MenuSelectDelegate> menuDelegate;

- (void)reloadData;

@end
