//
//  WXMapAnnotation.h
//  Wheelx
//
//  Created by JG on 12/14/14.
//  Copyright (c) 2014 JG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SMConstants.h"

@interface SMSkateParkAnnotation : NSObject <MKAnnotation>
// Center latitude and longitude of the annotation view.
// The implementation of this property must be KVO compliant.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) PFObject * skatePark;
-(instancetype)initWithCoordinate: (CLLocationCoordinate2D) the_coordinate;

@end
