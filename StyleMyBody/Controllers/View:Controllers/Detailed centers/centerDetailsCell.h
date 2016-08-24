//
//  centerDetailsCell.h
//  StyleMyBody
//
//  Created by sipani online on 05/08/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface centerDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *acView;
@property (weak, nonatomic) IBOutlet UIView *wiFiView;
@property (weak, nonatomic) IBOutlet UIView *TvView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *acViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wiFiViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TvViewWidth;



@end
