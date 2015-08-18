//
//  SMWheelPicker.m
//  Spot Maps
//
//  Created by JG on 5/10/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMWheelPicker.h"
#import "Categories.h"

@interface SMWheelPicker()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;
@property (nonatomic) CGFloat touchAnger;
@property (nonatomic) CGPoint selfCenter;

@property (nonatomic) BOOL isInConfirmButton;

@end


@implementation SMWheelPicker

- (id)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        [self addGestureRecognizer:self.panGesture];
        self.selfCenter = CGPointMake(frame.size.width /2, frame.size.height /2);
        
        if(self.intervalAnger == 0)
            self.intervalAnger = 5;
        if(self.innerRadius == 0)
            self.innerRadius = 20;
        if(self.radius == 0)
            self.radius = 25;
        if(!self.selectedColor)
            self.selectedColor = [UIColor redColor];
        if(!self.unselelctedColor)
            self.unselelctedColor = [UIColor whiteColor];
        
        self.confirmButton = [SlowHighlightIcon buttonWithType:UIButtonTypeCustom];
        self.confirmButton.backgroundColor = [UIColor lightGrayColor];
        [self.confirmButton setBackgroundImage:[[UIColor whiteColor] image] forState:UIControlStateHighlighted];
        self.confirmButton.frame = CGRectMake(0, 0, 2*40, 2*40);
//        self.confirmButton.userInteractionEnabled = NO;
        //self.confirmButton.layer.borderWidth = LINE_SIZE;
        //self.confirmButton.layer.borderColor = tcolor(TextColor).CGColor;
        self.confirmButton.center = self.selfCenter;
        [self.confirmButton addTarget:self action:@selector(pressedConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
        //[self.confirmButton setImage:[UIImage imageNamed:@"done-selected"] forState:];
        [self.confirmButton setImage:[UIImage imageNamed:@"pin_chooser_circle"] forState:UIControlStateNormal];
        [self.confirmButton setImage:[UIImage imageNamed:@"pin_chooser"] forState:UIControlStateHighlighted];
        self.confirmButton.layer.masksToBounds = YES;
        self.confirmButton.layer.cornerRadius = self.confirmButton.frame.size.width/2;
        [self addSubview:self.confirmButton];
    }
    return self;
}




- (void)setInnerRadius:(CGFloat)innerRadius
{
    _innerRadius = innerRadius;
    self.confirmButton.frame = CGRectMake(0, 0, 2*innerRadius -5 , 2*innerRadius - 5);
    self.confirmButton.center = self.selfCenter;
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.layer.cornerRadius = self.confirmButton.frame.size.width/2;

    [self setNeedsDisplay];
}

- (void)setConfirmColor:(UIColor *)confirmColor
{
    [self.confirmButton setBackgroundImage:[confirmColor image] forState:UIControlStateHighlighted];
    [self setNeedsDisplay];


}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code


    CGPoint aPoints[2];//坐标点

    for (int i = -90; i < 270; i+=self.intervalAnger) {
    
    
    CGPoint xx = CGPointMake(self.selfCenter.x + self.radius * cos(i * M_PI /180), self.selfCenter.y + self.radius * sin(i * M_PI /180));
    CGPoint innerXX =CGPointMake(self.selfCenter.x + self.innerRadius * cos(i * M_PI /180), self.selfCenter.y + self.innerRadius * sin(i * M_PI /180));
        
    aPoints[0] = innerXX;//坐标1
    aPoints[1] =xx;//坐标2

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //指定直线样式

    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,4);
        
    CGFloat realAnger = i + 90;
        
    if(realAnger < self.touchAnger)
        CGContextSetStrokeColorWithColor(context, self.selectedColor.CGColor);
    else
    //设置颜色
    CGContextSetStrokeColorWithColor(context, self.unselelctedColor.CGColor);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,aPoints[0].x, aPoints[0].y);
    //下一点
    CGContextAddLineToPoint(context,aPoints[1].x, aPoints[1].y);
    //绘制完成
    CGContextStrokePath(context);
    }

}
#define distanceBetween(p1,p2) sqrt(pow((p2.x-p1.x),2) + pow((p2.y-p1.y),2))

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
//    CGPoint velocity = [sender velocityInView:self];
    CGPoint location = [sender locationInView:self];

    if(sender.state == UIGestureRecognizerStateBegan)
    {
        CGFloat distanceToMiddle = distanceBetween(self.selfCenter, location);
        self.isInConfirmButton = (distanceToMiddle < self.innerRadius);
    }else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGFloat anger = [self angleBetweenCenterPoint:self.selfCenter point1:location point2:CGPointMake(self.selfCenter.x, self.selfCenter.y -100) ];
        CGFloat rac = anger /M_PI*180;
        if(rac < 0)
            self.touchAnger = rac + 360;
        else
            self.touchAnger = rac;
        NSLog(@"%f", rac);
        CGFloat distanceToMiddle = distanceBetween(self.selfCenter, location);
        self.isInConfirmButton = (distanceToMiddle < self.innerRadius);
        [self.delegate wheelPickerAngerChanged:self.touchAnger];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {

        self.confirmButton.highlighted = NO;
        if(self.isInConfirmButton){
//            [self.delegate wheelPickerConfirmed:self withAnger:self.touchAnger];
        }
    }

    [self setNeedsDisplay];
}

-(CGFloat)angleBetweenCenterPoint:(CGPoint)centerPoint point1:(CGPoint)p1 point2:(CGPoint)p2{
    CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
    CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
    
    CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
    
    return angle;
}

-(void)pressedConfirmButton:(UIButton*)sender{
    [self.delegate wheelPickerConfirmed:self withAnger:self.touchAnger];
}

-(void)setIsInConfirmButton:(BOOL)isInConfirmButton{
    if(_isInConfirmButton != isInConfirmButton){
        _isInConfirmButton = isInConfirmButton;
        if(_isInConfirmButton){
            [self performSelector:@selector(didWaitDelay) withObject:nil afterDelay:0.2];
        }
        else [self didWaitDelay];
    }
}
//-(void)setIsOutOfScope:(BOOL)isOutOfScope{
//    if(_isOutOfScope != isOutOfScope){
//        _isOutOfScope = isOutOfScope;
//        if(isOutOfScope){
//            [self performSelector:@selector(didWaitInMiddle) withObject:nil afterDelay:kGlowMiddleShowHack];
//        }
//    }
//}
-(void)didWaitInMiddle{
//    if(self.isOutOfScope){
        self.confirmButton.highlighted = YES;
//    }
}
-(void)didWaitDelay{
    self.confirmButton.highlighted = self.isInConfirmButton;
}
@end
