//
//  SettingsViewController.m
//  StyleMyBody
//
//  Created by sipani online on 25/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    }else if (indexPath.row==1){
         cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
    }else if (indexPath.row==2){
         cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
    }else if (indexPath.row==3){
         cell=[tableView dequeueReusableCellWithIdentifier:@"cell4"];
    }else if (indexPath.row==4){
         cell=[tableView dequeueReusableCellWithIdentifier:@"cell5"];
    }
   cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
