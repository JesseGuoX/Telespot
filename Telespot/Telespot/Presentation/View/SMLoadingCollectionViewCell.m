//
//  SMLoadingCollectionViewCell.m
//  Spot Maps
//
//  Created by JG on 4/16/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMLoadingCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface SMLoadingCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SMLoadingCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = 1.1; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [self.imageView.layer addAnimation:rotation forKey:@"Spin"];
}

@end
