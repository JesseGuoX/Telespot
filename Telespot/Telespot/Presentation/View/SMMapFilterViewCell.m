//
//  SMMapFilterViewCell.m
//  Spot Maps
//
//  Created by JG on 4/11/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMMapFilterViewCell.h"

@interface SMMapFilterViewCell()

@end
@implementation SMMapFilterViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setSelectBoxSelected:(BOOL)selectBoxSelected
{
    _selectBoxSelected = selectBoxSelected;
    if(selectBoxSelected)
    {
        self.checkBoxImageView.image = [UIImage imageNamed:@"map_checkbox_fill"];
    }
    else
    {
        self.checkBoxImageView.image = [UIImage imageNamed:@"map_checkbox_empty"];
    }
}
@end
