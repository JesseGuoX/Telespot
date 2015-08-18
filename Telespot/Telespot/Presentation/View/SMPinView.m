//
//  SMPinView.m
//  Spot Maps
//
//  Created by JG on 5/10/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMPinView.h"
@interface SMPinView()
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *clockLabel;
@property (strong, nonatomic) IBOutlet UILabel *stayLabel;

@end
@implementation SMPinView

-(void)awakeFromNib
{
    [super awakeFromNib];

    
    self.clockLabel.backgroundColor = [UIColor clearColor];
    self.clockLabel.textColor = kDefConfirmColor; //self.foregroundColor;
    self.clockLabel.font = kClockLabelFont;
    self.clockLabel.textAlignment = NSTextAlignmentCenter;
    
    self.stayLabel.backgroundColor = [UIColor clearColor];
    self.stayLabel.textColor = kDefConfirmColor; //self.foregroundColor;
    self.stayLabel.font = kStayLabelFont;
    self.stayLabel.textAlignment = NSTextAlignmentCenter;
    self.cancelButton.layer.cornerRadius = 10.0f;
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
//    self.pickerView.center = self.center;
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self.delegate pinViewCancelButtonPressed:self];
}

- (void)setStayTime:(NSInteger)stayTime
{
    _stayTime = stayTime;
    if(self.locatorPostive)
        self.clockLabel.text = [NSString stringWithFormat:@"%i Mins", stayTime];
}

-(void)setLitterMessage:(NSString *)litterMessage
{
    _litterMessage =litterMessage;
    if(!self.locatorPostive)
        self.stayLabel.text = litterMessage;
}

- (void)setBigMessage:(NSString *)bigMessage
{
    _bigMessage = bigMessage;
    if(!self.locatorPostive)
        self.clockLabel.text = bigMessage;
}

- (void)setLocatorPostive:(BOOL)locatorPostive
{
    _locatorPostive = locatorPostive;
    if(locatorPostive)
    {
        self.stayLabel.text = @"STAY";
//        self.clockLabel.text = [NSString stringWithFormat:@"%i Mins", self.stayTime];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
