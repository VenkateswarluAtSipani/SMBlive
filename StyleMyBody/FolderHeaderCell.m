//
//  FolderHeaderCellTableViewCell.m
//  StyleMyBody
//
//  Created by sipani online on 5/12/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "FolderHeaderCell.h"

@implementation FolderHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSelectViewButton:(id)sender;
{
    if ([self.delegate respondsToSelector:@selector(didSeletedView:)]) {
        [self.delegate didSeletedView:self.cellId];
    }
}

@end
