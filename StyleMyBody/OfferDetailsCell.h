//
//  OfferDetailsCell.h
//  StyleMyBody
//
//  Created by K venkateswarlu on 29/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UIImageView *secSmallImg;
@property (weak, nonatomic) IBOutlet UIScrollView *mainImgesScrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *expiresOnlbl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UILabel *servicesCanSelectLbl;
@property (weak, nonatomic) IBOutlet UILabel *validityLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *stylistListScroll;
@property (weak, nonatomic) IBOutlet UILabel *servicesTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *validityTitleLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *validityTitleLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freeOfferCellHeight;
@property (weak, nonatomic) IBOutlet UILabel *personsTitleLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dPicBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *freeDescriptionLbl;

@end
