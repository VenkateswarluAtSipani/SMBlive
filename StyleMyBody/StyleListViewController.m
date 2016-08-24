//
//  StyleListViewController.m
//  StyleMyBody
//
//  Created by sipani online on 5/2/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "StyleListViewController.h"
#import "MBProgressHUD.h"
#import "RestClient.h"
#import "StylistCell.h"
#import "StylistServiceResModel.h"
#import "StylistResModel.h"
#import "SignInDetailHandler.h"

@interface StyleListViewController ()
{
    RestClient *restClient;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *stylistArr;

@end

@implementation StyleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
  
}
-(void)viewWillAppear:(BOOL)animated{
      [self callGetCenterDetails];
}
-(void)viewDidAppear:(BOOL)animated{
    
}
- (void)callGetCenterDetails {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.ParentView.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    if ([restClient rechabilityCheck]) {
    [restClient  getCenterStylistList:self.centerId callBackRes:^(NSArray *stylistArr, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stylistArr = stylistArr;
            [self.tableView reloadData];
            [hud hideAnimated:YES];
        });
    }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stylistArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StylistCell *cell = (StylistCell *)[tableView dequeueReusableCellWithIdentifier:@"stylistCell"];
    
    StylistResModel *model = self.stylistArr[indexPath.row];
    cell.nameLbl.text = model.name;
//    cell.ratingImgView.ima;
    cell.typeAndDistanceLbl.text = [NSString stringWithFormat:@"%@ . 2.0yrs exp",model.designation];;
    cell.favouriteBtn.tag=indexPath.row;
    [cell.favouriteBtn setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateSelected];
    [cell.favouriteBtn setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
    cell.favouriteBtn.selected=[model.isFavorite boolValue];
    [cell.favouriteBtn addTarget:self action:@selector(favoriteClicked:) forControlEvents:UIControlEventTouchUpInside];
    

//    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:model.displayImage] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (data) {
//            UIImage *image = [UIImage imageWithData:data];
//            if (image) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    displyaImgView.image = image;
//                });
//            }
//        }
//    }] ;
//    [task resume];
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}
-(IBAction)favoriteClicked:(id)sender{
    UIButton *favBtn=(UIButton*)sender;
    StylistResModel *model = self.stylistArr[favBtn.tag];
    NSLog( @"%@%@",model.stylistId,model.name);
    
    SignInDetailHandler *dataHandler = [SignInDetailHandler sharedInstance];
    if (dataHandler.isSignin == YES) {
        [self setFevToItem:model];
    }else{
        
        NSString* errorMsg = @"Please Login";
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Style My Body"
                                     message:errorMsg
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"PleaseLoginFromDetailCenterViewController" object:nil];
                             }];
        [view addAction:ok];
        [self presentViewController:view animated:YES completion:nil];
        
        
       
    }
    
}

- (void)setFevToItem:(StylistResModel *)model {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.ParentView.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
  //  CenterListResModel *model = [self.nearByController.nearByCenterListModel objectAtIndex:indexPath.row];
    bool isFav=![model.isFavorite boolValue];
    NSNumber *isfavNum=[NSNumber numberWithBool:isFav];
    
    if ([restClient rechabilityCheck]) {
        [restClient setFevStylist:model.centerStylistId centerId:self.centerId isFev:[NSNumber numberWithInteger:[isfavNum integerValue]] callBackRes:^(NSString *resStr, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self callGetCenterDetails];
                [hud hideAnimated:YES];
                
            });

            
        }];
    }
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
