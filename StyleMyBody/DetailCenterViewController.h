//
//  DetailCenterViewController.h
//  StyleMyBody
//
//  Created by sipani online on 5/2/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterListResModel.h"

@interface DetailCenterViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel *headerTitleLbl;
@property (nonatomic, strong) NSString *headerTitleStr;

@property (nonatomic, strong) CenterListResModel *selectedCenterItemModel;
@end
