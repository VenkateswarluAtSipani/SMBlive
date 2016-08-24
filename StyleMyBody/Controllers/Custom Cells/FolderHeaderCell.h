//
//  FolderHeaderCellTableViewCell.h
//  StyleMyBody
//
//  Created by sipani online on 5/12/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FolderHeaderDelegate <NSObject>

- (void)didSeletedView:(NSInteger)cellId;

@end

@interface FolderHeaderCell : UITableViewCell

@property (nonatomic, assign) id<FolderHeaderDelegate> delegate;

@property (nonatomic, assign) NSInteger cellId;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UIImageView *folderMarkImgView;

- (IBAction)didSelectViewButton:(id)sender;


@end
