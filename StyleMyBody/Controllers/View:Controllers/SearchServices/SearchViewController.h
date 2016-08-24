//
//  SearchViewController.h
//  StyleMyBody
//
//  Created by sipani online on 20/05/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *hederLbl;
- (IBAction)backTOmainVC:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTbl;

@end
