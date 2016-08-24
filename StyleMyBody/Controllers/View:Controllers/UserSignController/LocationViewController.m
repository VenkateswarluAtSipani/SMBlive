//
//  LocationViewController.m
//  StyleMyBody
//
//  Created by sipani online on 20/05/16.
//  Copyright © 2016 Sipani. All rights reserved.
//
 
#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationViewController ()<CLLocationManagerDelegate,UISearchBarDelegate,UITableViewDataSource,UIScrollViewDelegate,UITableViewDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *locationArr;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerLbl.font = [UIFont fontWithName:@"Pacifico" size:18];
    self.activity.hidden=YES;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    //------------For GPS Location
    
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    //------------End GPS Location------------//
    
    // Do any additional setup after loading the view.

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.locationArr[indexPath.row];
    cell.selectionStyle=UITableViewCellEditingStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.locationArr[indexPath.row],@"locationName", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSelectLocation" object:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = locations.lastObject;
    CLLocation *oldLocation;
    if (locations.count > 1) {
        oldLocation = locations[locations.count - 2];
    }
    
    NSLog(@"New: %@,Old: %@",newLocation,oldLocation);
    
    [geocoder reverseGeocodeLocation: newLocation completionHandler: ^(NSArray *placemarks, NSError *error) {
        //do something
        
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        // Long address
        // NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        // Short address
        
        
        NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
        NSString *addressString = [lines componentsJoinedByString:@","];
        
        
        
        //  NSString *locatedAt = [placemark subLocality];
        
        NSLog(@"%@",addressString);
        //        [locationBtn setTitle:addressString forState:UIControlStateNormal];
        
    }];
    [locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchCoordinatesForAddress:searchBar.text];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void) searchCoordinatesForAddress:(NSString *)inAddress
{
    //Build the string to Query Google Maps.
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",inAddress];
    
    //Replace Spaces with a '+' character.
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    //Create NSURL string from a formate URL string.
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask  = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *err;
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        self.locationArr = [NSMutableArray array];
        NSArray *resArr = resDict[@"results"];
        for (NSDictionary *dict in resArr) {
            [self.locationArr addObject:dict[@"formatted_address"]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    }];
    [dataTask resume];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backTomainVC:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)locationSymbolAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.activity.hidden=NO;
    [self.activity startAnimating];
    
}

- (IBAction)autoDetectLocation:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.activity.hidden=NO;
    [self.activity startAnimating];
}
@end
