//
//  AppointmentBookingDetailsCell.h
//  StyleMyBody
//
//  Created by apple on 27/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentBookingDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookingIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *saloonLbl;
@property (weak, nonatomic) IBOutlet UILabel *servicesNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;


@end
