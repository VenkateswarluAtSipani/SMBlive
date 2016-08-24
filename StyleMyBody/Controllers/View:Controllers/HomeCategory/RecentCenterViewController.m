//
//  RecentCenterViewController.m
//  PageMenuDemoStoryboard
//
//  Created by sipani online on 4/14/16.
//  Copyright © 2016 Jin Sasaki. All rights reserved.
//

#import "RecentCenterViewController.h"
#import "CenterListCell.h"
#import "CenterListResModel.h"
#import <CoreLocation/CoreLocation.h>
#import "Utility.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "MBProgressHUD.h"
#import "RestClient.h"
#import "SignInDetailHandler.h"

@interface RecentCenterViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    RestClient *restClient;
}

@property (nonatomic, weak) IBOutlet UILabel *loginMsgLbl;

@end

@implementation RecentCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     restClient=[[RestClient alloc]init];
    self.loginMsgLbl.hidden = YES;
    self.tableView.hidden = YES;
//    [self performSelector:@selector(callAPI) withObject:nil afterDelay:0.1];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
    [self callAPI];  
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)callAPI {
    SignInDetailHandler *dataHandler = [SignInDetailHandler sharedInstance];
    
    if (dataHandler.isSignin) {
        self.loginMsgLbl.hidden = YES;
        self.tableView.hidden = NO;
        [self getCenterList];
    }else{
        self.tableView.hidden = NO;
        self.loginMsgLbl.hidden = NO;
        self.loginMsgLbl.backgroundColor = [UIColor redColor];
//        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please Login" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [controller addAction:okAction];
//        [self presentViewController:controller animated:YES completion:^{
//            
//        }];
    }
}

- (void)getCenterList {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    if ([restClient rechabilityCheck]) {
    [restClient getRecentCenterList:self.categoryModel.categoryId callBackRes:^(NSArray *centerList, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recentCenterListModel = centerList;
            [self.tableView reloadData];
            
            [hud hideAnimated:YES];
        });
    }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recentCenterListModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CenterListResModel *model = self.recentCenterListModel[indexPath.row];
    
    CenterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];
    cell.bigImgView.image = [UIImage imageNamed:@"default"];
    //    cell.thumbImgView;
    cell.displyTitleLbl.text = model.displayName;
    //    cell.ratingImgView;
    cell.addressLbl.text = [NSString stringWithFormat:@"%@",model.address];
    cell.distanceLbl.text =[NSString stringWithFormat:@"%.1f kms away",[model.currentDistance doubleValue]];
    cell.priceLbl.text = [NSString stringWithFormat:@"\u20B9 %@", [model.price stringValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSURL *url = [NSURL URLWithString:model.displayImage];
    
    [RestClient loadImageinImgView:cell.bigImgView withUrlString:model.displayImage];
    [RestClient loadImageinImgView:cell.thumbImgView withUrlString:model.logo];

    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:indexPath,@"indexPath",@"Recent",@"FromView", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSelectCell" object:dict];
}

@end
