//
//  CenterViewController.h
//  StyleMyBody
//
//  Created by sipani online on 4/14/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCatagoryResModel.h"
#import "AutoSearchModel.h"

@interface CenterViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *headerLbl;
@property (nonatomic, strong) HomeCatagoryResModel *categoryModel;
@property (weak, nonatomic) IBOutlet UIButton *locationBTN;

-(IBAction)filterBtnACtion:(id)sender;
@property (nonatomic, weak) AutoSearchModel *autoSearchModel;
@end
