//
//  MenuViewController.m
//  StyleMyBody
//
//  Created by sipani online on 4/11/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemCell.h"
#import "AppDelegate.h"
#import "SignInDetailHandler.h"
#import "LoginResponseModel.h"
#import "LoginUserResModel.h"
#import "AppointmentsViewController.h"

@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *menuItemArray;
@property (nonatomic, strong) NSArray *iconArr;;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, weak) IBOutlet UIImageView *profileImg;
@property (nonatomic, weak) IBOutlet UILabel *unserNameLbl;
@property (nonatomic, strong) SignInDetailHandler *signinHandler;


@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signinHandler = [SignInDetailHandler sharedInstance];
    //    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 160.0;
    self.profileImg.layer.cornerRadius = 25.f;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.signinHandler = [SignInDetailHandler sharedInstance];
    if (self.signinHandler.isSignin) {
        self.menuItemArray = [NSArray arrayWithObjects:@"Home",@"Appointments",@"General",@"Settings",@"Tutorials / FAQ",@"Contact us",@"Log out",@"Cash back",nil];
        self.iconArr = [NSArray arrayWithObjects:@"home-1",@"appointments",@"",@"setting1",@"faq-1",@"contact",@"log1",@"cashback", nil];
    }else{
        self.menuItemArray = [NSArray arrayWithObjects:@"Log In",@"Tutorials/FAQ",@"Contact US",nil];
        self.iconArr = [NSArray arrayWithObjects:@"log1",@"faq-1",@"contact", nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reloadData {
    LoginResponseModel *model = self.signinHandler.loginResModel;
    self.unserNameLbl.text = [NSString stringWithFormat:@"%@ %@",model.userDetails.firstName.length ? model.userDetails.firstName:@"" ,model.userDetails.lastName.length ? model.userDetails.lastName:@""];
    
    if (model.userDetails.photoUrl) {
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:model.userDetails.photoUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.profileImg.image = [UIImage imageWithData:data];
                self.profileImg.layer.cornerRadius=self.profileImg.frame.size.width/2;
                self.profileImg.clipsToBounds=true;
            });
        }];
        [dataTask resume];
        
        
        //        self.profileImg.image = img;
        
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        //            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.userDetails.photoUrl]]];
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                self.profileImg.image = img;
        //            });
        //        });
        
    }else{
        self.profileImg.image = [UIImage imageNamed:@"palceholder"];
        
    }
    
    if (self.signinHandler.isSignin) {
        self.menuItemArray = [NSArray arrayWithObjects:@"Home",@"Appointment",@"General",@"Settings",@"Tutorials / FAQ",@"Contact us",@"Log out",@"Cash back",nil];
        self.iconArr = [NSArray arrayWithObjects:@"home-1",@"appointments",@"",@"setting1",@"faq-1",@"contact",@"log1",@"cashback", nil];
    }else{
        self.menuItemArray = [NSArray arrayWithObjects:@"Log In",@"Tutorials/FAQ",@"Contact US",nil];
        self.iconArr = [NSArray arrayWithObjects:@"log1",@"faq-1",@"contact", nil];
    }
    
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.menuItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    
    if (self.signinHandler.isSignin) {
        
        if (indexPath.row == 1 || indexPath.row == 6) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }else{
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        }
        
        if (indexPath.row == 2) {
            UITableViewCell *genCell = [tableView dequeueReusableCellWithIdentifier:@"genCell"];
            UILabel *lbl = [cell.contentView viewWithTag:1000];
            lbl.text = [self.menuItemArray objectAtIndex:indexPath.row];
            
            return genCell;
        }
        
    }
    
    cell.titleLbl.text = self.menuItemArray[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:self.iconArr[indexPath.row]];
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.menuDelegate didSelectMenuItem:indexPath];
    
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
