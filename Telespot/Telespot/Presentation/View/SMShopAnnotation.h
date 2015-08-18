//
//  SMShopAnnotation.h
//  Spot Maps
//
//  Created by JG on 5/26/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SMConstants.h"
@interface SMShopAnnotation : NSObject<MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) PFObject * shop;
-(instancetype)initWithCoordinate: (CLLocationCoordinate2D) the_coordinate;
@end
