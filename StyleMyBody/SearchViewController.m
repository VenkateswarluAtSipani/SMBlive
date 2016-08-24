//
//  SearchViewController.m
//  StyleMyBody
//
//  Created by sipani online on 20/05/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "SearchViewController.h"
#import "NearByCentersViewController.h"
#import "MBProgressHUD.h"
#import "RestClient.h"
#import "AutoSearchModel.h"
#import "CenterViewController.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *searchResultArray;
    RestClient *restClient;
    AutoSearchModel *selectedSearchModel;
}
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];

    self.hederLbl.font = [UIFont fontWithName:@"Pacifico" size:18];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self getSearcHAPI];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([selectedSearchModel.search isEqualToString:searchBar.text]) {
        
    }else{
        selectedSearchModel=[[AutoSearchModel alloc]init];
        selectedSearchModel.search=searchBar.text;
        selectedSearchModel.type=[NSNumber numberWithInt:0];
        selectedSearchModel.centerID=[NSNumber numberWithInt:0];
    }
    [self performSegueWithIdentifier:@"centerView" sender:self];
    
    
   // [self getSearcHAPI];
//   NearByCentersViewController *NearByVC= [self.storyboard instantiateViewControllerWithIdentifier:@"centerVC"];
//    [self.navigationController pushViewController:NearByVC animated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CenterViewController *centerView=segue.destinationViewController;
    centerView.autoSearchModel=selectedSearchModel;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return searchResultArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
    AutoSearchModel *searchModel=[searchResultArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ center",searchModel.search];
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}

- (void)getSearcHAPI {
    if ([restClient rechabilityCheck]) {
    [restClient getAutoSearch:[NSNumber numberWithInt:0] isFev:self.searchBar.text callBackRes:^(NSArray *autoSearchArr, NSError *error) {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            searchResultArray=autoSearchArr;
            [self.searchResultTbl reloadData];
        });
        
    }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AutoSearchModel *searchModel=[searchResultArray objectAtIndex:indexPath.row];
    _searchBar.text=[NSString stringWithFormat:@"%@",searchModel.search];
    selectedSearchModel=searchModel=nil;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backTOmainVC:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
