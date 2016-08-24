//
//  ContactUsViewController.h
//  StyleMyBody
//
//  Created by sipani online on 25/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *categoryBackView;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
- (IBAction)selceCategoryBtn:(UIButton *)sender;
- (IBAction)clickCancel:(id)sender;
- (IBAction)clickSelect:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tollFreeNo;
@property (weak, nonatomic) IBOutlet UIButton *phoneNo;
@property (weak, nonatomic) IBOutlet UIButton *mailIdBtn;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end
