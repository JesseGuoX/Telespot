//
//  SMReportView.m
//  Spot Maps
//
//  Created by JG on 4/24/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMReportView.h"

#import <Masonry.h>
#import "AppMacros.h"
@interface SMReportView ()<SMImageThumbViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *pickerButton;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *postButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cameaButtonConstrain;
@property (strong, nonatomic) UILabel * attentionLable;
@end
@implementation SMReportView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    WS(ws);
    
    self.nameTextView.clipsToBounds = YES;
    self.textView.clipsToBounds = YES;
    self.thumbView.clipsToBounds = YES;
    self.pickerButton.clipsToBounds = YES;
    self.topView.userInteractionEnabled = YES;
    
    self.multiswitch1 = [[TKMultiSwitch alloc] initWithItems:@[@"地点", @"滑板场", @"滑板店"]];
    self.multiswitch1.frame = CGRectMakeWithSize(10, 60, self.multiswitch1.frame.size);
    [self.multiswitch1 addTarget:self action:@selector(changedSwitchValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.multiswitch1];

    

    
    self.thumbView = [[SMImageThumbView alloc] initWithFrame:CGRectZero];
    self.thumbView.delegate = self;
    self.thumbView.hidden = YES;
    [self addSubview:self.thumbView];
    [self.thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.topView.mas_bottom).offset(100);
        make.right.mas_equalTo(ws.mas_right).offset(-20);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(70);
    }];
    self.thumbView.clipsToBounds = YES;
    [self layoutIfNeeded];
    
    [self bringSubviewToFront:self.topView];//topview在最前面

    
    [self setUpForDismissKeyboard];
    
    self.textView.delegate = self;
    self.textView.text = @"";
    self.textView.placeholder = NSLocalizedString(@"描述", @"");
    self.textView.placeholderTextColor = [UIColor darkGrayColor];
    self.textView.font = [UIFont systemFontOfSize:16.0f];
    self.textView.floatingLabelFont = [UIFont boldSystemFontOfSize:11.0f];
    self.textView.floatingLabelTextColor = [UIColor brownColor];
    self.textView.tag = 0;

 
    self.nameTextView.text = @"";
    self.nameTextView.placeholder = NSLocalizedString(@"名称", @"");
    self.nameTextView.placeholderTextColor = [UIColor darkGrayColor];
    self.nameTextView.font = [UIFont systemFontOfSize:16.0f];
    self.nameTextView.floatingLabelFont = [UIFont boldSystemFontOfSize:11.0f];
    self.nameTextView.floatingLabelTextColor = [UIColor brownColor];
//    self.nameTextView.scrollEnabled = NO;
    self.nameTextView.delegate = self;
    self.nameTextView.tag = 10;
    
    self.topView.backgroundColor = kDefReportNaviColor;
    
    [self.postButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.6] forState:UIControlStateDisabled];
    self.postButton.enabled = NO;
}

-(void)setPickedImage:(UIImage *)pickedImage
{
    _pickedImage = pickedImage;
    self.thumbView.image = _pickedImage;
    self.pickerButton.hidden = YES;
    self.thumbView.hidden = NO;
    
    [self refreshPostButtonState];

    
}

- (void)changedSwitchValue:(id)sender
{
    [self endEditing:YES];

}

-(void)refreshPostButtonState
{
    if((self.nameTextView.text.length > 0)&&(!self.thumbView.hidden))
    {
        self.postButton.enabled = YES;
    }
    else
    {
        self.postButton.enabled = NO;
    }
}

-(void)setNameTextViewToTop
{
    WS(ws);
    self.cameaButtonConstrain.constant = -10;
    [self.thumbView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.topView.mas_bottom).offset(10);
    }];
    self.multiswitch1.hidden = YES;
    [self layoutIfNeeded];

}

-(void)setDescriptionTextViewToTop
{
    WS(ws);
    self.cameaButtonConstrain.constant = 40;
    [self.thumbView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.topView.mas_bottom).offset(-40);
    }];
    self.multiswitch1.hidden = YES;
    [self layoutIfNeeded];
}

-(void)recoverConstrain
{
    WS(ws);
    self.cameaButtonConstrain.constant = -100;
    [self.thumbView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.topView.mas_bottom).offset(100);
    }];
    [self layoutIfNeeded];
    self.multiswitch1.hidden = NO;

}

- (IBAction)pickerPressed:(id)sender {
//    UIImagePickerController * c
    [self endEditing:YES];

    [self.delegate reportViewPickerButtonPressed];

}

- (IBAction)cancelButtonPressed:(id)sender {
    [self endEditing:YES];

    [self.delegate reportViewCancelButtonPressed];
    
}


- (IBAction)postButtonPressed:(id)sender {
    [self endEditing:YES];

    [self.delegate reportViewPostButtonPressed];
}

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self endEditing:YES];
}


#pragma --mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    if(textView.tag == 10)
    {
        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text ];
        if( [newText length]<= 10 ){
            return YES;
        }
        // case where text length > MAX_LENGTH
        textView.text = [ newText substringToIndex:8 ];
        return NO;
    }
    return YES;

}

-(void)textViewDidChange:(UITextView *)textView
{
    [self refreshPostButtonState];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    WS(ws);
    if(textView.tag == 0)//description
    {
        [UIView animateWithDuration:0.3 animations:^{
            [ws setDescriptionTextViewToTop];
        }];
    }
    else if(textView.tag == 10)//name
    {
        [UIView animateWithDuration:0.3 animations:^{
            [ws setNameTextViewToTop];

        }];
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    WS(ws);
    [UIView animateWithDuration:0.3 animations:^{
        [ws recoverConstrain];

    }];
}


#pragma mark -SMImageThumbViewDelegate
-(void)touchedOnThumbView:(SMImageThumbView *)view inDeleteArea:(BOOL)isin
{
    if(isin)
    {
        self.thumbView.hidden = YES;
        self.pickerButton.hidden = NO;
    }
    else
    {
        [self.delegate reportViewThumbImageNeedPreview];
    }
    [self refreshPostButtonState];

    
}

@end
