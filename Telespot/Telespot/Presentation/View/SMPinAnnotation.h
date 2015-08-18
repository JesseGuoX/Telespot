//
//  SMPinAnnotation.h
//  Spot Maps
//
//  Created by JG on 4/12/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SMConstants.h"
@interface SMPinAnnotation : NSObject<MKAnnotation>

@property (nonatomic, strong) PFObject * pin;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(instancetype)initWithCoordinate: (CLLocationCoordinate2D) the_coordinate;
@end
