//
//  UpComingViewController.m
//  StyleMyBody
//
//  Created by sipani online on 25/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "UpComingViewController.h"
#import "RestClient.h"
#import "UpcomeingAppointmentCell.h"
#import "AppointmentsHistoryModel.h"
#import "AppointmentBookingDetailsViewController.h"

@interface UpComingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    RestClient *restClient;
    NSArray *appointmentsArray;
    AppointmentsHistoryModel*appointmentdetails;
    
}
@end

@implementation UpComingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient =[[RestClient alloc]init];
    if ([restClient rechabilityCheck]) {
    [restClient getAppointmentsDetails:1 callBackHandler:^(AppointmentsResModel *appointments, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             appointmentsArray=appointments.AppointmentsArray;
             [_tblView reloadData];
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
    UpcomeingAppointmentCell *upcomeingAppointmentCell=[tableView dequeueReusableCellWithIdentifier:@"UpcomeingAppointmentCell"];
    self.appointmentsHistoryModel=[appointmentsArray objectAtIndex:indexPath.row];
    upcomeingAppointmentCell.bookingIdLbl.text=[NSString stringWithFormat:@" Booking ID: %@" ,self.appointmentsHistoryModel.bookingId];
    upcomeingAppointmentCell.centerName.text=self.appointmentsHistoryModel.centerName;
    NSDictionary*serviceslist=[self.appointmentsHistoryModel.bookedServices objectAtIndex:indexPath.row];
    NSString*serviseName=[serviceslist objectForKey:@"name"];
    upcomeingAppointmentCell.servicesLbl.text=serviseName;

    if (self.appointmentsHistoryModel.bookedServices.count==1) {
      upcomeingAppointmentCell.servicesCountLbl.text=@"";
        
    }else{
        upcomeingAppointmentCell.servicesCountLbl.text=[NSString stringWithFormat:@"+ %ld More" ,self.appointmentsHistoryModel.bookedServices.count-1 ];
 
    }
   
    upcomeingAppointmentCell.dateANdTimeLbl.text=self.appointmentsHistoryModel.bookingDate;
    upcomeingAppointmentCell.bookingIdLbl.text=[NSString stringWithFormat:@" Booking ID: %@" ,self.appointmentsHistoryModel.bookingId];
    upcomeingAppointmentCell.amountLbl.text=[NSString stringWithFormat:@"\u20B9 %@",self.appointmentsHistoryModel.amountPaid];
    
     upcomeingAppointmentCell.selectionStyle=UITableViewCellEditingStyleNone;
    
    return upcomeingAppointmentCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    appointmentdetails =[appointmentsArray objectAtIndex:indexPath.row];
     NSLog(@"%@",appointmentdetails);
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"UpComingCellSelected" object:appointmentdetails];
    
      //  [self performSegueWithIdentifier:@"upcomingVC" sender:indexPath];
   
    }
@end
