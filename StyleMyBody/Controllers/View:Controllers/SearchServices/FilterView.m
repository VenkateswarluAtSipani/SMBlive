//
//  FilterView.m
//  StyleMyBody
//
//  Created by sipani online on 28/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "FilterView.h"
#import "NMRangeSlider.h"
#import "RestClient.h"
#import "CenterViewController.h"
#import "SearchAndFilterModel.h"


@interface FilterView ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    __weak IBOutlet UILabel *startPriceLbl;
    __weak IBOutlet UILabel *endPriceLbl;
    
    NSArray *searchResultArray;
    AutoSearchModel *selectedSearchModel;
    NSInteger selectedGenderTag;
    NSInteger selectedPreferenceTag;
    NSString *rupee;
    RestClient *restClient;
    bool backClicked;
    UITapGestureRecognizer *tap;

}
@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@end

@implementation FilterView

- (void)viewDidLoad {
    [super viewDidLoad];
    backClicked=NO;
    restClient=[[RestClient alloc]init];
    selectedGenderTag=0;
    selectedGenderTag=0;
    rupee=@"\u20B9";
    [self setNotificationsForKeyboard];
    [self configureLabelSlider];
    [self updateSliderLabels];
    [self setCornerRadious];
    [self setInitialFilterValues];
    // Do any additional setup after loading the view.
}
-(void)setCornerRadious{
    maleBtn.layer.cornerRadius=5;
    femaleBtn.layer.cornerRadius=5;
    uniSexBtn.layer.cornerRadius=5;
    
    ratedBtn.layer.cornerRadius=5;
    homeServiceBtn.layer.cornerRadius=5;
    favoriteBtn.layer.cornerRadius=5;
   
}
-(void)setInitialFilterValues{
   
    if (_searchAndFilterModel.search.length>0) {
        selectedSearchModel=[[AutoSearchModel alloc]init];
        selectedSearchModel.centerID=_searchAndFilterModel.Id;
        selectedSearchModel.type=_searchAndFilterModel.type;
        selectedSearchModel.search=_searchAndFilterModel.search;
        _searchBar.text=_searchAndFilterModel.search;
    }
    if (_searchAndFilterModel.serveFor) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([_searchAndFilterModel.serveFor integerValue]==0) {
            btn.tag=1;
            [self sexAction:btn];
        }else if ([_searchAndFilterModel.serveFor integerValue]==1) {
            btn.tag=2;
            [self sexAction:btn];
        }else if ([_searchAndFilterModel.serveFor integerValue]==2) {
            btn.tag=3;
            [self sexAction:btn];
        }
    }
    if (_searchAndFilterModel.preference) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        if ([_searchAndFilterModel.preference integerValue]==0) {
            btn.tag=1;
            [self PreferencesAction:btn];
        }else if ([_searchAndFilterModel.preference integerValue]==1) {
            btn.tag=2;
            [self PreferencesAction:btn];
        }else if ([_searchAndFilterModel.preference integerValue]==2) {
            btn.tag=3;
            [self PreferencesAction:btn];
        }
    }
    
}
-(void)hilightSelectedBtn:(UIButton*)btn{
    btn.layer.borderWidth=2;
    btn.layer.borderColor=[[UIColor colorWithRed:254.0/255.0 green:217.0/255.0 blue:128.0/255.0 alpha:1]CGColor];
    btn.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:240.0/255.0 blue:194.0/255.0 alpha:1];
}
-(void)unSelectedBtn:(UIButton*)btn{
    btn.layer.borderWidth=0;
    btn.layer.borderColor=[[UIColor colorWithRed:254.0/255.0 green:217.0/255.0 blue:128.0/255.0 alpha:1]CGColor];
    btn.backgroundColor=[UIColor whiteColor];
}
-(void)setNotificationsForKeyboard{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(Tapped:)];
    [self.view addGestureRecognizer:tap];
    
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}
-(IBAction)Tapped:(id)sender{
    [self.view endEditing:YES];
}
-(IBAction)keyboardDidShow:(NSNotification*)sender{
    tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(Tapped:)];
    [self.view addGestureRecognizer:tap];
    
    CGRect keyboardFrame = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"keyboard frame raw %@", NSStringFromCGRect(keyboardFrame));
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
    NSLog(@"keyboard frame converted %@", NSStringFromCGRect(keyboardFrameConverted));
    
    _bottomSpaceOfSubmit.constant=keyboardFrameConverted.size.height;
}
-(IBAction)keyboardDidHide:(NSNotification*)sender{
    _bottomSpaceOfSubmit.constant=0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - Label  Slider

- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 10000;
    
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue = 10000;
    
    self.labelSlider.minimumRange = 0;
}
- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    //self.lowerLabel.center = lowerCenter;
    startPriceLbl.text = [NSString stringWithFormat:@"%@ %d",rupee, (int)self.labelSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    // self.upperLabel.center = upperCenter;
    endPriceLbl.text = [NSString stringWithFormat:@"%@ %d",rupee, (int)self.labelSlider.upperValue];
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)backBtnAction:(id)sender{
    backClicked=YES;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sexAction:(id)sender {
    
    [self unSelectedBtn:maleBtn];
    [self unSelectedBtn:femaleBtn];
    [self unSelectedBtn:uniSexBtn];
    
    UIButton *btn=(UIButton*)sender;
    if (selectedGenderTag==btn.tag) {
        selectedGenderTag=0;
    }else{
       selectedGenderTag=btn.tag;
    }
    
    switch (selectedGenderTag) {
        case 1:
            [self hilightSelectedBtn:maleBtn];
            break;
        case 2:
            [self hilightSelectedBtn:femaleBtn];
            break;
        case 3:
            [self hilightSelectedBtn:uniSexBtn];
            break;
        default:
            break;
    }
}
- (IBAction)PreferencesAction:(id)sender{
    [self unSelectedBtn:ratedBtn];
    [self unSelectedBtn:homeServiceBtn];
    [self unSelectedBtn:favoriteBtn];
    
    UIButton *btn=(UIButton*)sender;
    if (selectedPreferenceTag==btn.tag) {
        selectedPreferenceTag=0;
    }else{
        selectedPreferenceTag=btn.tag;
    }
    
    switch (selectedPreferenceTag) {
        case 1:
            [self hilightSelectedBtn:ratedBtn];
            break;
        case 2:
            [self hilightSelectedBtn:homeServiceBtn];
            break;
        case 3:
            [self hilightSelectedBtn:favoriteBtn];
            break;
        default:
            break;
    }
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
    [self filterBtnAction:self];
    
    
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
    if (searchResultArray.count==0) {
        heightOfSearchTbl.constant=0;
        return 0;
    }else{
        heightOfSearchTbl.constant=10;
        return searchResultArray.count;
    }
    
   
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
    AutoSearchModel *searchModel=[searchResultArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ center",searchModel.search];
    UIButton *btn1=[cell viewWithTag:1000];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag=indexPath.row;
    btn.frame=cell.contentView.frame;
    [btn addTarget:self action:@selector(AutoSearchSelected:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn];
    
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    heightOfSearchTbl.constant=tableView.contentSize.height;
    return cell;
}

- (void)getSearcHAPI {
    if ([restClient rechabilityCheck]) {
        [restClient getAutoSearch:_searchAndFilterModel.categoryId isFev:self.searchBar.text callBackRes:^(NSArray *autoSearchArr, NSError *error) {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                searchResultArray=autoSearchArr;
                [self.searchResultTbl reloadData];
            });
            
        }];
    }
}
-(IBAction)AutoSearchSelected:(id)sender{
    UIButton *btn=(UIButton*)sender;
    AutoSearchModel *searchModel=[searchResultArray objectAtIndex:btn.tag];
    _searchBar.text=[NSString stringWithFormat:@"%@",searchModel.search];
    selectedSearchModel=searchModel;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)filterBtnAction:(id)sender {
    
    if (selectedGenderTag) {
        _searchAndFilterModel.serveFor=[NSNumber numberWithInteger:selectedGenderTag-1];
    }else{
        _searchAndFilterModel.serveFor=nil;
    }
    
    if (selectedPreferenceTag) {
        _searchAndFilterModel.preference=[NSNumber numberWithInteger:selectedPreferenceTag-1];
    }else{
        _searchAndFilterModel.preference=nil;
    }
    
    
    NSString *start=[startPriceLbl.text stringByReplacingOccurrencesOfString:rupee withString:@""];
    NSString *end=[endPriceLbl.text stringByReplacingOccurrencesOfString:rupee withString:@""];
    
    _searchAndFilterModel.minPrice=[NSNumber numberWithInteger:[start integerValue]];
    _searchAndFilterModel.maxPrice=[NSNumber numberWithInteger:[end integerValue]];
    
    if (_searchBar.text.length>0) {
        _searchAndFilterModel.Id=selectedSearchModel.centerID;
        _searchAndFilterModel.search=selectedSearchModel.search;
        _searchAndFilterModel.type=selectedSearchModel.type;
    }else{
        _searchAndFilterModel.Id=[NSNumber numberWithInt:0];
        _searchAndFilterModel.search=@"";
        _searchAndFilterModel.type=[NSNumber numberWithInt:0];
    }

//    _searchAndFilterModel.serveFor=selectedSearchModel.serveFor;
//    _searchAndFilterModel.preference=selectedSearchModel.preference;
//    _searchAndFilterModel.minPrice=selectedSearchModel.minPrice;
//    _searchAndFilterModel.maxPrice=selectedSearchModel.maxPrice;
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (!backClicked) {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchModified" object:_searchAndFilterModel];
    }
   
    
}
@end
