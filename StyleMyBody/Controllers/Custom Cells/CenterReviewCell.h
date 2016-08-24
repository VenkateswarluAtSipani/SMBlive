//
//  CenterReviewCell.h
//  StyleMyBody
//
//  Created by sipani online on 5/14/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterReviewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *userImgView;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *dateLbl;
@property (nonatomic, weak) IBOutlet UIImageView *reviewImgView;
@property (nonatomic, weak) IBOutlet UILabel *serviceLbl;
@property (nonatomic, weak) IBOutlet UILabel *reviewLbl;

@end
