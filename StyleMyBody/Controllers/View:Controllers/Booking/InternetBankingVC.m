//
//  InternetBankingVC.m
//  StyleMyBody
//
//  Created by sipani online on 08/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "InternetBankingVC.h"
#import "RestClient.h"
#import "MBProgressHUD.h"




@interface InternetBankingVC ()<UITableViewDataSource,UITableViewDelegate>{
    RestClient *restClient;
}
@property(nonatomic,strong)NSArray*arr;


@end

@implementation InternetBankingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];
    [self getBookingInfo];
    self.tableView.hidden=YES;
    self.arr=[NSArray arrayWithObjects:@"hari",@"mahi",@"ram", nil];
    self.tableView.layer.shadowColor = [UIColor blackColor].CGColor; ///Shadow
    self.tableView.layer.shadowOffset = CGSizeZero;
    self.tableView.layer.shadowOpacity = 1;
    self.tableView.layer.shadowRadius = 10.0;    // Do any additional setup after loading the view, typically from a nib.
    
    bottomspaceofTV.active=NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text=[self.arr objectAtIndex:indexPath.row];
    CGFloat height=self.tableView.contentSize.height;
    if (height>200) {
        heightofTV.active=NO;
        bottomspaceofTV.active=YES;
    }else{
        heightofTV.active=YES;
        heightofTV.constant=height;
        bottomspaceofTV.active=NO;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:indexPath];
    [self.btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tableView.hidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dropclick:(UIButton *)sender {
    if (self.tableView.hidden==YES) {
        self.tableView.hidden=NO;
    }else{
        self.tableView.hidden=NO;
  }

}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)getBookingInfo{
    
//    NSDictionary *bookingInfoDict=[NSDictionary dictionaryWithObjectsAndKeys:[self.bookingIdDict valueForKey:@"bookingId"],@"bookingId",[NSNumber numberWithInt:1],@"transactionType",[NSNumber numberWithInt:3],@"paymentMode", nil];
//    
//    [restClient getBookingInfo:bookingInfoDict callBackHandler:^(NSDictionary *response, NSError *error) {
//        
//    }];
}
@end
