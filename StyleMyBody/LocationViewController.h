//
//  LocationViewController.h
//  StyleMyBody
//
//  Created by sipani online on 20/05/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;

- (IBAction)backTomainVC:(UIButton *)sender;
- (IBAction)locationSymbolAction:(UIButton *)sender;
- (IBAction)autoDetectLocation:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
