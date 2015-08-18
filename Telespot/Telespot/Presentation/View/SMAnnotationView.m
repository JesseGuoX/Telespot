//
//  SMAnnotationView.m
//  Spot Maps
//
//  Created by JG on 4/4/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMAnnotationView.h"

@interface SMAnnotationView ()

@property (nonatomic) UILabel *countLabel;

@end

@implementation SMAnnotationView
//@synthesize image;

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpLabel];
        [self setCount:1];
    }
    return self;
}

- (void)setUpLabel
{
    _countLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _countLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.minimumScaleFactor = 2;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    [self addSubview:_countLabel];
}


-(void)setCount:(NSUInteger)count
{
    _count = count;
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    if(self.image == nil)
        self.image = [UIImage imageNamed:@"map_yellow_pin"];
    

    self.countLabel.text = [self suffixNumber:[NSNumber numberWithInteger:self.count]];
    CGRect rect = self.bounds;
    
    
    rect.origin.y -= 7;
    self.countLabel.frame = rect;
    
}

-(NSString*) suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"...";
    
    long long num = [number longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log(num) / log(1000));
    
    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%.0f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}

- (void)drawRect:(CGRect)rect
{
    
}
@end
