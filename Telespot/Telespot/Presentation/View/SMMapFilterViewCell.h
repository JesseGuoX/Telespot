//
//  SMMapFilterViewCell.h
//  Spot Maps
//
//  Created by JG on 4/11/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMMapFilterViewCell : UITableViewCell
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *checkBoxImageView;
@property (strong, nonatomic) IBOutlet UILabel *lableText;
@property (nonatomic) BOOL selectBoxSelected;
@end
