//
//  SMImageThumbView.h
//  Spot Maps
//
//  Created by JG on 4/19/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMImageThumbViewDelegate;

@interface SMImageThumbView : UIView

@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) id<SMImageThumbViewDelegate>delegate;

@end

@protocol SMImageThumbViewDelegate <NSObject>

-(void)touchedOnThumbView:(SMImageThumbView *)view inDeleteArea:(BOOL)isin;


@end