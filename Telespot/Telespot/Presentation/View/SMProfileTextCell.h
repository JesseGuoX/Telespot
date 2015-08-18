//
//  SMProfileTextCell.h
//  Spot Maps
//
//  Created by JG on 5/8/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMProfileTextCell : UITableViewCell<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightContraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewWidthContraint;

@end
