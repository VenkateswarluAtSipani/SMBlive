//
//  ManageAddressViewController.m
//  StyleMyBody
//
//  Created by sipani online on 01/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "ManageAddressViewController.h"
#import "RestClient.h"
#import "AddressListModel.h"
#import "AddressCell.h"
#import "BookingAddressView.h"

@interface ManageAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
{
   
        AddressListModel*model;
        RestClient *restClient;
        NSArray*addressArr;
    

}

@end

@implementation ManageAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];
    
    [self AddressModified:self];
}
-(void)viewWillAppear:(BOOL)animated{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddressModified:) name:@"DidUpdateAddress" object:nil];
}
-(IBAction)AddressModified:(id)sender{
    if ([restClient rechabilityCheck]) {
        [restClient getAddressList:^(NSArray *addressList, NSError *error) {
            
            addressArr=addressList;
            dispatch_async(dispatch_get_main_queue(), ^{
                [tblView reloadData];
                
            });
            
        }];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return addressArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *addressCell=[tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    AddressListModel *addressListModel=[addressArr objectAtIndex:indexPath.row];
    addressCell.nameLbl.text=addressListModel.tagName;
    addressCell.addressLbl.text=[NSString stringWithFormat:@"%@" @"%@" @"%@" @"%@" @"%@" @"%@" @"%@",addressListModel.addressOne,addressListModel.addressTwo,addressListModel.city,addressListModel.state,addressListModel.pincode,addressListModel.latitude,addressListModel.longitude];
    addressCell.editAddressBtn.tag=indexPath.row;
    [addressCell.editAddressBtn addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    addressCell.deleteArressBtn.tag=indexPath.row;
    [addressCell.deleteArressBtn addTarget:self action:@selector(deleteADdress:) forControlEvents:UIControlEventTouchUpInside];

    
    return addressCell;
}
-(IBAction)editAddress:(id)sender{
    UIButton *btn=(UIButton*)sender;
    AddressListModel *addressListModel=[addressArr objectAtIndex:btn.tag];
    
    BookingAddressView *bookingAddressView=[[UIStoryboard storyboardWithName:@"BookingAndPayment" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"BookingAddressView"];
    bookingAddressView.pageTitle=@"Manage Address";
    bookingAddressView.addressListModel=addressListModel ;
    [self.navigationController pushViewController:bookingAddressView animated:YES];
    
}
-(IBAction)AddAddress:(id)sender{
    BookingAddressView *bookingAddressView=[[UIStoryboard storyboardWithName:@"BookingAndPayment" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BookingAddressView"];
    bookingAddressView.pageTitle=@"Manage Address";
    bookingAddressView.addressListModel=nil ;
    [self.navigationController pushViewController:bookingAddressView animated:YES];
    

}
-(IBAction)deleteADdress:(id)sender{
    UIButton *btn=(UIButton*)sender;
    AddressListModel *addressListModel=[addressArr objectAtIndex:btn.tag];
    
    
    [restClient deleteAddress:addressListModel.addressId callBackRes:^(NSDictionary *responce, NSError *error) {
        if (responce) {
            [self AddressModified:self];
        }else{
            NSDictionary *dict = [error userInfo];
            
          NSString * errorMsg = dict[@"ErrorReason"];
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:errorMsg
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                    
                                 }];
            [view addAction:ok];
            [self presentViewController:view animated:YES completion:nil];

            

            
        }
    }];
    
 
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
