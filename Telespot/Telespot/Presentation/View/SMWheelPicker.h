//
//  SMWheelPicker.h
//  Spot Maps
//
//  Created by JG on 5/10/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMWheelPicker;
@protocol SMWheelPickerDelegate

-(void)wheelPickerConfirmed:(SMWheelPicker*)picker withAnger:(CGFloat)anger;
- (void)wheelPickerAngerChanged:(CGFloat) anger;
@optional

@end

@interface SMWheelPicker : UIView
@property (nonatomic) CGFloat innerRadius;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat intervalAnger;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, strong) UIColor * unselelctedColor;
@property (nonatomic) UIColor *confirmColor;

@property (nonatomic, weak) id<SMWheelPickerDelegate> delegate;
@end
