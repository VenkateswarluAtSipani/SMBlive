//
//  StylistCell.m
//  StyleMyBody
//
//  Created by sipani online on 5/8/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "StylistCell.h"

@implementation StylistCell
{
    NSNumber *isFev;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)slectFevButton:(UIButton *)fevBtn {
    if ([fevBtn.currentImage isEqual:[UIImage imageNamed:@"like1"]]) {
        isFev = [NSNumber numberWithInt:YES];
        [fevBtn setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
    }else{
        isFev = [NSNumber numberWithInt:NO];
        [fevBtn setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
    }

}
@end
