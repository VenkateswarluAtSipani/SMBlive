//
//  NoShowViewController.m
//  StyleMyBody
//
//  Created by sipani online on 25/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "NoShowViewController.h"
#import "RestClient.h"
#import "AppointmentsHistoryModel.h"
#import "UpcomeingAppointmentCell.h"

@interface NoShowViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    RestClient *restClient;
    NSArray *appointmentsArray;

}


@end

@implementation NoShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient =[[RestClient alloc]init];
    if ([restClient rechabilityCheck]) {
    [restClient getAppointmentsDetails:3 callBackHandler:^(AppointmentsResModel *appointments, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             appointmentsArray=appointments.AppointmentsArray;
             [tblView reloadData];
             NSLog(@"%@",tblView);
         });
     }];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return appointmentsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpcomeingAppointmentCell *upcomeingAppointmentCell=[tableView dequeueReusableCellWithIdentifier:@"NoShowAppointmentCell"];
    AppointmentsHistoryModel *appointmentsHistoryModel=[appointmentsArray objectAtIndex:indexPath.row];
    upcomeingAppointmentCell.bookingIdLbl.text=[NSString stringWithFormat:@" Booking ID: %@" ,appointmentsHistoryModel.bookingId];
    upcomeingAppointmentCell.centerName.text=appointmentsHistoryModel.centerName;
    //    upcomeingAppointmentCell.servicesLbl.text=[NSString stringWithFormat:@"%@",appointmentsHistoryModel.bookingId];
    upcomeingAppointmentCell.dateANdTimeLbl.text=appointmentsHistoryModel.bookingDate;
    upcomeingAppointmentCell.bookingIdLbl.text=[NSString stringWithFormat:@" Booking ID: %@" ,appointmentsHistoryModel.bookingId];
    upcomeingAppointmentCell.selectionStyle=UITableViewCellEditingStyleNone;
    return upcomeingAppointmentCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppointmentsHistoryModel *appointmentsHistoryModel =[appointmentsArray objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noShowCellSelected" object:appointmentsHistoryModel];

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
