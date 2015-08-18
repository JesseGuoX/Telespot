//
//  SMAnnotationCardView.m
//  Spot Maps
//
//  Created by JG on 4/5/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMAnnotationCardView.h"
#import "SMConstants.h"
#import "AppMacros.h"
#import "SMUtility.h"
@interface SMAnnotationCardView()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageToViewTopConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *createrLable;

@end
@implementation SMAnnotationCardView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 15;
    self.imageToViewTopConstraint.constant = 10;
    self.backgroundColor = kDefCardColor;
    
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.createrLable.textColor = [UIColor whiteColor];
    [self layoutIfNeeded];
}



-(void)setObject:(PFObject *)object
{
    _object = object;

    
    if([[object parseClassName] isEqualToString:kTSPParkClassKey])
    {
        self.titleLabel.text = [self.object objectForKey:kTSPParkNameKey];
        
        PFUser * user = ((PFUser *)[self.object objectForKey:kTSPParkPosterKey]);
        [user fetchIfNeeded];
        NSString * name = user.username;
        
        if(name == nil)
            name = @"系统";
        self.createrLable.text = [NSString stringWithFormat:@"由 %@ 创建", name];
        self.previewImage.image = [UIImage imageNamed:@"card_park"];
    }
    else if([[object parseClassName] isEqualToString:kTSPPinClassKey])
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ 正在活动", ((PFUser *)[self.object objectForKey:kTSPPinPosterKey]).username];
        PFUser * user = ((PFUser *)[self.object objectForKey:kTSPPinPosterKey]);
        [user fetchIfNeeded];
        NSString * name = user.username;
        if(name == nil)
            name = @"系统";
        self.createrLable.text = [NSString stringWithFormat:@"由 %@ 创建", name];
        self.previewImage.image = [UIImage imageNamed:@"card_pin"];

    }
    else if([[object parseClassName] isEqualToString:kTSPSpotClassKey])
    {
        self.titleLabel.text = [self.object objectForKey:kTSPSpotNameKey];
        PFUser * user = ((PFUser *)[self.object objectForKey:kTSPSpotPosterKey]);
        [user fetchIfNeeded];
        NSString * name = user.username;
        if(name == nil)
            name = @"系统";
        self.createrLable.text = [NSString stringWithFormat:@"由 %@ 创建", name];
        self.previewImage.image = [UIImage imageNamed:@"card_spot"];

    }
    else if([[object parseClassName] isEqualToString:kTSPShopClassKey])
    {
        self.titleLabel.text = [self.object objectForKey:kTSPShopNameKey];
        PFUser * user = ((PFUser *)[self.object objectForKey:kTSPShopPosterKey]);
        [user fetchIfNeeded];
        NSString * name = user.username;
        if(name == nil)
            name = @"系统";
        self.createrLable.text = [NSString stringWithFormat:@"由 %@ 创建", name];
        self.previewImage.image = [UIImage imageNamed:@"card_shop"];

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
