//
//  TimeSlotTableViewCell.h
//  StyleMyBody
//
//  Created by sipani online on 09/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeSlotTableViewCell : UITableViewCell{
    __weak IBOutlet UIDatePicker *datePicker;
}
@property (weak, nonatomic) IBOutlet UILabel *stylistName;

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
- (IBAction)dateBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *DatePickerAlertView;
@property (weak, nonatomic) IBOutlet UIView *dateAlertView;

- (IBAction)datePickerValueChangedAction:(id)sender;

- (IBAction)dateSelectACtion:(id)sender;
- (IBAction)dateCancelACtion:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *datePickerBlurBtn;

@end
