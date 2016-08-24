//
//  CenterListCell.h
//  StyleMyBody
//
//  Created by sipani online on 4/14/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>

- (void)bookNowButtonClicked:(NSIndexPath *)sender;
- (void)fevButtonClicked:(NSIndexPath *)sender isFev:(NSNumber *)isFev;

@end

@interface CenterListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *bigImgView;
@property (nonatomic, weak) IBOutlet UIImageView *thumbImgView;
@property (nonatomic, weak) IBOutlet UILabel *displyTitleLbl;
@property (nonatomic, weak) IBOutlet UIImageView *ratingImgView;
@property (nonatomic, weak) IBOutlet UILabel *addressLbl;
@property (nonatomic, weak) IBOutlet UILabel *priceLbl;
@property (nonatomic, weak) IBOutlet UIView *serviceHomeView;
@property (nonatomic, weak) IBOutlet UIButton *booknowBtn;
@property (nonatomic, weak) IBOutlet UIButton *offerBtn;
@property (nonatomic, weak) IBOutlet UIButton *homeSerivceBtn;
@property (nonatomic, weak) IBOutlet UIButton *favBtn;
@property (nonatomic, weak) IBOutlet UILabel *distanceLbl;
@property (nonatomic, weak) IBOutlet UILabel *sexLBL;

@property (nonatomic, strong) NSIndexPath *cellId;
@property (nonatomic, assign) id<CellDelegate> delegate;

- (IBAction)clickOnOffersButton:(id)sender;
- (IBAction)clickOnHomeServiceButton:(id)sender;
- (IBAction)clickOnBookNowButton:(id)sender;
- (IBAction)clickOnFevButton:(id)sender;

@end
