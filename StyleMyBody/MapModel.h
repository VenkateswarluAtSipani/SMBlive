//
//  MapModel.h
//  StyleMyBody
//
//  Created by sipani online on 6/23/16.
//  Copyright © 2016 Sipani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MapModel : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end
