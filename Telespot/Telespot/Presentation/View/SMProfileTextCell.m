//
//  SMProfileTextCell.m
//  Spot Maps
//
//  Created by JG on 5/8/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMProfileTextCell.h"

@implementation SMProfileTextCell

- (void)awakeFromNib {
    // Initialization code
    self.textView.delegate = self;
    self.textView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//    CGRect bounds = textView.bounds;
//    
//    // 计算 text view 的高度
//    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
//    CGSize newSize = [textView sizeThatFits:maxSize];
//    newSize.height += 16.0f;
//    bounds.size = newSize;
//    
//    textView.bounds = bounds;
//    
//    // 让 table view 重新计算高度
//    UITableView *tableView = [self tableView];
//    [tableView beginUpdates];
//    [tableView endUpdates];
//}
//- (UITableView *)tableView
//{
//    UIView *tableView = self.superview;
//    
//    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
//        tableView = tableView.superview;
//    }
//    
//    return (UITableView *)tableView;
//}


@end
