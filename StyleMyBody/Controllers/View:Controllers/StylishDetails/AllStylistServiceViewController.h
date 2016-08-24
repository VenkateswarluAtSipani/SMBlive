//
//  AllStylistServiceViewController.h
//  StyleMyBody
//
//  Created by macbook on 03/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllStylistServiceViewController : UIViewController
{
    
    __weak IBOutlet UIDatePicker *datePicker;
    
    
}
@property (nonatomic, strong) NSNumber *centerId;
@property (nonatomic, strong) NSNumber *offerId;
@property (nonatomic, strong) NSNumber *packageId;

@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *spaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *spaceConstraint1;


@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
- (IBAction)dateBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *DatePickerAlertView;
@property (weak, nonatomic) IBOutlet UIView *dateAlertView;

- (IBAction)datePickerValueChangedAction:(id)sender;

- (IBAction)dateSelectACtion:(id)sender;
- (IBAction)dateCancelACtion:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *datePickerBlurBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfBottomView;

@end
