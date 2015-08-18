//
//  SMPinAnnotation.m
//  Spot Maps
//
//  Created by JG on 4/12/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMPinAnnotation.h"

@implementation SMPinAnnotation

-(instancetype)initWithCoordinate: (CLLocationCoordinate2D) the_coordinate
{
    if (self = [super init])
    {
        _coordinate = the_coordinate;
    }
    return self;
}

@end
