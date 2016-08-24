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
    
    return addressCell;
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
