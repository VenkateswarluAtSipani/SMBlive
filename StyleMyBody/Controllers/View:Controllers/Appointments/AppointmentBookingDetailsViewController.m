//
//  AppointmentBookingDetailsViewController.m
//  StyleMyBody
//
//  Created by apple on 22/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "AppointmentBookingDetailsViewController.h"

#import "AppointmentBookingDetailsCell.h"

@interface AppointmentBookingDetailsViewController ()


@end

@implementation AppointmentBookingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.bookedServices.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    if (indexPath.row==0) {
        cellIdentifier=@"saloonCell";
            }else{
         cellIdentifier=@"servicesCell";
    }
    AppointmentBookingDetailsCell*bookingDetailscell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    bookingDetailscell.bookingIdLbl.text=[NSString stringWithFormat:@" Booking ID: %@" ,self.model.bookingId];
    bookingDetailscell.totalAmountLbl.text=[NSString stringWithFormat:@"\u20B9 %@",self.model.amountPaid];
    bookingDetailscell.saloonLbl.text=self.model.centerName;
    bookingDetailscell.dateLbl.text=self.model.bookingDate;
   if (indexPath.row!=0) {
       NSDictionary*serviceslist=[self.model.bookedServices objectAtIndex:indexPath.row-1];
       NSString*serviseName=[serviceslist objectForKey:@"name"];
       NSString*amount=[serviceslist objectForKey:@"price"];
       bookingDetailscell.servicesNameLbl.text=serviseName;
       bookingDetailscell.amountLbl.text=[NSString stringWithFormat:@"%@", amount ];
    }
    
    
    
           return bookingDetailscell;
}
#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
