//
//  SMPinCardView.m
//  Spot Maps
//
//  Created by JG on 4/7/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMPinCardView.h"
#import "TTRangeSlider.h"
@interface SMPinCardView()
@property (strong, nonatomic)  TTRangeSlider *rangeSlider;
@end

@implementation SMPinCardView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.rangeSlider = [[TTRangeSlider alloc] initWithFrame:CGRectMake(10, 200, 200, 30)];
    self.rangeSlider.minValue = 20 ;
    self.rangeSlider.maxValue = 240 ;
    self.rangeSlider.disableRange = YES;
    [self addSubview:self.rangeSlider];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
