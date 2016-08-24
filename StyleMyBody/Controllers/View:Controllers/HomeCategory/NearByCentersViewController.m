//
//  NearByCentersViewController.m
//  PageMenuDemoStoryboard
//
//  Created by sipani online on 4/14/16.
//  Copyright © 2016 Jin Sasaki. All rights reserved.
//

#import "NearByCentersViewController.h"
#import "CenterListCell.h"
#import "CenterListResModel.h"
#import <CoreLocation/CoreLocation.h>
#import "Utility.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "AllServiceStylistViewController.h"
#import "SignInDetailHandler.h"
#import "RestClient.h"

@interface NearByCentersViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,CellDelegate>

@property (nonatomic, assign) double startLatitudeVal;
@property (nonatomic, assign) double startLongitudeVal;

@end

@implementation NearByCentersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.tableView.estimatedRowHeight = 1000;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nearByCenterListModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CenterListResModel *model = self.nearByCenterListModel[indexPath.row];
    
    CenterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];
    cell.bigImgView.image = [UIImage imageNamed:@"default"];
//    cell.thumbImgView;
    cell.displyTitleLbl.text = model.displayName;
//    cell.ratingImgView;
    NSString *addressStr = model.address;
    NSArray *arr = [addressStr componentsSeparatedByString:@","];
    
    if ([model.isFavorite boolValue]) {
        [cell.favBtn setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
    }else{
        [cell.favBtn setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
    }
    
    cell.addressLbl.text = model.location;
    cell.distanceLbl.text =[NSString stringWithFormat:@"%.1f kms away",[model.currentDistance doubleValue]];
    cell.priceLbl.text = [NSString stringWithFormat:@"\u20B9 %@.0", [model.price stringValue]];
    cell.delegate = self;
    cell.cellId = indexPath;
    
    if ([model.serveFor intValue] == 0) {
        cell.sexLBL.text = @"Male";
    }else if ([model.serveFor intValue] == 1) {
        cell.sexLBL.text = @"Female";

    }else if ([model.serveFor intValue] == 2) {
        cell.sexLBL.text = @"Unisex";

    }
    
    //
    cell.ratingImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Rating-%d",[model.rating intValue]]];

    if (![model.isOffer boolValue] && ![model.isHomeService boolValue]) {
        cell.serviceHomeView.hidden = YES;
    }else{
        cell.serviceHomeView.hidden = NO;
    }
    
    if ([model.isOffer boolValue]) {
        cell.offerBtn.hidden = NO;
    }else
    {
        cell.offerBtn.hidden = YES;
    }
    if ( [model.isHomeService boolValue]) {
        cell.homeSerivceBtn.hidden = NO;
    }else
    {
        cell.homeSerivceBtn.hidden = YES;
    }
    
    if ([model.isOffer boolValue] ) {
        [cell.offerBtn setImage:[UIImage imageNamed:@"offers-1"] forState:UIControlStateNormal];
        cell.offerBtn.hidden = NO;
        if ([model.isHomeService boolValue]) {
            [cell.homeSerivceBtn setImage:[UIImage imageNamed:@"home-service"] forState:UIControlStateNormal];
            cell.homeSerivceBtn.hidden = NO;
        }
    }else{
        if ([model.isHomeService boolValue]) {
            [cell.offerBtn setImage:[UIImage imageNamed:@"home-service"] forState:UIControlStateNormal];
            cell.homeSerivceBtn.hidden = YES;
            cell.offerBtn.hidden = NO;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [RestClient loadImageinImgView:cell.bigImgView withUrlString:model.displayImage];
    [RestClient loadImageinImgView:cell.thumbImgView withUrlString:model.logo];
    
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:indexPath,@"indexPath",@"NearBy",@"FromView", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSelectCell" object:dict];
}

#pragma mark - Cell Delegate

- (void)bookNowButtonClicked:(NSIndexPath *)sender {
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:sender,@"indexPath",@"NearBy",@"FromView", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSelectBookNow" object:dict];
}

- (void)fevButtonClicked:(NSIndexPath *)sender isFev:(NSNumber *)isFev;
{
    SignInDetailHandler *dataHandler = [SignInDetailHandler sharedInstance];
    
    if (dataHandler.isSignin == YES) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:sender,@"indexPath",@"NearBy",@"FromView",isFev,@"IsFev", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FevSelectNow" object:dict];
    }else{
        NSString* errorMsg = @"Please Login";
        
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
