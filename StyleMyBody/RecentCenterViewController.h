//
//  RecentCenterViewController.h
//  PageMenuDemoStoryboard
//
//  Created by sipani online on 4/14/16.
//  Copyright © 2016 Jin Sasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCatagoryResModel.h"

@interface RecentCenterViewController : UIViewController

@property (nonatomic, strong) NSArray *recentCenterListModel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HomeCatagoryResModel *categoryModel;


@end
