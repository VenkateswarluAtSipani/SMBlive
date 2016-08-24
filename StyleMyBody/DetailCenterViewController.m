//
//  DetailCenterViewController.m
//  StyleMyBody
//
//  Created by sipani online on 5/2/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "DetailCenterViewController.h"
#import "CAPSPageMenu.h"
#import "DetailViewController.h"
#import "ServiceViewController.h"
#import "StyleListViewController.h"
#import "ReviewsViewController.h"
#import "OfferCenterViewController.h"
#import "OfferDetailViewController.h"
#import "SignInDetailHandler.h"
#import "AllStylistAndServicesInGroupViewController.h"
#import "SignViewController.h"
#import "OfferFullDetailsViewController.h"

@interface DetailCenterViewController ()

@property (nonatomic) CAPSPageMenu *pageMenu;
@property (nonatomic) DetailViewController *detailController;
@property (nonatomic) ServiceViewController *serviceController;
@property (nonatomic) StyleListViewController *stylelistController;
@property (nonatomic) ReviewsViewController *reviewController;
@property (nonatomic) OfferCenterViewController *offerController;

@end

@implementation DetailCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
 
    
    
}
-(void)setUpDetailPages{
    self.headerTitleLbl.font = [UIFont fontWithName:@"Pacifico" size:24];
    
    
    self.detailController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"detail"];
    self.detailController.title = @"DETAILS";
    self.detailController.centerSubmodel = self.selectedCenterItemModel;
    //    nearByController.categoryModel = self.categoryModel;
    
    self.serviceController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"service"];
    self.serviceController.title = @"SERVICES";
    self.serviceController.centerId = self.selectedCenterItemModel.centerId;
    //    nearByController.categoryModel = self.categoryModel;
    
    self.offerController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"OffersVC"];
    self.offerController.title = @"OFFERS";
    self.offerController.isBookNowNeeded=YES;
    self.offerController.centerId=self.selectedCenterItemModel.centerId;
    //    nearByController.categoryModel = self.categoryModel;
    
    self.stylelistController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"styleList"];
    self.stylelistController.centerId = self.selectedCenterItemModel.centerId;
    self.stylelistController.ParentView=self;
    self.stylelistController.title = @"STYLISTS";
    
    self.reviewController = [self.storyboard                                                                 instantiateViewControllerWithIdentifier: @"review"];
    self.reviewController.centerId = self.selectedCenterItemModel.centerId;
    self.reviewController.title = @"REVIEWS";
    
    
    NSArray *controllerArray = @[self.detailController, self.serviceController,self.offerController, self.stylelistController,self.reviewController];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:255.0/255.0 green:105.0/255.0 blue:66.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithRed:232.0/255.0 green:223.0/255.0 blue:23.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:238.0/255.0 green:241.0/255.0 blue:246.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @((self.view.bounds.size.width/controllerArray.count)),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [self.view addSubview:_pageMenu.view];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpDetailPages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectBookNow) name:@"DidSelectBookNow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCell:) name:@"DidSelectServiceCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OfferSelected:) name:@"OfferSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PleaseLoginFromDetailCenterViewController:) name:@"PleaseLoginFromDetailCenterViewController" object:nil];
       self.headerTitleLbl.text = self.selectedCenterItemModel.displayName;
    
}
-(IBAction)PleaseLoginFromDetailCenterViewController:(id)sender{
    SignInDetailHandler *dataHandler = [SignInDetailHandler sharedInstance];
    
    if (dataHandler.isSignin == YES) {
    }else{
        
        SignViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SIgnVC"];
        vc.viewFrom = FromOther;
        NSLog(@"%lu",(unsigned long)vc.viewFrom);
        [self.navigationController pushViewController:vc animated:NO];
    }
}
-(void)OfferSelected:(NSNotification *)sender{
    NSDictionary *dict = sender.object;
    [self performSegueWithIdentifier:@"offerFullDetails" sender:dict];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)popToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectCell:(NSNotification *)sender {
    //    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:indexPath,@"indexPath",@"NearBy",@"FromView", nil];
    
    
    NSDictionary *dict = sender.object;
    if ([dict[@"FromView"] isEqual:@"service"]) {
        OfferDetailViewController *detailCenterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"serviceDetailVC"];
        detailCenterVC.serviceModel = dict[@"serviceModel"];
        [self.navigationController pushViewController:detailCenterVC animated:YES];
    }
    
    //    [self performSegueWithIdentifier:@"detailCenter" sender:dict];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *dict = sender;
    if ([dict[@"FromView"] isEqual:@"service"]) {
        OfferDetailViewController *detailCenterVC = segue.destinationViewController;
        detailCenterVC.serviceModel = dict[@"serviceModel"];
    }else if ([dict[@"FromView"] isEqual:@"OfferView"]){
        OfferFullDetailsViewController *detailCenterVC = segue.destinationViewController;
        detailCenterVC.offerId=[dict valueForKey:@"offerId"];
        detailCenterVC.offerType=[dict valueForKey:@"offerType"];
        detailCenterVC.centerId=self.selectedCenterItemModel.centerId;
        // NSLog(@"%@",detailCenterVC.selectedCenterItemModel.displayName);
    }
}

- (void)didSelectBookNow {
    SignInDetailHandler *dataHandler = [SignInDetailHandler sharedInstance];
    
    if (dataHandler.isSignin == YES) {
        
        AllStylistAndServicesInGroupViewController *serviceVC = (AllStylistAndServicesInGroupViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AllStylistAndServicesInGroupViewController"];
        //        CenterListResModel *model = [self.nearByController.nearByCenterListModel objectAtIndex:indexPath.row];
        serviceVC.headerTitle = self.selectedCenterItemModel.displayName;
        serviceVC.centerId = self.selectedCenterItemModel.centerId;
        [self.navigationController pushViewController:serviceVC animated:YES];
        
    }else{
        
        SignViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SIgnVC"];
        vc.viewFrom = FromOther;
        [self.navigationController pushViewController:vc animated:NO];
    }
    
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
