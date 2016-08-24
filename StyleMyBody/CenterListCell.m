//
//  CenterListCell.m
//  StyleMyBody
//
//  Created by sipani online on 4/14/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "CenterListCell.h"
#import "SignInDetailHandler.h"

@implementation CenterListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickOnBookNowButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bookNowButtonClicked:)]) {
        [self.delegate bookNowButtonClicked:self.cellId];
    }
}

- (IBAction)clickOnFevButton:(id)sender
{
    SignInDetailHandler *dataHandler = [SignInDetailHandler sharedInstance];
    
    NSNumber *isFev;
    if (dataHandler.isSignin == YES) {
    UIButton *fevBtn = (UIButton *)sender;
    if ([fevBtn.currentImage isEqual:[UIImage imageNamed:@"like1"]]) {
        isFev = [NSNumber numberWithInt:YES];
        [self.favBtn setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
    }else{
        isFev = [NSNumber numberWithInt:NO];
        [self.favBtn setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
    }
    }
//    if ([self.delegate respondsToSelector:@selector(fevButtonClicked::)]) {
    
        [self.delegate fevButtonClicked:self.cellId isFev:isFev];
//    }
}

@end
