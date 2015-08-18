//
//  WXLogInViewController.h
//  Wheex
//
//  Created by JG on 3/5/15.
//  Copyright (c) 2015 JG. All rights reserved.
//

#import "PFLogInViewController.h"
#import <PFSignUpViewController.h>
#import <PFTextField.h>

@interface SMLogInViewController : PFLogInViewController
@property (nonatomic) BOOL canbeDismiss;
- (void)presentMainView;
-(instancetype)initWithDismissButton:(BOOL)with;

@end
