//
//  ServiceViewController.m
//  StyleMyBody
//
//  Created by sipani online on 5/2/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "ServiceViewController.h"
#import "RestClient.h"
#import "AllFoldersResModel.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "ServiceResModel.h"
#import "FolderHeaderCell.h"
#import "FolderServiceCell.h"

@interface ServiceViewController ()<UITableViewDelegate,UITableViewDataSource,FolderHeaderDelegate>
{
    BOOL isNotMappedExpanded;
    RestClient *restClient;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AllFoldersResModel *allFolderModel;;

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 1000;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    [self callGetServiceList];
    // Do any additional setup after loading the view.
}

- (void)callGetServiceList {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
if ([restClient rechabilityCheck]) {
    [restClient getAllFoldersList:self.centerId callBackRes:^(AllFoldersResModel *foldersResModel, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{

        self.allFolderModel = foldersResModel;
        [self.tableView reloadData];
        [hud hideAnimated:YES];
        });

    }];
}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = 0;
    
    section = self.allFolderModel.foldersModelArr.count;
    
    if (self.allFolderModel.notMappedServicesArr.count > 0) {
        
        section += 1;
    }
    
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows;
    
    if (self.allFolderModel.foldersModelArr.count == section) {
        if (isNotMappedExpanded) {
            rows = self.allFolderModel.notMappedServicesArr.count;
        }else{
            rows = 0;
        }
    }else{
        FolderResModel *folderService = self.allFolderModel.foldersModelArr[section];
        if (folderService.isFolderEpanded) {
            rows = folderService.servicesArr.count;
        }else{
            rows = 0;
        }
    }

    return rows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 64;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   //
{
    FolderHeaderCell *cell = (FolderHeaderCell *) [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];

    if (self.allFolderModel.foldersModelArr.count == section) {
        cell.titleLbl.text = @"Other Services";
    }else{
        FolderResModel *folderService = self.allFolderModel.foldersModelArr[section];
        cell.titleLbl.text = folderService.folderName;
    }
    cell.delegate = self;
    cell.cellId = section;
    
    
    if (self.allFolderModel.foldersModelArr.count == section) {
        if (isNotMappedExpanded) {
            cell.folderMarkImgView.image = [UIImage imageNamed:@"uparrow"];
        }else{
            cell.folderMarkImgView.image = [UIImage imageNamed:@"downarrow"];
        }
    }else{
        FolderResModel *folderService = self.allFolderModel.foldersModelArr[section];
        if (folderService.isFolderEpanded) {
            cell.folderMarkImgView.image = [UIImage imageNamed:@"uparrow"];
        }else{
            cell.folderMarkImgView.image = [UIImage imageNamed:@"downarrow"];
        }
    }

//    cell.backgroundColor = [UIColor redColor];

    return cell;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  
    FolderServiceCell *cell = (FolderServiceCell *)[tableView dequeueReusableCellWithIdentifier:@"ServiceCell"];

    if (self.allFolderModel.foldersModelArr.count == indexPath.section) {
        ServiceResModel *serviceModel = self.allFolderModel.notMappedServicesArr[indexPath.row];
        cell.titleLbl.text = serviceModel.name;
        cell.timeLbl.text = [NSString stringWithFormat:@"%@ mins",[serviceModel.time stringValue]];
        NSString *rupee = @"\u20B9";
        cell.priceLbl.text = [NSString stringWithFormat:@"%@ %@",rupee,[serviceModel.price stringValue]];
        cell.onwardsLbl.text = @"Onwards" ;
        if (serviceModel.image.length>0) {
            [RestClient loadImageinImgView:cell.serviceImgView withUrlString:serviceModel.image];
            cell.serviceImgViewHeight.constant=150;
        }else{
            cell.serviceImgViewHeight.constant=0;
        }
        

        
    }else{

        FolderResModel *folderService = self.allFolderModel.foldersModelArr[indexPath.section];
        
        ServiceResModel *serviceModel = folderService.servicesArr[indexPath.row];
        cell.titleLbl.text = serviceModel.name;
        cell.timeLbl.text =  [NSString stringWithFormat:@"%@ mins",[serviceModel.time stringValue]];
        NSString *rupee = @"\u20B9";
        cell.priceLbl.text = [NSString stringWithFormat:@"%@ %@",rupee,[serviceModel.price stringValue]];
        cell.onwardsLbl.text = @"Onwards"
        ;
        
        if (serviceModel.image.length>0) {
            [RestClient loadImageinImgView:cell.serviceImgView withUrlString:serviceModel.image];
            cell.serviceImgViewHeight.constant=150;
        }else{
            cell.serviceImgViewHeight.constant=0;
        }


    }
   
//    ServiceResModel *model = folderService.servicesArr[indexPath.row];
    
    
//    
//    OffersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.titleLbl.text = model.title;
//    cell.distanceLbl.text =  [Utility getDistanceFromLocations:appDelegate.currentLocation :[[CLLocation alloc]initWithLatitude:[model.centerLatitude doubleValue] longitude:[model.centerLongitude doubleValue]] ];
//    cell.discountTitleLbl.text = model.descriptionOffer;
//    cell.expiryLbl.text = [NSString stringWithFormat:@"Expires on %@",[Utility getDateWithSpecificFormat:model.createdAt format:nil]];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSURL *url = [NSURL URLWithString:model.image];
//    
//    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (data) {
//            UIImage *image = [UIImage imageWithData:data];
//            if (image) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    OffersCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
//                    if (updateCell)
//                        updateCell.imgView.image = image;
//                });
//            }
//        }
//    }] ;
//    [task resume];
    
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceResModel *serviceModel;
    if (self.allFolderModel.foldersModelArr.count == indexPath.section) {
        serviceModel = self.allFolderModel.notMappedServicesArr[indexPath.row];
    }else{
        FolderResModel *folderService = self.allFolderModel.foldersModelArr[indexPath.section];
        serviceModel = folderService.servicesArr[indexPath.row];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:serviceModel,@"serviceModel",@"service",@"FromView", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSelectServiceCell" object:dict];
    
}


- (void)didSeletedView:(NSInteger)cellId {
    if (self.allFolderModel.foldersModelArr.count == cellId) {
        isNotMappedExpanded = !isNotMappedExpanded;
    }else{
        FolderResModel *folderService = self.allFolderModel.foldersModelArr[cellId];
        folderService.isFolderEpanded = !folderService.isFolderEpanded;
    }

    [self.tableView reloadData];
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
