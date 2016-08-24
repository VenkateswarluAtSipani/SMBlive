//
//  StylistListTableViewCell.h
//  StyleMyBody
//
//  Created by sipani online on 5/18/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StylistListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UIImageView *selectedImgView;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UIImageView *ratingImgView;
@property (nonatomic, weak) IBOutlet UILabel *availableTimeSlots;
@property (nonatomic, weak) IBOutlet UILabel *morningLbl;
@property (nonatomic, weak) IBOutlet UILabel *afterNoonLbl;
@property (nonatomic, weak) IBOutlet UILabel *eveingLbl;
@property (nonatomic, weak) IBOutlet UIView *timeSlotView;


@end
