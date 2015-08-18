//
//  SMParkAddressCollectionViewCell.h
//  Spot Maps
//
//  Created by JG on 4/17/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMParkAddressCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString * address;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTextViewHeight;

@end
