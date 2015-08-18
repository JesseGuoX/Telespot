//
//  AppDelegate.h
//  Spot Maps
//
//  Created by JG on 4/1/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SMLogInViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CLLocationManager * locationManager;

@property (nonatomic, strong) SMLogInViewController * logInViewController;

@end

