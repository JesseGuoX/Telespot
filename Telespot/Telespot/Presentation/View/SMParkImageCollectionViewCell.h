//
//  SMParkImageCollectionViewCell.h
//  Spot Maps
//
//  Created by JG on 4/6/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMConstants.h"

@interface SMParkImageCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet PFImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCountLable;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (nonatomic, strong) PFObject * activity;
- (void)refreshLikeCounts;
@end
