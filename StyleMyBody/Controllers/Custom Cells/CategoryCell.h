//
//  CategoryCell.h
//  StyleMyBody
//
//  Created by apple on 22/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
- (IBAction)categoryBtnAction:(id)sender;

@end
