//
//  UpcomeingAppointmentCell.m
//  StyleMyBody
//
//  Created by sipani online on 20/07/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import "UpcomeingAppointmentCell.h"
#import "AppointmentsHistoryModel.h"
#import "MapModel.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@implementation UpcomeingAppointmentCell{
    AppointmentsHistoryModel *appointmentModel;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)locationBTNaction:(id)sender {
    
    CLLocationCoordinate2D logCord = CLLocationCoordinate2DMake([appointmentModel.centerLatitude doubleValue], [appointmentModel.centerLongitude doubleValue]);
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:logCord addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = appointmentModel.centerAddress;
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [item openInMapsWithLaunchOptions:options];
    

}
@end
