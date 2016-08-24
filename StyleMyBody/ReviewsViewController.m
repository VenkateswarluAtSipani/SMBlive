//
//  ReviewsViewController.m
//  StyleMyBody
//
//  Created by sipani online on 5/2/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "ReviewsViewController.h"
#import "MBProgressHUD.h"
#import "RestClient.h"
#import "CenterReviewCell.h"
#import "StylistServiceResModel.h"
#import "ReviewResModel.h"

@interface ReviewsViewController (){
    RestClient *restClient;
}


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *reviewsArr;

@end

@implementation ReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self callGetCenterDetails];
}

- (void)callGetCenterDetails {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    if ([restClient rechabilityCheck]) {
    [restClient  getCenterReviewsList:self.centerId callBackRes:^(NSArray *stylistArr, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.reviewsArr = stylistArr;
            [self.tableView reloadData];
            [hud hideAnimated:YES];
        });
    }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviewsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CenterReviewCell *cell = (CenterReviewCell *)[tableView dequeueReusableCellWithIdentifier:@"reviewCell"];
    
    ReviewResModel *model = self.reviewsArr[indexPath.row];
    cell.titleLbl.text = model.name;
    cell.dateLbl.text = model.date;
    cell.serviceLbl.text = model.services;
    cell.reviewLbl.text = model.review;
    UIImageView *ratingImgView = (UIImageView *)[cell viewWithTag:143];
    ratingImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Rating-%d",[model.rating intValue]]];

    cell.userImgView.layer.cornerRadius=cell.userImgView.frame.size.width/2;
    cell.userImgView.clipsToBounds=true;
    [RestClient loadImageinImgView:cell.userImgView withUrlString:model.photo];
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickOnBookNow:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSelectBookNow" object:nil];
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
