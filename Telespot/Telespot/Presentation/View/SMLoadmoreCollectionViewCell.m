//
//  SMLoadmoreCollectionViewCell.m
//  Spot Maps
//
//  Created by JG on 6/10/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMLoadmoreCollectionViewCell.h"

@implementation SMLoadmoreCollectionViewCell


- (void)startLoading
{
    self.loadLable.text = @"正在加载";
    [self.loadIndicator startAnimating];
    self.loadIndicator.hidden = NO;
    self.loading = YES;
}

-(void)stopLoading
{
    self.loadLable.text = @"点击加载更多";

    [self.loadIndicator stopAnimating];
    self.loading = NO;

}
@end
