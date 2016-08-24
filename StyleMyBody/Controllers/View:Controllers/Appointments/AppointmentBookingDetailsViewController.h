//
//  AppointmentBookingDetailsViewController.h
//  StyleMyBody
//
//  Created by apple on 22/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentsHistoryModel.h"


@interface AppointmentBookingDetailsViewController : UIViewController

@property(nonatomic , strong)NSArray*appointmentDetailsArr;
@property (nonatomic , strong) AppointmentsHistoryModel*model;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backBtnAction:(id)sender;


@end
