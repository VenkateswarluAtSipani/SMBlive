//
//  SignViewController.h
//  StyleMyBody
//
//  Created by sipani online on 4/19/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FromMenu,
    FromOther
} ViewFrom;

@interface SignViewController : UIViewController

@property (nonatomic, assign) ViewFrom viewFrom;

@end
