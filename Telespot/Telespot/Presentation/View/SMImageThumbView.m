//
//  SMImageThumbView.m
//  Spot Maps
//
//  Created by JG on 4/19/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMImageThumbView.h"
@interface SMImageThumbView()
//@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UITapGestureRecognizer * tapReco;
@property (nonatomic, strong) UIButton * deleteButton;
@end

@implementation SMImageThumbView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
//        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        [self addSubview:self.imageView];
        self.tapReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignalTap:)];
        [self addGestureRecognizer:self.tapReco];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"thumb_clear"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteButton];

    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGSize imageSize = self.image.size;
    CGSize viewSize = self.frame.size; // size in which you want to draw
    
    float hfactor = imageSize.width / viewSize.width;
    float vfactor = imageSize.height / viewSize.height;
    
    float factor = fmin(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = imageSize.width / factor;
    float newHeight = imageSize.height / factor;
    
    CGRect newRect = CGRectMake(0,0, newWidth, newHeight);
    [self.image drawInRect:newRect];
    
//    [self.image drawInRect:rect];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.deleteButton setFrame:CGRectMake(self.frame.size.width *2/3, 0, self.frame.size.width / 3, self.frame.size.width / 3)];

}


-(void)setImage:(UIImage *)image
{
    _image = image;
//    self.imageView.image = _image;
    [self setNeedsDisplay];
}

-(void)handleSignalTap:(UITapGestureRecognizer *)recognizer
{
    [self.delegate touchedOnThumbView:self inDeleteArea:NO];
}

-(void)deleteButtonPressed
{
    [self.delegate touchedOnThumbView:self inDeleteArea:YES];

}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint location = [touch locationInView:touch.view];
//}



@end
