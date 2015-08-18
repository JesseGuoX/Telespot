//
//  SMPinView.h
//  Spot Maps
//
//  Created by JG on 5/10/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMWheelPicker.h"
#import "AppMacros.h"

@class SMPinView;

@protocol SMPinViewDelegate

- (void)pinViewCancelButtonPressed:(SMPinView *)view;

@end

@interface SMPinView : UIView
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewToTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewToBottomConstraint;
@property (nonatomic) NSInteger stayTime;
@property (nonatomic, strong) NSString *bigMessage ;
@property (nonatomic, strong) NSString *litterMessage;
@property (nonatomic) BOOL locatorPostive;
@property (weak, nonatomic) id <SMPinViewDelegate>delegate;
@end

