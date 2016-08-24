//
//  OfferDetailViewController.m
//  StyleMyBody
//
//  Created by sipani online on 5/25/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "OfferDetailViewController.h"
#import "SignInDetailHandler.h"
#import "SignInViewController.h"
#import "AllStylistServiceViewController.h"
#import "SignViewController.h"
#import "RestClient.h"

@interface OfferDetailViewController ()<UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation OfferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerTitleLbl.font = [UIFont fontWithName:@"Pacifico" size:24];
    self.headerTitleLbl.text = self.serviceModel.name;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 4;

    return row;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    if (indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"offerImgCell"];
        UIImageView *imgView = [cell viewWithTag:10];
        [RestClient loadImageinImgView:imgView withUrlString:self.serviceModel.image];

    }else if (indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"offerTitleCell"];
        UILabel *nameLbl = [cell viewWithTag:10];
        nameLbl.text = self.serviceModel.name;
        UILabel *priceLbl = [cell viewWithTag:11];
        priceLbl.text = [NSString stringWithFormat:@"\u20B9 %@",[self.serviceModel.price stringValue]];

    }else if (indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"offerDescroptionCell"];
        UILabel *descriptionHeaderLbl = [cell viewWithTag:10];
        descriptionHeaderLbl.text = @"DESCRIPTION";
        UILabel *descriptionLbl = [cell viewWithTag:11];
        descriptionLbl.text = self.serviceModel.serDescription;
    }else if (indexPath.row == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:@"offerDescroptionCell"];
        UILabel *timeTakenLbl = [cell viewWithTag:10];
        timeTakenLbl.text = @"TIME TAKEN";

        UILabel *timeLbl = [cell viewWithTag:11];
        timeLbl.text =[NSString stringWithFormat:@"%@ mins",[self.serviceModel.time stringValue]];
    
    }
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (IBAction)clickOnBack:(id)sender;
{
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

@end
