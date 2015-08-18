//
//  SCDefine.h
//  Wheels
//
//  Created by JG on 14-6-8.
//  Copyright (c) 2014年 JG. All rights reserved.
//

#ifndef __APPMACROS_H
#define __APPMACROS_H

#import "Categories.h"
//#import "Masonry.h"

#define color(r,g,b,a) [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha:a]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define  CAMERA_VIEW_WIDTH  
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define SCBACKCOLOR [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.f] 

#define PROFILE_MAN_COLOR [UIColor colorWithRed:134/255.0f green:207/255.0f blue:255/255.0f alpha:1.f]

#define PROFILE_WOMAN_COLOR [UIColor colorWithRed:255/255.0f green:170/255.0f blue:170/255.0f alpha:1.f]

//notification
#define nCapturedPhotoSuccessfully              @"caputuredPhotoSuccessfully"

#define BACKCOLOR  UIColorFromRGB(0x23292A)
//#define BACKCOLOR  UIColorFromRGB(0x2A2C2D)
//#define FRONTCOLOR UIColorFromRGB(0x004153)
#define FRONTCOLOR UIColorFromRGB(0x3E4548)
#define STATUSBAR_HEIGHT  [[UIApplication sharedApplication] statusBarFrame].size.height
#define POST_HEADER_HEIGHT 50
#define POST_COMMENT_HEIGHT 70

#define kClockLabelFont [UIFont fontWithName:@"HelveticaNeue-Light" size:valForScreen(50,60)]
#define kStayLabelFont [UIFont fontWithName:@"HelveticaNeue-Light" size:valForScreen(20,30)]
#define kDefConfirmColor        color(63,186,141,1)
#define kDefCardColor kDefConfirmColor
#define kDefReportNaviColor kDefConfirmColor

#define kDefPostCompressFactor    0.5
#define kDefPostThumbnailCompressFactor 0.2


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define UI_IS_LANDSCAPE         ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)
#define UI_IS_IPAD              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE4           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS       (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations
#define UI_IS_IOS8_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#endif
