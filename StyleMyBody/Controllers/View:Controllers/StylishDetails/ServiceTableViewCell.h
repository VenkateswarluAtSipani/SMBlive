//
//  ServiceTableViewCell.h
//  StyleMyBody
//
//  Created by sipani online on 5/18/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *priceLbl;
@property (nonatomic, weak) IBOutlet UILabel *durationLbl;
@property (nonatomic, weak) IBOutlet UIImageView *homeIconImg;
@property (nonatomic, weak) IBOutlet UIImageView *packgIconImg;
@property (nonatomic, weak) IBOutlet UIImageView *offerIconImg;

@property (nonatomic, assign) IBOutlet NSLayoutConstraint *viewWidthConstarint;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImgView;

@property (weak, nonatomic) IBOutlet UIStackView *iconsStackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfIconsStackView;


@end
