//
//  StylistCell.h
//  StyleMyBody
//
//  Created by sipani online on 5/8/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StylistCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLbl;
@property (nonatomic, weak) IBOutlet UIImageView *ratingImgView;
@property (nonatomic, weak) IBOutlet UILabel *typeAndDistanceLbl;
@property (nonatomic, weak) IBOutlet UIButton *favouriteBtn;

- (IBAction)slectFevButton:(UIButton *)sender;

@end
