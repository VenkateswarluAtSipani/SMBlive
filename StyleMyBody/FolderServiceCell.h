//
//  FolderServiceCell.h
//  StyleMyBody
//
//  Created by sipani online on 5/12/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderServiceCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *timeLbl;
@property (nonatomic, weak) IBOutlet UILabel *priceLbl;
@property (nonatomic, weak) IBOutlet UILabel *onwardsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serviceImgViewHeight;



@end
