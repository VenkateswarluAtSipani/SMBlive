//
//  TimeSlotViewController.h
//  StyleMyBody
//
//  Created by sipani online on 04/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylistResModel.h"
//#import "StylistServiceResModel.h"
#import "AllStylistsResModel.h"


@interface NewTimeSlotViewController : UIViewController<UIScrollViewDelegate>{
    __weak IBOutlet UIView *placardView;
    
    __weak IBOutlet NSLayoutConstraint *XValueOfPlacardView;
    __weak IBOutlet UIView *ContentView;
    
    __weak IBOutlet NSLayoutConstraint *WidthOfPlaceCardView;
    __weak IBOutlet NSLayoutConstraint *startXAxisOfSilderView;
    
     __weak IBOutlet NSLayoutConstraint *WidthOfPlaceHomeView1;
     __weak IBOutlet NSLayoutConstraint *WidthOfPlaceHomeView2;
    
    __weak IBOutlet UIView *timeSlotView;
    __weak IBOutlet UILabel *slotTimeLbl;
    
    __weak IBOutlet UILabel *d1Name;
    __weak IBOutlet UIButton *d1Num;
    
    __weak IBOutlet UILabel *d2Name;
    __weak IBOutlet UIButton *d2Num;
    
    
    __weak IBOutlet UILabel *d3Name;
    __weak IBOutlet UIButton *d3Num;
    
    
    __weak IBOutlet UILabel *d4Name;
    __weak IBOutlet UIButton *d4Num;
    
    __weak IBOutlet UILabel *d5Name;
    __weak IBOutlet UIButton *d5Num;
    
    __weak IBOutlet UILabel *d6Name;
    __weak IBOutlet UIButton *d6Num;
    
    __weak IBOutlet UILabel *d7Name;
    __weak IBOutlet UIButton *d7Num;
    __weak IBOutlet UILabel *monthLbl;
    __weak IBOutlet UIDatePicker *datePicker;
}

- (IBAction)dayBtnACtion:(id)sender;
- (IBAction)bookNowAction:(id)sender;




@property (weak, nonatomic) IBOutlet UILabel *priceLBL;
@property (nonatomic, strong) NSNumber *centerId;
@property (nonatomic, strong) NSNumber *OfferId;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLBL;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLBL;

@property (nonatomic, strong) StylistResModel *selectedStylistModel;
@property (nonatomic, strong) AllStylistsResModel *allStylistsResModel;
@property (nonatomic, strong) NSArray *selectedServiceListinSplit;
@property (nonatomic, strong) NSDate *dateSelectedInPreviousPage;


@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
- (IBAction)dateBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *DatePickerAlertView;
@property (weak, nonatomic) IBOutlet UIView *dateAlertView;

- (IBAction)datePickerValueChangedAction:(id)sender;
- (IBAction)dateSelectACtion:(id)sender;
- (IBAction)dateCancelACtion:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *datePickerBlurBtn;

@property (weak, nonatomic) IBOutlet UIView *sliderTopCurve1;
@property (weak, nonatomic) IBOutlet UIView *sliderTopCurve2;

@property (weak, nonatomic) IBOutlet UIView *sliderBottomCurve;

@property (weak, nonatomic) IBOutlet UILabel *startAmOrPm;


- (IBAction)backToVC:(UIButton *)sender;
@end
