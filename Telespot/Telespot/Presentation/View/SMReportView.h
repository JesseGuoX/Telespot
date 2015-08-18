//
//  SMReportView.h
//  Spot Maps
//
//  Created by JG on 4/24/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JVFloatLabeledTextView.h>
#import "SMImageThumbView.h"
#import "TKMultiSwitch.h"
#import "TKGlobal.h"
@protocol  SMReportViewDelegate;

@interface SMReportView : UIView <UITextViewDelegate>
@property (nonatomic, strong) id<SMReportViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextView *textView;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextView *nameTextView;
@property (nonatomic, strong) UIImage * pickedImage;
@property (strong, nonatomic) SMImageThumbView * thumbView;
@property (nonatomic,strong) TKMultiSwitch *multiswitch1;

-(void)setNameTextViewToTop;
-(void)setDescriptionTextViewToTop;
-(void)recoverConstrain;
@end

@protocol SMReportViewDelegate <NSObject>


- (void)reportViewPickerButtonPressed;
- (void)reportViewCancelButtonPressed;
- (void)reportViewPostButtonPressed;
- (void)reportViewThumbImageNeedPreview;
@end