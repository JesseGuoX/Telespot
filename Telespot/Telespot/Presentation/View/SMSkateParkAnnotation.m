//
//  WXMapAnnotation.m
//  Wheelx
//
//  Created by JG on 12/14/14.
//  Copyright (c) 2014 JG. All rights reserved.
//

#import "SMSkateParkAnnotation.h"

@implementation SMSkateParkAnnotation


-(instancetype)initWithCoordinate: (CLLocationCoordinate2D) the_coordinate
{
    if (self = [super init])
    {
        _coordinate = the_coordinate;
    }
    return self;
}


@end
