//
//  UpComingViewController.h
//  StyleMyBody
//
//  Created by sipani online on 25/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentsHistoryModel.h"

@interface UpComingViewController : UIViewController
@property (nonatomic , strong) AppointmentsHistoryModel* appointmentsHistoryModel;
@property (nonatomic , weak) IBOutlet UITableView *tblView;
    

@end
