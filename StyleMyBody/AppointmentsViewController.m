//
//  AppointmentsViewController.m
//  StyleMyBody
//
//  Created by sipani online on 25/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "AppointmentsViewController.h"
#import "UpComingViewController.h"
#import "PastViewController.h"
#import "NoShowViewController.h"
#import "CAPSPageMenu.h"
#import "AppointmentBookingDetailsViewController.h"
#import "AppointmentsHistoryModel.h"

@interface AppointmentsViewController ()
@property (nonatomic) CAPSPageMenu *pageMenu;
@property (nonatomic) UpComingViewController *upComingController;
@property (nonatomic) PastViewController *pastController;
@property (nonatomic) NoShowViewController *noShowController;

@end

@implementation AppointmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.upComingController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"upComingVC"];
    self.upComingController.title = @"UPCOMING";
    //    nearByController.categoryModel = self.categoryModel;
    
    self.pastController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"pastVC"];
    self.pastController.title = @"PAST";
//    self.recentController.categoryModel = self.categoryModel;
    //    nearByController.categoryModel = self.categoryModel;
    
    
    self.noShowController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"noShowVC"];
    self.noShowController.title = @"NO SHOW";
    
    
    NSArray *controllerArray = @[self.upComingController, self.pastController, self.noShowController];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:255.0/255.0 green:105.0/255.0 blue:66.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithRed:232.0/255.0 green:223.0/255.0 blue:23.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:238.0/255.0 green:241.0/255.0 blue:246.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @((self.view.bounds.size.width/3)-30),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [self.view addSubview:_pageMenu.view];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpComingCellSelected:) name:@"UpComingCellSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pastCellSelected:) name:@"pastCellSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noShowCellSelected:) name:@"noShowCellSelected" object:nil];
}
-(IBAction)UpComingCellSelected:(NSNotification*)sender
{
    AppointmentsHistoryModel *model=sender .object;
    [self performSegueWithIdentifier:@"upcomingVC" sender:model];
}
-(IBAction)pastCellSelected:(NSNotification*)sender
{
    AppointmentsHistoryModel *model=sender .object;
    [self performSegueWithIdentifier:@"upcomingVC" sender:model];
}
-(IBAction)noShowCellSelected:(NSNotification*)sender
{
    AppointmentsHistoryModel *model=sender .object;
    [self performSegueWithIdentifier:@"upcomingVC" sender:model];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"upcomingVC"]){
        AppointmentBookingDetailsViewController *appointmentBookingDetailsVC = segue.destinationViewController;
        appointmentBookingDetailsVC.model = sender;
        NSLog(@"%@",appointmentBookingDetailsVC.model);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
