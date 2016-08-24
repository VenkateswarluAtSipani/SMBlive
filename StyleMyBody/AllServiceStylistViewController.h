//
//  AllServiceStylistViewController.h
//  StyleMyBody
//
//  Created by sipani online on 5/17/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllServiceStylistViewController : UIViewController
{
    
    
    __weak IBOutlet UIDatePicker *datePicker;
    
    
}
@property (nonatomic, strong) NSNumber *centerId;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *spaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *spaceConstraint1;


- (IBAction)datepicker:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
- (IBAction)dateBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *DatePickerAlertView;
@property (weak, nonatomic) IBOutlet UIView *dateAlertView;

- (IBAction)datePickerValueChangedAction:(id)sender;

- (IBAction)dateSelectACtion:(id)sender;
- (IBAction)dateCancelACtion:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *datePickerBlurBtn;


@end
