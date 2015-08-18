//
//  UIIndicatorButton.m
//  Spot Maps
//
//  Created by JG on 6/20/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "UIIndicatorButton.h"
#import <Masonry.h>
#import "AppMacros.h"

@implementation UIIndicatorButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        [self addSubview:self.activityIndicatorView];
    }

    return self;
}




- (void)layoutSubviews
{
    WS(ws);
    [super layoutSubviews];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.titleLabel.mas_left).offset(-10);
        make.centerY.mas_equalTo(ws.mas_centerY);
    }];
    [self.activityIndicatorView layoutIfNeeded];
}


-(void)didAddSubview:(UIView *)subview
{
    
}

-(void)drawRect:(CGRect)rect
{
    
}

@end
