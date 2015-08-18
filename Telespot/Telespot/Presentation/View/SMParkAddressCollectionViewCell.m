//
//  SMParkAddressCollectionViewCell.m
//  Spot Maps
//
//  Created by JG on 4/17/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMParkAddressCollectionViewCell.h"
@interface SMParkAddressCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SMParkAddressCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.textView setUserInteractionEnabled:NO];
}

-(void)setAddress:(NSString *)address
{
    _address = address;
    _textView.text = [address lowercaseString];
//    _textView.font = [UIFont fontWithName:<#(NSString *)#> size:22];
    _textView.textColor = [UIColor blackColor];
//    _textView.textAlignment = NSTextAlignmentCenter;
    _constraintTextViewHeight.constant = ceilf([_textView sizeThatFits:CGSizeMake(_textView.frame.size.width, FLT_MAX)].height);
//    _constraintTextViewHeight.constant = 300;
    [_textView setNeedsLayout];
    [_textView layoutIfNeeded];
    
}
@end
