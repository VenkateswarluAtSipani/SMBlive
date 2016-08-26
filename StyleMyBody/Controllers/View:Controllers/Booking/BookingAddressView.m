//
//  BookingAddressView.m
//  StyleMyBody
//
//  Created by K venkateswarlu on 08/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "BookingAddressView.h"
#import "RestClient.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GooglePlacePicker/GooglePlacePicker.h>

@import GoogleMaps;

@interface BookingAddressView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end

@implementation BookingAddressView{
    RestClient *restClient;
    GMSPlacesClient *_placesClient;
    GMSPlacePicker *_placePicker;
    AddressListModel *localAddressModel;
    
    NSString *latitude;
    NSString *longitude;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    restClient=[[RestClient alloc]init];
    if (self.pageTitle.length>0) {
        _pageTitlelbl.text=_pageTitle;
    }
     _placesClient = [GMSPlacesClient sharedClient];
    
    
    localAddressModel=[[AddressListModel alloc]init];
    //localAddressModel=self.addressListModel;
    tagTxt.text= self.addressListModel.tagName;
    address1Txt.text= self.addressListModel.addressOne;
    address2Txt.text= self.addressListModel.addressTwo;
    cityTxt.text= self.addressListModel.city;
    stateTxt.text= self.addressListModel.state;
    zipTxt.text= self.addressListModel.pincode;
    latitude=self.addressListModel.latitude;
    longitude=self.addressListModel.longitude;

    // Do any additional setup after loading the view.
}
// Add a UIButton in Interface Builder to call this function
- (IBAction)getCurrentPlace:(UIButton *)sender {
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        self.nameLabel.text = @"No current place";
        self.addressLabel.text = @"";
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                self.nameLabel.text = place.name;
                self.addressLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "]
                                          componentsJoinedByString:@"\n"];
            }
        }
    }];
}



// Add a UIButton in Interface Builder to call this function
- (IBAction)pickPlace:(UIButton *)sender {
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(37.788204, -122.411937);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                  center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                  center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
//            self.nameLabel.text = place.name;
//            self.addressLabel.text = [[place.formattedAddress
//                                       componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
            NSArray *addressComponents=[place.formattedAddress componentsSeparatedByString:@", "];
            CLLocationCoordinate2D location=place.coordinate;
            [self getGoogleAdrressFromLatLong:location.latitude lon:location.longitude];
        } else {
            self.nameLabel.text = @"No place selected";
            self.addressLabel.text = @"";
        }
    }];
}

-(void)getGoogleAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    //[self showLoadingView:@"Loading.."];
    
    zipTxt.text =@"";
    stateTxt.text =@"";
    cityTxt.text =@"";
    address2Txt.text=@"";
    address1Txt.text=@"";
    
    NSError *error = nil;
    
    NSString *lookUpString  = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false", lat,lon];
    
    lookUpString = [lookUpString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSData *jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:lookUpString]];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    
    // NSLog(@"%@",jsonDict);
    
    NSArray* jsonResults = [jsonDict objectForKey:@"results"];
    
    if (jsonResults.count>0) {
        NSDictionary *dict=[jsonResults objectAtIndex:0];
        NSArray *addressArray=[dict valueForKey:@"address_components"];
        NSDictionary *geometry=[dict valueForKey:@"geometry"];
        NSDictionary *location=[geometry valueForKey:@"location"];
        latitude=[NSString stringWithFormat:@"%@",[location valueForKey:@"lat"] ];
        longitude=[NSString stringWithFormat:@"%@",[location valueForKey:@"lng"]];
        
        NSMutableArray *address1ComponentsArray=[[NSMutableArray alloc] init];
        NSMutableArray *address2ComponentsArray=[[NSMutableArray alloc] init];
        
        for (NSDictionary *addressComponent in addressArray) {
            
            NSArray *componentTypeArray=[addressComponent valueForKey:@"types"];
            if ([componentTypeArray containsObject:@"postal_code"]) {
                zipTxt.text = [addressComponent valueForKey:@"long_name"];
            }else if ([componentTypeArray containsObject:@"administrative_area_level_1"]) {
                stateTxt.text = [addressComponent valueForKey:@"long_name"];
            }else if ([componentTypeArray containsObject:@"administrative_area_level_2"]) {
                cityTxt.text = [addressComponent valueForKey:@"long_name"];
            }else if ([componentTypeArray containsObject:@"sublocality_level_2"]||[componentTypeArray containsObject:@"sublocality_level_1"]){
                [address2ComponentsArray addObject:[addressComponent valueForKey:@"long_name"]];
                address2Txt.text=[address2ComponentsArray componentsJoinedByString:@", "];
                
            }else if ([componentTypeArray containsObject:@"street_number"]||[componentTypeArray containsObject:@"route"]){
                [address1ComponentsArray addObject:[addressComponent valueForKey:@"long_name"]];
                address1Txt.text=[address1ComponentsArray componentsJoinedByString:@", "];
            }
        }
    }


}

-(IBAction)backBtnAction:(id)sender{
    localAddressModel.addressId=[NSNumber numberWithInt:0];
    [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)saveAddressAction:(id)sender {
    [self.view endEditing:YES];
    if (tagTxt.text.length>0) {
        localAddressModel.tagName=tagTxt.text;
        if (address1Txt.text.length>0) {
            localAddressModel.addressOne=address1Txt.text;
            if (address2Txt.text.length>0) {
                localAddressModel.addressTwo=address2Txt.text;
            }else{
               localAddressModel.addressTwo=@"";
            }
                localAddressModel.addressId=self.addressListModel.addressId;
                localAddressModel.city=cityTxt.text;
                localAddressModel.state=stateTxt.text;
                localAddressModel.pincode=zipTxt.text;
                localAddressModel.latitude=latitude;
                localAddressModel.longitude=longitude;
                
            
            
        }
    }

    
    if (self.addressListModel) {
        
        [restClient UpdaterAddress:localAddressModel callBackRes:^(NSData *data, NSError *error) {
            
           NSDictionary* resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([resDict valueForKey:@"addressId"]) {
                    NSString *addressId=[resDict valueForKey:@"addressId"];
                    localAddressModel.addressId=[NSNumber numberWithInteger:[addressId integerValue]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
          

        }];
    }else{
        [restClient addAddress:localAddressModel callBackRes:^(NSData *data, NSError *error)  {
            NSDictionary* resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (resDict.count) {
                if ([resDict valueForKey:@"addressId"]) {
                    NSString *addressId=[resDict valueForKey:@"addressId"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([addressId integerValue]) {
                            localAddressModel.addressId=[NSNumber numberWithInteger:[addressId integerValue]];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                    });
                    
                    
                }
  
            }
        }];
    }
    
   
}
-(void)viewDidDisappear:(BOOL)animated{
    if ([localAddressModel.addressId integerValue]>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidUpdateAddress" object:localAddressModel.addressId];
    }
   
}
@end
