//
//  OffersCell.h
//  StyleMyBody
//
//  Created by sipani online on 4/16/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *distanceLbl;
@property (nonatomic, weak) IBOutlet UILabel *offerTypeLbl;
@property (nonatomic, weak) IBOutlet UILabel *discountTitleLbl;
@property (nonatomic, weak) IBOutlet UILabel *expiryLbl;

@end
