//
//  PastAppointmentCell.h
//  StyleMyBody
//
//  Created by apple on 23/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastAppointmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *bookingIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *centerName;
@property (weak, nonatomic) IBOutlet UILabel *servicesLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateANdTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *reSheduleBtn;

@end
