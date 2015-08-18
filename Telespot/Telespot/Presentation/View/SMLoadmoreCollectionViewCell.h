//
//  SMLoadmoreCollectionViewCell.h
//  Spot Maps
//
//  Created by JG on 6/10/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMLoadmoreCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *loadLable;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (nonatomic) BOOL loading;
-(void)startLoading;
-(void)stopLoading;

@end
