//
//  AppDelegate.m
//  Spot Maps
//
//  Created by JG on 4/1/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse.h"
#import "SMConstants.h"
#import "PFSignUpViewController.h"

@interface AppDelegate ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate,UIAlertViewDelegate, UITextFieldDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [Parse enableLocalDatastore];
    [Parse setApplicationId:CLOUD_APPLICATION_ID
                  clientKey:CLOUD_CLIENT_KEY];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if(currentUser)
    {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * viewC = [storyboard instantiateViewControllerWithIdentifier:@"Map View"];
        [self.window setRootViewController:viewC];
    }
    else
    {
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.logInViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInView"];
        self.logInViewController.delegate = self;
//        self.logInViewController.signUpController.delegate = self;
//        self.logInViewController.signUpController.signUpView.usernameField.delegate = self;
//        self.logInViewController.logInView.usernameField.delegate = self;
        [self.window setRootViewController:self.logInViewController];
        
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    

        PFACL *defaultACL = [PFACL ACL];
        // Optionally enable public read access while disabling public write access.
        [defaultACL setPublicReadAccess:YES];
        [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -CLLocationManagerDelegate 
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"lication failed");

}



#pragma mark -loginViewController delegate
-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self.logInViewController presentMainView];
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码不正确！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [view show];

}

@end
