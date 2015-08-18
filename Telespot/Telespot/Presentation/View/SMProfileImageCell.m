//
//  SMProfileImageCell.m
//  Spot Maps
//
//  Created by JG on 5/8/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMProfileImageCell.h"
@interface SMProfileImageCell()

@end

@implementation SMProfileImageCell

- (void)awakeFromNib {
    // Initialization code
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width /2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
