//
//  ContactUsViewController.m
//  StyleMyBody
//
//  Created by sipani online on 25/06/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "ContactUsViewController.h"
#import "AppointmentsViewController.h"
#import "MenuViewController.h"
#import "SignInDetailHandler.h"
#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "ContactUsModel.h"
#import "RestClient.h"
#import "ResponseParser.h"
#import "CategoryCell.h"

@interface ContactUsViewController ()<MenuSelectDelegate,UITableViewDelegate,UITableViewDataSource>
{
    RestClient *restClient;
    ContactUsModel*contactUsModel;
    CategoryCell*cell;
    NSArray *categoryArray;
    NSDictionary*selectedCategoryDict;
    
}

@property (nonatomic, assign) BOOL isMenuOPen;
@property (nonatomic, weak) IBOutlet UIView *menuContainerView;
@property (nonatomic, weak) IBOutlet UIView *layerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *menuConstaraint;
@property (nonatomic, strong) MenuViewController *menuController;
@property (nonatomic, strong) SignInDetailHandler *signInHandler;
@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryView.hidden=YES;
    self.categoryBackView.hidden=YES;
    
    
    restClient=[[RestClient alloc]init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    
    if ([restClient rechabilityCheck]) {
    [restClient getContactUsDetails:^(ContactUsModel *contactUsList, NSError *error){
        [self.tollFreeNo setTitle:contactUsList.tollFreeNumber forState:UIControlStateNormal];
        [self.phoneNo setTitle:contactUsList.phoneNumber forState:UIControlStateNormal];
        [self.mailIdBtn setTitle:contactUsList.emailAddress forState:UIControlStateNormal];
        dispatch_async(dispatch_get_main_queue(), ^{
            categoryArray=contactUsList.subjectsArray;
        [self.tblView reloadData];
        
        });
    }];
    }
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnGesture:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:recognizer];

    
    // Do any additional setup after loading the view.
}
- (void)callLogOutFunctionality {
    
    self.signInHandler.isSignin = NO;
    //    if (self.signInHandler.isSignin) {
    //    }
    //    [self animateLeftMenu];
    //    [self performSelector:@selector(animateLeftMenu) withObject:nil afterDelay:0.1];
    
    self.signInHandler.loginResModel = nil;
    self.signInHandler.accessToken = nil;
    self.signInHandler.userId = nil;
    [self performSelector:@selector(reloadLeftMenu) withObject:nil afterDelay:1.0];
    //
    
    
    
    //    [RestClient logout:[NSNumber numberWithInt:1] callBackHandler:^(NSDictionary *res, NSError *error) {
    //        [self animateLeftMenu];
    //        [self callGetCategoryList];
    //    }];
}
- (void)reloadLeftMenu {
    [self.menuController reloadData];
    
}
- (IBAction)clickOnLeftMenu:(id)sender {
    [self animateLeftMenu];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MenuLeftVC"]) {
        self.menuController = segue.destinationViewController;
        self.menuController.menuDelegate = self;
    }
}
- (IBAction)tapOnGesture:(id)sender;{
    [self animateLeftMenu];
}

- (void)animateLeftMenu {
    [self.view layoutIfNeeded];
    float layerAlphaVal ;
    if (self.isMenuOPen) {
        self.menuConstaraint.constant = -290;
        layerAlphaVal = 0;
    }else{
        self.menuConstaraint.constant = 0;
        layerAlphaVal = 0.7f;
    }
    
    self.isMenuOPen = !self.isMenuOPen;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.layerView.alpha = layerAlphaVal;
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

- (void)didSelectMenuItem:(NSIndexPath *)indexPath {
//    [self animateLeftMenu];
//    if (self.signInHandler.isSignin) {
//        if (indexPath.row == 6) {
//            [self callLogOutFunctionality];
//        }else if (indexPath.row ==1){
//            AppointmentsViewController *appointmentsView= [self.storyboard instantiateViewControllerWithIdentifier:@"appointments"];
//            [self.navigationController pushViewController:appointmentsView animated:YES];
//        }else if (indexPath.row ==2){
//            
//        }else if (indexPath.row==3){
//            SettingsViewController *settingsViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
//            [self.navigationController pushViewController:settingsViewController animated:YES];
//            
//        }else if (indexPath.row==4){
//            
//        }else if (indexPath.row==5){
//            ContactUsViewController *contactUsViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
//            [self.navigationController pushViewController:contactUsViewController animated:YES];
//            
//        }
//    }else{
//        if (indexPath.row == 0) {
//            
//            LoginViewController *loginViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
//            [self.navigationController pushViewController:loginViewController animated:YES];
//                                  
//        }else if (indexPath.row ==1){
//            
//        }else if (indexPath.row ==2){
//            ContactUsViewController *contactUsViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
//            [self.navigationController pushViewController:contactUsViewController animated:YES];
//        }
//    }
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return categoryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell=[tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
//  categoryArray=[contactUsModel.subjectsArray objectAtIndex:indexPath.row];
    NSDictionary*categoryDict=[categoryArray objectAtIndex:indexPath.row];
    NSString*subjectStr=[categoryDict valueForKey:@"subject"];
 [cell.categoryBtn setTitle:subjectStr forState:UIControlStateNormal];


//    [btnProblem setTitle:[btnLabels[indexPath.section] forState:UIControlStateNormal
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedCategoryDict=[categoryArray objectAtIndex:indexPath.row];
    NSString*subjectStr=[selectedCategoryDict valueForKey:@"subject"];
    
}


- (IBAction)selceCategoryBtn:(UIButton *)sender {
    self.categoryView.hidden=NO;
    self.categoryBackView.hidden=NO;
    }

- (IBAction)clickCancel:(id)sender {
    self.categoryView.hidden=YES;
    self.categoryBackView.hidden=YES;
    
}

- (IBAction)clickSelect:(id)sender {
//    [self.categoryBtn setTitle:subjectStr forState:UIControlStateNormal];
    self.categoryView.hidden=YES;
    self.categoryBackView.hidden=YES;
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
