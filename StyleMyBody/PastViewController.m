//
//  PastViewController.m
//  StyleMyBody
//
//  Created by sipani online on 25/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "PastViewController.h"
#import "RestClient.h"
#import "AppointmentsResModel.h"
#import "AppointmentsHistoryModel.h"
#import "UpcomeingAppointmentCell.h"
#import "PastAppointmentCell.h"

@interface PastViewController ()<UITableViewDataSource,UITabBarDelegate>
{
    RestClient *restClient;
    NSArray*appointmentsArray;
}
@end

@implementation PastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient =[[RestClient alloc]init];
    if ([restClient rechabilityCheck]) {
    [restClient getAppointmentsDetails:2 callBackHandler:^(AppointmentsResModel *appointments, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             appointmentsArray=appointments.AppointmentsArray;
             [_tblView reloadData];
         });
     }];
    }
    // Do any additional setup after loading the view.
}
//-(void)viewDidAppear:(BOOL)animated{
//    [restClient getAppointmentsDetails:1 callBackHandler:^(AppointmentsResModel* appointments, NSError* error) {
//        
//    }];
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return appointmentsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PastAppointmentCell *pastAppointmentCell=[tableView dequeueReusableCellWithIdentifier:@"PastAppointmentCell"];
    AppointmentsHistoryModel *appointmentsHistoryModel=[appointmentsArray objectAtIndex:indexPath.row];
    pastAppointmentCell.bookingIdLbl.text=[NSString stringWithFormat:@" Booking ID: %@" ,appointmentsHistoryModel.bookingId];
    pastAppointmentCell.centerName.text=appointmentsHistoryModel.centerName;
    pastAppointmentCell.dateANdTimeLbl.text=appointmentsHistoryModel.bookingDate;
    pastAppointmentCell.bookingIdLbl.text=[NSString stringWithFormat:@" Booking ID: %@" ,appointmentsHistoryModel.bookingId];
     pastAppointmentCell.selectionStyle=UITableViewCellEditingStyleNone;
    return pastAppointmentCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     AppointmentsHistoryModel *appointmentsHistoryModel =[appointmentsArray objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pastCellSelected" object:appointmentsHistoryModel];
    
    //  [self performSegueWithIdentifier:@"upcomingVC" sender:indexPath];
    
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
