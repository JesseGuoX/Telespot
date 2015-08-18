//
//  SMMapViewController.m
//  Spot Maps
//
//  Created by JG on 4/4/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMMapViewController.h"
#import "SMConstants.h"
#import "AppMacros.h"
#import "SMSkateParkAnnotation.h"
#import "SMAnnotationView.h"
#import "SMAnnotationCardView.h"
#import "KPAnnotation.h"
#import "KPGridClusteringAlgorithm.h"
#import "KPClusteringController.h"
#import "Masonry.h"
#import "SMPardCardViewController.h"
#import "AwesomeMenu.h"
#import "UIViewController+KNSemiModal.h"
#import "SMPinCardView.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "SMMapFilterView.h"
#import "SMPinAnnotation.h"
#import "SMMapFilterViewController.h"
#import "SMReportView.h"
#import "SMImagePreviewViewController.h"
#import <AssetsLibrary/ALAsset.h>
#import "SMProfileViewController.h"
#import "SMWheelPicker.h"
#import "Categories.h"
#import "SMPinView.h"
#import "AppDelegate.h"
#import <CSNotificationView.h>
#import "CWStatusBarNotification.h"
#import "UIImage+ImageCompress.h"
#import "NSDate+StringDisplayOnPost.h"
#import "SMUtility.h"
#import "SMShopAnnotation.h"
#import "SMSpotAnnotation.h"
#import "SMLogInViewController.h"
#import "WGS84TOGCJ02.h"

typedef NS_ENUM(NSInteger, SMCurrentViewMode) {
    SMMainViewMode,
    SMPinViewMode,
    SMReportViewMode
};

@interface SMMapViewController ()<KPClusteringControllerDelegate, KPClusteringControllerDelegate,MKMapViewDelegate,AwesomeMenuDelegate, UIViewControllerTransitioningDelegate, SMReportViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, SMPinViewDelegate, SMWheelPickerDelegate, PFLogInViewControllerDelegate, UIAlertViewDelegate>
{
    BOOL _lastCardAnimationFinished;
    BOOL _waitToUpdateCurrentLocation;//当程序一开始没确定位置的时候按了定位按钮就置yes
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) IBOutlet AwesomeMenu *awesomeMenu;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mapViewBottomConstrain;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mapViewTopConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *awesomeMenuToBottomConstraint;
@property (strong, nonatomic) IBOutlet UIButton *mylocationButton;
@property (nonatomic, strong) NSMutableArray * skateparkAnnoations;
@property (strong, nonatomic) KPClusteringController *parkclusteringController;

@property (nonatomic, strong) NSMutableArray * pinAnnoations;
@property (strong, nonatomic) KPClusteringController *pinClusteringController;

@property (nonatomic, strong) NSMutableArray * spotAnnoations;
@property (strong, nonatomic) KPClusteringController *spotClusteringController;

@property (nonatomic, strong) NSMutableArray * shopAnnoations;
@property (strong, nonatomic) KPClusteringController *shopClusteringController;


@property (nonatomic, strong) SMAnnotationCardView * cardView;
@property (nonatomic, strong) UITapGestureRecognizer * cardViewTapGesture;

@property (strong, nonatomic) AwesomeMenu * awesomeMenu;

@property (strong, nonatomic) NSString * plistPath;

@property (strong, nonatomic) SMMapFilterViewController * filterViewController;

@property (strong, nonatomic) SMReportView * reportView;
@property (strong, nonatomic) SMPinView * pinView;
@property (strong, nonatomic) SMWheelPicker * pickerView;
@property (strong, nonatomic) CLLocationManager * locationManager;

@property (strong, nonatomic) UIActionSheet * actionSheet;

@property (strong, nonatomic) UIImagePickerController * pickerController;

@property (nonatomic) SMCurrentViewMode currentViewMode;

@property (strong, nonatomic) CWStatusBarNotification *notification ;
@property (strong, nonatomic) SMLogInViewController * logInViewController;
@property (strong, nonatomic) NSTimer * timer;
@end

@implementation SMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(ws);
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.logInViewController = [[SMLogInViewController alloc] initWithDismissButton:YES];
    self.logInViewController.delegate = self;
//    self.logInViewController.canbeDismiss = YES;

    
    [self.mylocationButton setImage:[UIImage imageNamed:@"icon_locate_flat"] forState:UIControlEventTouchUpInside];
    self.currentViewMode = SMMainViewMode;
    self.awesomeMenu.hidden = YES;
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    KPGridClusteringAlgorithm *algorithm = [KPGridClusteringAlgorithm new];
    algorithm.annotationSize = CGSizeMake(25, 50);
    algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategyTwoPhase;
    
    self.parkclusteringController = [[KPClusteringController alloc] initWithMapView:self.mapView
                                                            clusteringAlgorithm:algorithm];
    self.parkclusteringController.delegate = self;
    self.parkclusteringController.animationOptions = UIViewAnimationOptionCurveEaseOut;
    
    
    self.pinClusteringController = [[KPClusteringController alloc] initWithMapView:self.mapView
                                                            clusteringAlgorithm:algorithm];
    self.pinClusteringController.delegate = self;
    self.pinClusteringController.animationOptions = UIViewAnimationOptionCurveEaseOut;
 
    self.shopClusteringController = [[KPClusteringController alloc] initWithMapView:self.mapView
                                                               clusteringAlgorithm:algorithm];
    self.shopClusteringController.delegate = self;
    self.shopClusteringController.animationOptions = UIViewAnimationOptionCurveEaseOut;
    
  
    self.spotClusteringController = [[KPClusteringController alloc] initWithMapView:self.mapView
                                                                clusteringAlgorithm:algorithm];
    self.spotClusteringController.delegate = self;
    self.spotClusteringController.animationOptions = UIViewAnimationOptionCurveEaseOut;
    
    
    self.cardView = [[[NSBundle mainBundle] loadNibNamed:@"SMAnnotationCardView"
                                                  owner:self
                                                options:nil] objectAtIndex:0];
    [self.view addSubview:self.cardView];

    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view.mas_left).offset(10);
        make.right.mas_equalTo(ws.view.mas_right).offset(-10);
        make.bottom.mas_equalTo(ws.view.mas_bottom).offset(100);
        make.height.mas_equalTo(80);
    }];
    [self.view layoutIfNeeded];
    self.cardViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.cardView addGestureRecognizer:self.cardViewTapGesture];
    

    [self configAwesomeMenu];
    
    self.filterViewController = [storyboard instantiateViewControllerWithIdentifier:@"FilterViewController"];
    

    [self loadReportView];
    
    self.pinView = [[[NSBundle mainBundle] loadNibNamed:@"SMPinCardView"
                                                  owner:self
                                                options:nil] objectAtIndex:1];
    self.pinView.hidden = YES;
    self.pinView.backgroundColor = [UIColor clearColor];
    self.pinView.delegate = self;
    [self.view addSubview:self.pinView];
    [self.pinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view.mas_left);
        make.right.mas_equalTo(ws.view.mas_right);
        make.bottom.mas_equalTo(ws.view.mas_bottom);
        make.top.mas_equalTo(ws.view.mas_top);
    }];
    self.pinView.topViewHeightConstraint.constant = self.view.frame.size.height *0.3;
    self.pinView.bottomViewHeightConstraint.constant = self.view.frame.size.height *0.3;
    self.pinView.topViewToTopConstraint.constant = -self.view.frame.size.height *0.3;
    self.pinView.bottomViewToBottomConstraint.constant = -self.view.frame.size.height *0.3;
    [self.view layoutIfNeeded];
    
    self.pickerView= [[SMWheelPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.pickerView.delegate = self;
    self.pickerView.center = self.view.center;
    self.pickerView.innerRadius = UI_IS_IPHONE4?60:80;
    self.pickerView.radius = UI_IS_IPHONE4?80:100;
    self.pickerView.intervalAnger = UI_IS_IPHONE4?8:5;
    self.pickerView.selectedColor = [UIColor redColor];
    self.pickerView.unselelctedColor = [UIColor whiteColor];
    self.pickerView.confirmColor = kDefConfirmColor;
    [self.pickerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.pickerView];
    self.pickerView.hidden = YES;
    self.mylocationButton.hidden = NO;
    
    self.locationManager =  ((AppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager;
//    self.locationManager.delegate = self;
    
    if( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    if(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)||([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse))
    {
        [self.locationManager startUpdatingLocation];
    }
    
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片", @"相机",nil];
    
    self.pickerController = [[UIImagePickerController alloc] init];
    self.pickerController.delegate = self;
    
    self.notification =  [CWStatusBarNotification new];
    self.notification.notificationTappedBlock = ^(void){};
    
//    CGRect frame = CGRectMake(0, 22.0f, CGRectGetWidth([[self view] bounds]), 1.0f);

//    self.progressView =[[GradientProgressView alloc] initWithFrame:frame];
//    [self.view addSubview:self.progressView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(loadData) userInfo:nil repeats:YES];


}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(self.timer)
        [self.timer invalidate];
}
- (void)loadReportView
{
    WS(ws);
    self.reportView =[[[NSBundle mainBundle] loadNibNamed:@"SMReportView"
                                                    owner:self
                                                  options:nil] objectAtIndex:0];
    self.reportView.delegate = self;
    self.reportView.hidden = YES;
    [self.view addSubview:self.reportView];
    [self.reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view.mas_left);
        make.right.mas_equalTo(ws.view.mas_right);
        make.bottom.mas_equalTo(ws.view.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    [self.view layoutIfNeeded];
}


- (bool)valueFromFilterForKey:(NSString *)key
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.plistPath];
    return [[data objectForKey:key] boolValue];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.awesomeMenu setFrame:CGRectMake(size.width/2, size.height - 25, 50, 50)];
}



- (NSString *)plistPath
{
    if(_plistPath == nil)
    {
        //判断应用路径下面是否有plist,没有则拷贝bundle里面的进去，不能直接写bundle里面的东西
        BOOL success;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _plistPath = [documentsDirectory stringByAppendingPathComponent:@"SMFilterProperty.plist"];
        success = [fileManager fileExistsAtPath:_plistPath];
        if (!success)
        {
            NSError *error = [NSError new];
            // The writable database does not exist, so copy the default to the appropriate location.
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SMFilterProperty.plist"];
            success = [fileManager copyItemAtPath:defaultDBPath toPath:_plistPath error:&error];
        }
    }
    return _plistPath;
}

- (void)configAwesomeMenu
{
    AwesomeMenuItem * item1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"awesome_pin"] highlightedImage:[UIImage imageNamed:@"awesome_pin_flat"] ContentImage:[UIImage imageNamed:@"awesome_pin"] highlightedContentImage:[UIImage imageNamed:@"awesome_pin_flat"]];
    
    AwesomeMenuItem * item2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"awesome_post"] highlightedImage:[UIImage imageNamed:@"awesome_post_flat"] ContentImage:[UIImage imageNamed:@"awesome_post"] highlightedContentImage:[UIImage imageNamed:@"awesome_post_flat"]];
    
    AwesomeMenuItem * item3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"awesome_filter"] highlightedImage:[UIImage imageNamed:@"awesome_filter_flat"] ContentImage:[UIImage imageNamed:@"awesome_filter"] highlightedContentImage:[UIImage imageNamed:@"awesome_filter_flat"]];

    AwesomeMenuItem * item4 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"awesome_profile"] highlightedImage:[UIImage imageNamed:@"awesome_profile_flat"] ContentImage:[UIImage imageNamed:@"awesome_profile"] highlightedContentImage:[UIImage imageNamed:@"awesome_profile_flat"]];
    
    AwesomeMenuItem * startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"awesome_group"] highlightedImage:[UIImage imageNamed:@"awesome_group_flat"] ContentImage:nil highlightedContentImage:[UIImage imageNamed:@"awesome_group_flat"]];
    
    self.awesomeMenu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height - 25, 50, 50) startItem:startItem menuItems:[NSArray arrayWithObjects:item1, item2, item3, item4, nil]];


    self.awesomeMenu.delegate = self;
    [self.view addSubview:self.awesomeMenu];
    self.awesomeMenu.startPoint = CGPointMake(0, 0);
    self.awesomeMenu.menuWholeAngle = M_PI_2;
    self.awesomeMenu.rotateAngle = -M_PI_4;
    self.awesomeMenu.animationDuration = 0.2;
//    self.awesomeMenu.timeOffset =  0.01;
//    [self.awesomeMenu  setImage:[UIImage imageNamed:@"mapMenu"]];
//    [self.view addSubview:self.awesomeMenu];
    
}


- (BOOL)locateCurrentLocationWithDistance:(CGFloat)distance
{
    if(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)||([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse))
    {
        if(self.mapView.userLocation.location)
        {
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, distance, distance);
            [self.mapView setRegion:region animated:YES];
        }

        return YES;
    }
    else
    {

        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleError
                                         message:@"请在设置中启动定位服务!"];
        return NO;
    }

}


- (void)loadData
{
    [self loadPinObject];
    [self loadParkObject];
    [self loadShopObject];
    [self loadSpotObject];
}

- (void)loadPinObject
{
    WS(ws);
    self.pinAnnoations = [NSMutableArray array];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-10800];//3小时前的不要
    PFQuery * query = [PFQuery queryWithClassName:kTSPPinClassKey];
    [query whereKeyExists:kTSPPinGeoKey];
    [query whereKey:@"createdAt" greaterThan:date];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for (int i = 0; i < objects.count; i++) {
                //                PFGeoPoint * geo = objects[i][@"geo"];
                PFGeoPoint * geo = [[objects objectAtIndex:i] valueForKey:kTSPPinGeoKey];
                NSNumber *staytime = [[objects objectAtIndex:i] valueForKey:kTSPPinStayTime];
                NSDate * createdAt = [[objects objectAtIndex:i] valueForKey:@"createdAt"];
//                NSDate * currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
                
                NSTimeInterval interval = [createdAt timeIntervalSinceNow];
                if(fabs(interval/60) < staytime.intValue )
                {
                    CLLocationCoordinate2D  co = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
                    SMPinAnnotation * annotation = [[SMPinAnnotation alloc] initWithCoordinate:co];
                    annotation.pin = [objects objectAtIndex:i];
                    PFUser * user = (PFUser *)[annotation.pin objectForKey:kTSPPinPosterKey];
                    [user fetchIfNeededInBackground];
                    [ws.pinAnnoations addObject:annotation];
                    NSLog(@"NO.%d counts", i);
                }

            }
            [ws refreshPinAnnotation];
            
        }
    }];
}

- (void)loadParkObject
{
    WS(ws);
    self.skateparkAnnoations = [NSMutableArray array];
    PFQuery * query = [PFQuery queryWithClassName:kTSPParkClassKey];
    [query whereKeyExists:kTSPParkGeoKey];
    [query whereKey:kTSPParkVerified equalTo:[NSNumber numberWithBool:YES]];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            NSLog(@"There are %lu objects", (unsigned long)objects.count);
            for (int i = 0; i < objects.count; i++) {
                //                PFGeoPoint * geo = objects[i][@"geo"];
                PFGeoPoint * geo = [[objects objectAtIndex:i] valueForKey:kTSPParkGeoKey];
                
                CLLocationCoordinate2D  co = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
                SMSkateParkAnnotation * annotation = [[SMSkateParkAnnotation alloc] initWithCoordinate:co];
                annotation.skatePark = [objects objectAtIndex:i];
                PFUser * user = (PFUser *)[annotation.skatePark objectForKey:kTSPParkPosterKey];
                [user fetchIfNeededInBackground];
                [ws.skateparkAnnoations addObject:annotation];
                NSLog(@"NO.%d counts", i);
            }
            [ws refreshSkateparkAnnotation];
            
        }
    }];

}


- (void)loadSpotObject
{
    WS(ws);
    self.spotAnnoations = [NSMutableArray array];
    PFQuery * query = [PFQuery queryWithClassName:kTSPSpotClassKey];
    [query whereKeyExists:kTSPSpotGeoKey];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if(!error)
        {
            NSLog(@"There are %lu objects", (unsigned long)objects.count);
            for (int i = 0; i < objects.count; i++) {
                //                PFGeoPoint * geo = objects[i][@"geo"];
                PFGeoPoint * geo = [[objects objectAtIndex:i] valueForKey:kTSPSpotGeoKey];
                
                CLLocationCoordinate2D  co = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
                SMSpotAnnotation * annotation = [[SMSpotAnnotation alloc] initWithCoordinate:co];
                annotation.spot = [objects objectAtIndex:i];
                PFUser * user = (PFUser *)[annotation.spot objectForKey:kTSPSpotPosterKey];
                [user fetchIfNeededInBackground];
                [ws.spotAnnoations addObject:annotation];
                NSLog(@"NO.%d counts", i);
            }
            [ws refreshSpotAnnotation];
            
        }
     }];
}

- (void)loadShopObject
{
    WS(ws);
    self.shopAnnoations = [NSMutableArray array];
    PFQuery * query = [PFQuery queryWithClassName:kTSPShopClassKey];
    [query whereKeyExists:kTSPShopGeoKey];
    [query whereKey:kTSPShopVerified  equalTo:[NSNumber numberWithBool:YES]];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             NSLog(@"There are %lu objects", (unsigned long)objects.count);
             for (int i = 0; i < objects.count; i++) {
                 //                PFGeoPoint * geo = objects[i][@"geo"];
                 PFGeoPoint * geo = [[objects objectAtIndex:i] valueForKey:kTSPSpotGeoKey];
                 
                 CLLocationCoordinate2D  co = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
                 
                 SMShopAnnotation * annotation = [[SMShopAnnotation alloc] initWithCoordinate:co];
                 annotation.shop = [objects objectAtIndex:i];
                 PFUser * user = (PFUser *)[annotation.shop objectForKey:kTSPShopPosterKey];
                 [user fetchIfNeededInBackground];
                 [ws.shopAnnoations addObject:annotation];
                 NSLog(@"NO.%d counts", i);
             }
             [ws refreshShopAnnotation];
             
         }
     }];
}


- (void)refreshSkateparkAnnotation
{
    if([self valueFromFilterForKey:KTSPParkProperty])
        [self.parkclusteringController setAnnotations:self.skateparkAnnoations];
}

- (void)refreshPinAnnotation
{
    if([self valueFromFilterForKey:KTSPPinProperty])
        [self.pinClusteringController setAnnotations:self.pinAnnoations];
}

- (void)refreshShopAnnotation
{
    if([self valueFromFilterForKey:KTSPShopProperty])
        [self.shopClusteringController setAnnotations:self.shopAnnoations];
}

- (void)refreshSpotAnnotation
{
    if([self valueFromFilterForKey:KTSPSpotProperty])
        [self.spotClusteringController setAnnotations:self.spotAnnoations];
}



- (IBAction)myLocationButtonPressed:(id)sender {
    if(self.mapView.userLocation.location)
    {
        if([self locateCurrentLocationWithDistance:500])
        {
            
        }
    }
    else//等待定位
    {
        _waitToUpdateCurrentLocation = YES;
    }


}


-(void)tapGestureRecognized:(SMAnnotationCardView *)sender
{
    BOOL userIsAnonymous = [PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]];
    if(userIsAnonymous)
    {
        [self presentViewController:self.logInViewController animated:YES completion:nil];

    }
    else
    {
        if(![[self.cardView.object parseClassName] isEqualToString:kTSPPinClassKey])
            [self performSegueWithIdentifier:@"Show Park Card" sender:self.cardView.object];
    }

}

#pragma mark --SMWheelPickerDelegate
-(void)wheelPickerAngerChanged:(CGFloat)anger
{
    int mins = anger/360*180;

    [self.pinView setStayTime:mins];
}


-(void)wheelPickerConfirmed:(SMWheelPicker *)picker withAnger:(CGFloat)anger
{
    int mins = anger/360*180;
    

//    if(![self.pinView.bigMessage isEqualToString:@"上传"])
    {
        WS(ws);
        if(self.mapView.userLocation.location)
        {
            [self.pinView setUserInteractionEnabled:NO];
            [self.pickerView setUserInteractionEnabled:NO];
            self.pinView.locatorPostive = NO;
            self.pinView.bigMessage = @"上传";
            self.pinView.litterMessage = @"正在";
            
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-10800];//3小时前的不要
            PFQuery * query = [PFQuery queryWithClassName:kTSPPinClassKey];
            [query whereKeyExists:kTSPPinGeoKey];
            [query whereKey:@"createdAt" greaterThan:date];
            [query whereKey:kTSPPinPosterKey equalTo:[PFUser currentUser]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error)
                {
                    for (PFObject * object in objects) {
                        [object deleteInBackground];
                    }
                }
                
                [SMUtility savePinInLocation:self.mapView.userLocation.location withMins:mins blocks:^(PFObject * pinObject, BOOL succeeded, NSError * __nullable error) {
                    if(succeeded)
                    {
                        ws.pinView.locatorPostive = NO;
                        ws.pinView.bigMessage = @"成功";
                        ws.pinView.litterMessage = @"上传";
                        [UIView animateWithDuration:0.0 delay:2.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
                            [ws pinViewCancelButtonPressed:self.pinView];
                            
                        }];
                        //在地图上立即显示
                        PFGeoPoint * geo = [pinObject valueForKey:kTSPPinGeoKey];
                        CLLocationCoordinate2D  co = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
                        SMPinAnnotation * annotation = [[SMPinAnnotation alloc] initWithCoordinate:co];
                        annotation.pin = pinObject;
                        [ws.pinAnnoations addObject:annotation];
                        [ws refreshPinAnnotation];

                    }
                    else
                    {
                        [CSNotificationView showInViewController:ws
                                                           style:CSNotificationViewStyleError
                                                         message:@"无法连接网络"];
                    }
                }];
                
            }];
            

            

        }
        else
        {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:@"请等待确定你的位置"];
        }
    }
}

#pragma mark -CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{


}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

#pragma mark --<PinViewDelegate>
- (void)pinViewCancelButtonPressed:(SMPinView *)view
{

    WS(ws);
    [UIView animateWithDuration:0.3 animations:^{
        [ws.reportView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        ws.mapViewBottomConstrain.constant = 0;
        ws.mapViewTopConstraint.constant = -20;

        ws.pinView.topViewToTopConstraint.constant = -self.view.frame.size.height *0.3;
        ws.pinView.bottomViewToBottomConstraint.constant = -self.view.frame.size.height *0.3;
        ws.pickerView.hidden = YES;
        [ws.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished)
        {
            ws.pinView.hidden = YES;

            ws.pinView = [[[NSBundle mainBundle] loadNibNamed:@"SMPinCardView"
                                                          owner:self
                                                        options:nil] objectAtIndex:1];
            ws.pinView.hidden = YES;
            ws.pinView.backgroundColor = [UIColor clearColor];
            ws.pinView.delegate = self;
            [ws.view addSubview:self.pinView];
            [ws.pinView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws.view.mas_left);
                make.right.mas_equalTo(ws.view.mas_right);
                make.bottom.mas_equalTo(ws.view.mas_bottom);
                make.top.mas_equalTo(ws.view.mas_top);
            }];
            ws.pinView.topViewHeightConstraint.constant = self.view.frame.size.height *0.3;
            ws.pinView.bottomViewHeightConstraint.constant = self.view.frame.size.height *0.3;
            ws.pinView.topViewToTopConstraint.constant = -self.view.frame.size.height *0.3;
            ws.pinView.bottomViewToBottomConstraint.constant = -self.view.frame.size.height *0.3;
            [ws.view layoutIfNeeded];
            
            ws.pickerView= [[SMWheelPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            ws.pickerView.delegate = self;
            ws.pickerView.center = self.view.center;
            ws.pickerView.innerRadius = UI_IS_IPHONE4?60:80;
            ws.pickerView.radius = UI_IS_IPHONE4?80:100;
            ws.pickerView.intervalAnger = UI_IS_IPHONE4?8:5;
            ws.pickerView.selectedColor = [UIColor redColor];
            ws.pickerView.unselelctedColor = [UIColor whiteColor];
            ws.pickerView.confirmColor = kDefConfirmColor;
            [ws.pickerView setBackgroundColor:[UIColor clearColor]];
            [ws.view addSubview:self.pickerView];
            ws.pickerView.hidden = YES;
            
            ws.currentViewMode = SMMainViewMode;
            ws.mylocationButton.hidden = NO;
        }
        
    }];
    




}


#pragma mark --<AwesomeMenuDelegate>
-(void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    WS(ws);
    BOOL userIsAnonymous = [PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]];
    if((userIsAnonymous)&&((idx == 0) || (idx == 1) || (idx == 3)))
    {
        [self presentViewController:self.logInViewController animated:YES completion:nil];

    }
    else
    {        
        
        if(idx == 0)
        {
            
            if([self locateCurrentLocationWithDistance:100])
            {
                self.currentViewMode = SMPinViewMode;
                [self.locationManager startUpdatingLocation];
               self.pinView.locatorPostive = YES;
               self.pinView.hidden = NO;
                
                self.mylocationButton.hidden = YES;
               [UIView animateWithDuration:0.3 animations:^{

                   ws.mapViewBottomConstrain.constant =ws.view.frame.size.height*0.3 ;
                   ws.mapViewTopConstraint.constant =ws.view.frame.size.height*0.3 - 20;
                   ws.pinView.topViewToTopConstraint.constant = 0;
                   ws.pinView.bottomViewToBottomConstraint.constant = 0;

                   [ws.view layoutIfNeeded];
               } completion:^(BOOL finished) {
                   if(finished)
                   {
                       ws.pickerView.hidden = NO;

                   }
               }];
            }
            else
            {
                self.pinView.locatorPostive = NO;

            }

        }
        else if(idx == 1)
        {
            if([self locateCurrentLocationWithDistance:100])
            {
                self.currentViewMode = SMReportViewMode;

                self.reportView.hidden = NO;
                [UIView animateWithDuration:0.3 animations:^{
                    [ws.reportView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(ws.view.frame.size.height * (UI_IS_IPHONE4?0.9:0.8));
                    }];
                    ws.mapViewBottomConstrain.constant =ws.view.frame.size.height*(UI_IS_IPHONE4?0.9:0.8);
                    [ws.view layoutIfNeeded];
                }];
            }


        }
        else if(idx == 2)
        {

            [self presentSemiViewController:self.filterViewController withOptions:@{KNSemiModalOptionKeys.animationDuration : @0.15} completion:^{
                
            } dismissBlock:^{
                    if([ws valueFromFilterForKey:KTSPParkProperty])
                    {
                        [ws.parkclusteringController setAnnotations:ws.skateparkAnnoations];
                
                    }
                    else
                    {
                        [ws.parkclusteringController setAnnotations:nil];
                
                    }
                
                    if([ws valueFromFilterForKey:KTSPPinProperty])
                    {
                        [ws.pinClusteringController setAnnotations:ws.pinAnnoations];
                    }
                    else
                    {
                        [ws.pinClusteringController setAnnotations:nil];
                    }
                
                    if([ws valueFromFilterForKey:KTSPShopProperty])
                    {
                        [ws.shopClusteringController setAnnotations:ws.shopAnnoations];
                    }
                    else
                    {
                        [ws.shopClusteringController setAnnotations:nil];
                    }
                
                    if([ws valueFromFilterForKey:KTSPSpotProperty])
                    {
                        [ws.spotClusteringController setAnnotations:ws.spotAnnoations];
                    }
                    else
                    {
                        [ws.spotClusteringController setAnnotations:nil];
                    }
                
                
            }];
        }
        else if(idx == 3)
        {
            [self performSegueWithIdentifier:@"Profile View Controller" sender:nil];
    //        SMProfileViewController * profileView = [[SMProfileViewController alloc]init];

    //        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //         SMProfileViewController * profileView  = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            
    //        self.definesPresentationContext = YES; //self is presenting view controller
    //        profileView.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    //        profileView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            
    //        [self presentViewController:profileView animated:YES completion:nil];
        
        }
    }

    
}

#pragma mark -UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage * image =[info objectForKey:UIImagePickerControllerOriginalImage];
//    NSData * JPGData = UIImageJPEGRepresentation(image, kDefPostCompressFactor);
//    self.reportView.pickedImage = [UIImage imageWithData:JPGData];
    self.reportView.pickedImage = image;

    NSURL *videoUrl = (NSURL *)[info objectForKey:UIImagePickerControllerMediaURL];
    NSString *moviePath = [videoUrl path];
    
    if ( 1 ) {
        
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        
        [assetLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            
            CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
            NSLog(@"Location Meta: %@", location);
            
        } failureBlock:^(NSError *error) {
            NSLog(@"Video Date Error: %@", error);
        }];
        
    }

}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)//拍照
    {
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

        [self presentViewController:self.pickerController animated:YES completion:^{

        }];
    }
    else if(buttonIndex == 0)//选择照片
    {
        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.pickerController animated:YES completion:^{

        }];
    }
}



#pragma mark --MapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    [self.parkclusteringController refresh:YES force:YES];
    [self.pinClusteringController refresh:YES force:YES];
    [self.shopClusteringController refresh:YES force:YES];
    [self.spotClusteringController refresh:YES force:YES];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(self.currentViewMode != SMMainViewMode)//不是主界面就实时更新当前位置并移动地图
    {
        if(self.currentViewMode == SMPinViewMode)
        {
            if(![self.pinView.bigMessage isEqualToString:@"上传"])
                self.pinView.locatorPostive = YES;

        }
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500);
        [self.mapView setRegion:region animated:YES];
    }else
    {
        if(_waitToUpdateCurrentLocation)
        {
            _waitToUpdateCurrentLocation = NO;
            [self locateCurrentLocationWithDistance:500];
        }
    }

}

-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if(self.currentViewMode == SMPinViewMode)
    {
        self.pinView.locatorPostive = NO;
        self.pinView.litterMessage = @"GPS信号太弱";
        self.pinView.bigMessage = @"无法定位";
    }
    NSLog(@"**************");
    NSLog(error.localizedDescription);
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleRenderer * circle = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circle.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        circle.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        circle.lineWidth = 2;
        
        return circle;
    }
    else
        return nil;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    SMAnnotationView *annotationView = nil;
    
    if ([annotation isKindOfClass:[KPAnnotation class]]) {
        KPAnnotation *a = (KPAnnotation *)annotation;
        
        if ([annotation isKindOfClass:[MKUserLocation class]]){
            return nil;
        }
        
//        if (a.isCluster)
        {
            annotationView = (SMAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
            
            if (annotationView == nil) {
                annotationView = [[SMAnnotationView alloc] initWithAnnotation:a reuseIdentifier:@"cluster"];
                annotationView.image = [UIImage imageNamed:@"map_4c59cf_pin"];

            }
            if([[a.annotations anyObject] isKindOfClass:[SMSkateParkAnnotation class]])
            {
                annotationView.image = [UIImage imageNamed:@"map_1590DA_pin"];

            }else if([[a.annotations anyObject] isKindOfClass:[SMPinAnnotation class]])
            {
                annotationView.image = [UIImage imageNamed:@"map_A500BD_pin"];

            }else if([[a.annotations anyObject] isKindOfClass:[SMShopAnnotation class]])
            {
                annotationView.image = [UIImage imageNamed:@"map_4c59cf_pin"];

            }else if([[a.annotations anyObject] isKindOfClass:[SMSpotAnnotation class]])
            {
                annotationView.image = [UIImage imageNamed:@"map_yellow_pin"];

            }
            
                annotationView.count = a.annotations.count;
            }
        

        
        annotationView.canShowCallout = YES;
    }
    

    
    return annotationView;
    


}

//点击高亮annotion
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    WS(ws);
    if([view.annotation isKindOfClass:[KPAnnotation class]])
    {
        self.awesomeMenu.hidden = YES;

        KPAnnotation *a = (KPAnnotation *)view.annotation;
        id an = [a.annotations anyObject];
        if([an isKindOfClass:[SMSkateParkAnnotation class]])
        {
            
            view.image = [UIImage imageNamed:@"map_white_pin"];
            if(!a.isCluster)
            {
                [UIView animateWithDuration:0.1 animations:^{
                    if(!_lastCardAnimationFinished)
                        [UIView setAnimationDelay:0.1];
                    _lastCardAnimationFinished = NO;
                    [ws.cardView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(ws.view.mas_bottom).offset(-10);
                    }];
                    
                    [ws.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    _lastCardAnimationFinished = YES;
                    
                }];
                NSSet * set =((KPAnnotation *)view.annotation).annotations;
                self.cardView.object = ((SMSkateParkAnnotation*)[set anyObject]).skatePark;
                
                
            }
            else{
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(a.coordinate,
                                                                           a.radius * 2.5f,
                                                                           a.radius * 2.5f)
                               animated:YES];
            }
            
        }
        else if([an isKindOfClass:[SMPinAnnotation class]])
        {
            view.image = [UIImage imageNamed:@"map_white_pin"];
            if(!a.isCluster)
            {
                [UIView animateWithDuration:0.1 animations:^{
                    if(!_lastCardAnimationFinished)
                        [UIView setAnimationDelay:0.1];
                    _lastCardAnimationFinished = NO;
                    [ws.cardView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(ws.view.mas_bottom).offset(-10);
                    }];
                    ws.awesomeMenuToBottomConstraint.constant = ws.awesomeMenu.frame.size.height;
                    [ws.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    _lastCardAnimationFinished = YES;
                    
                }];
                NSSet * set =((KPAnnotation *)view.annotation).annotations;
                self.cardView.object = ((SMPinAnnotation*)[set anyObject]).pin;
                
            }
            else{
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(a.coordinate,
                                                                           a.radius * 2.5f,
                                                                           a.radius * 2.5f)
                               animated:YES];
            }
        }
        else if([an isKindOfClass:[SMSpotAnnotation class]])
        {
            
            view.image = [UIImage imageNamed:@"map_white_pin"];
            if(!a.isCluster)
            {
                [UIView animateWithDuration:0.1 animations:^{
                    if(!_lastCardAnimationFinished)
                        [UIView setAnimationDelay:0.1];
                    _lastCardAnimationFinished = NO;
                    [ws.cardView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(ws.view.mas_bottom).offset(-10);
                    }];
                    
                    [ws.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    _lastCardAnimationFinished = YES;
                    
                }];
                NSSet * set =((KPAnnotation *)view.annotation).annotations;
                self.cardView.object = ((SMSpotAnnotation*)[set anyObject]).spot;
                
                
            }
            else{
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(a.coordinate,
                                                                           a.radius * 2.5f,
                                                                           a.radius * 2.5f)
                               animated:YES];
            }
            
        }
        else if([an isKindOfClass:[SMShopAnnotation class]])
        {
            
            view.image = [UIImage imageNamed:@"map_white_pin"];
            if(!a.isCluster)
            {
                [UIView animateWithDuration:0.1 animations:^{
                    if(!_lastCardAnimationFinished)
                        [UIView setAnimationDelay:0.1];
                    _lastCardAnimationFinished = NO;
                    [ws.cardView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(ws.view.mas_bottom).offset(-10);
                    }];
                    
                    [ws.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    _lastCardAnimationFinished = YES;
                    
                }];
                NSSet * set =((KPAnnotation *)view.annotation).annotations;
                self.cardView.object = ((SMShopAnnotation*)[set anyObject]).shop;
                
                
            }
            else{
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(a.coordinate,
                                                                           a.radius * 2.5f,
                                                                           a.radius * 2.5f)
                               animated:YES];
            }
            
        }
        

    }


    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    WS(ws);
    KPAnnotation *a = (KPAnnotation *)view.annotation;

    if([view.annotation isKindOfClass:[KPAnnotation class]])
//    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        self.awesomeMenu.hidden = NO;

        if([[a.annotations anyObject] isKindOfClass:[SMSkateParkAnnotation class]])
        {
            view.image = [UIImage imageNamed:@"map_1590DA_pin"];
            
        }else if([[a.annotations anyObject] isKindOfClass:[SMPinAnnotation class]])
        {
            view.image = [UIImage imageNamed:@"map_A500BD_pin"];
            
        }else if([[a.annotations anyObject] isKindOfClass:[SMShopAnnotation class]])
        {
            view.image = [UIImage imageNamed:@"map_4c59cf_pin"];

        }else if([[a.annotations anyObject] isKindOfClass:[SMSpotAnnotation class]])
        {
            view.image = [UIImage imageNamed:@"map_yellow_pin"];

        }
        
//        view.image = [UIImage imageNamed:@"map_yellow_pin"];
        if(!a.isCluster)
        {
            
        }
        [UIView animateWithDuration:0.1 animations:^{
            if(!_lastCardAnimationFinished)
                [UIView setAnimationDelay:0.1];
            _lastCardAnimationFinished = NO;
            [ws.cardView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(ws.view.mas_bottom).offset(100);
            }];
            ws.awesomeMenuToBottomConstraint.constant = 0;

            [ws.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _lastCardAnimationFinished = YES;

        }];
    }
}
#pragma mark - <KPClusteringControllerDelegate>

- (void)clusteringController:(KPClusteringController *)clusteringController configureAnnotationForDisplay:(KPAnnotation *)annotation {
    if ([annotation isKindOfClass:[KPAnnotation class]]) {
        KPAnnotation *a = (KPAnnotation *)annotation;
//        if (a.isCluster)
//        {
//            annotation.title = [NSString stringWithFormat:@"%.0f米内有%lu个板场信息", annotation.radius, (unsigned long)annotation.annotations.count];
//        }
        
        if([[a.annotations anyObject] isKindOfClass:[SMSkateParkAnnotation class]])
        {
            if(a.isCluster)
            {
                annotation.title = [NSString stringWithFormat:@"%.0f米内有%lu个板场", annotation.radius, (unsigned long)annotation.annotations.count];
            }
            else
            {
                annotation.title = @"板场";
            }
            
        }else if([[a.annotations anyObject] isKindOfClass:[SMPinAnnotation class]])
        {
            if(a.isCluster)
            {
                annotation.title = [NSString stringWithFormat:@"%.0f米内有%lu个活动者", annotation.radius, (unsigned long)annotation.annotations.count];
            }
            else
            {
                annotation.title = @"活动者";
            }
        }else if([[a.annotations anyObject] isKindOfClass:[SMShopAnnotation class]])
        {
            if(a.isCluster)
            {
                annotation.title = [NSString stringWithFormat:@"%.0f米内有%lu个滑板店", annotation.radius, (unsigned long)annotation.annotations.count];
            }
            else
            {
                annotation.title = @"滑板店";
            }
        }else if([[a.annotations anyObject] isKindOfClass:[SMSpotAnnotation class]])
        {
            if(a.isCluster)
            {
                annotation.title = [NSString stringWithFormat:@"%.0f米内有%lu个滑板地形", annotation.radius, (unsigned long)annotation.annotations.count];
            }
            else
            {
                annotation.title = @"滑板地形";
            }
        }
    }
//    annotation.subtitle = [NSString stringWithFormat:@"%.0f meters", annotation.radius];
}

- (BOOL)clusteringControllerShouldClusterAnnotations:(KPClusteringController *)clusteringController {
    return YES;
}

- (void)clusteringControllerWillUpdateVisibleAnnotations:(KPClusteringController *)clusteringController {
    NSLog(@"Clustering controller %@ will update visible annotations", clusteringController);
}

- (void)clusteringControllerDidUpdateVisibleMapAnnotations:(KPClusteringController *)clusteringController {
    NSLog(@"Clustering controller %@ did update visible annotations", clusteringController);
}

- (void)clusteringController:(KPClusteringController *)clusteringController performAnimations:(void (^)())animations withCompletionHandler:(void (^)(BOOL))completion {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:animations
                     completion:completion];
}

#pragma mark - UIViewControllerTransitioningDelegate



- (void)startUploadNotication
{
    WS(ws);
    if(self.notification.notificationIsShowing)
    {
        [self.notification dismissNotificationWithCompletion:^{
            
            ws.notification.notificationLabelBackgroundColor = kDefReportNaviColor;
            ws.notification.notificationLabelTextColor = [UIColor whiteColor];
            [ws.notification displayNotificationWithMessage:@"正在上传!"
                                                   completion:nil];
        }];

    }
    else
    {
        self.notification.notificationLabelBackgroundColor = kDefReportNaviColor;
        self.notification.notificationLabelTextColor = [UIColor whiteColor];
        [self.notification displayNotificationWithMessage:@"正在上传!"
                                             completion:nil];
    }

}

- (void)uploadFailedNotication
{
    WS(ws);
    if(self.notification.notificationIsShowing)
    {
        [self.notification dismissNotificationWithCompletion:^{
            ws.notification.notificationLabelBackgroundColor = [UIColor redColor];
            [ws.notification displayNotificationWithMessage:@"上传失败!" forDuration:2];
        }];
    }
    else
    {
        self.notification.notificationLabelBackgroundColor = [UIColor redColor];
        [self.notification displayNotificationWithMessage:@"上传失败!" forDuration:2];
    }

}

- (void)uploadSuccessedNotication
{
    WS(ws);
    if(self.notification.notificationIsShowing)
    {
        [self.notification dismissNotificationWithCompletion:^{
            ws.notification.notificationLabelBackgroundColor = [UIColor blueColor];
            [ws.notification displayNotificationWithMessage:@"上传成功!" forDuration:2];
        }];
    }
    else
    {
        self.notification.notificationLabelBackgroundColor = [UIColor blueColor];
        [self.notification displayNotificationWithMessage:@"上传成功!" forDuration:2];
    }

}

#pragma mark - SMReportViewDelegate

-(void)reportViewPostButtonPressed
{
    WS(ws);
//    PFGeoPoint * geo = [PFGeoPoint geoPointWithLocation:self.mapView.userLocation.location];
    if(self.mapView.userLocation.location)
    {
        
        [self reportViewCancelButtonPressed];
        NSString * classString;
         if(self.reportView.multiswitch1.indexOfSelectedItem == 0)//spot
         {
             [self startUploadNotication];

             classString = kTSPSpotClassKey;
             
             [SMUtility saveReport:classString withLocation:self.mapView.userLocation.location withName:self.reportView.nameTextView.text withDescription:self.reportView.textView.text withImage:self.reportView.pickedImage completionBlock:^(PFObject * object , BOOL succeeded, NSError * __nullable error) {
                 if(succeeded)
                 {
                     [ws uploadSuccessedNotication];
                     ws.reportView = nil;
                     [ws loadReportView];
                     
                     if(([classString isEqualToString:kTSPSpotClassKey])&&(object))//SPOT立即显示
                     {
                         PFGeoPoint * geo = [object valueForKey:kTSPSpotGeoKey];
                         
                         CLLocationCoordinate2D  co = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
                         SMSpotAnnotation * annotation = [[SMSpotAnnotation alloc] initWithCoordinate:co];
                         annotation.spot = object;
                         [ws.spotAnnoations addObject:annotation];
                         [ws refreshSpotAnnotation];
                     }
                     
                 }
                 else
                 {
                     [ws uploadFailedNotication];
                 }
             }];
             
         }
         else
         {
             UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"⚠️注意⚠️" message:@"滑板店和滑板场需要由系统审核后才会在地图上显示" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续发布" ,nil];
             view.tag = 111;
             [view show];
         }
        


        


    }
    else
    {
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleError
                                         message:@"请等待确定你的位置"];
    }
}

-(void)reportViewCancelButtonPressed
{
    [self.view endEditing:YES];

    WS(ws);
    [UIView animateWithDuration:0.3 animations:^{
        [ws.reportView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        ws.mapViewBottomConstrain.constant = 0;
        [ws.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished)
        {
            ws.reportView.hidden = YES;
//            [ws.mapView setCenterCoordinate:ws.mapView.userLocation.coordinate animated:YES];
        }
        
    }];

    self.currentViewMode = SMMainViewMode;

}

-(void)reportViewPickerButtonPressed
{
    [self.actionSheet showInView:self.view];
}

-(void)reportViewThumbImageNeedPreview
{

    [self performSegueWithIdentifier:@"Preview Image" sender:self.reportView.pickedImage];

}



#pragma mark -loginViewController delegate
-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self.logInViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self.logInViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码不正确！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [view show];
}


#pragma mark -UIAlterViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WS(ws);
    if((alertView.tag == 111)&&(buttonIndex == 1))//系统审核后才显示
    {
        NSString * classString;

         if(self.reportView.multiswitch1.indexOfSelectedItem == 1)//park
         {
             classString = kTSPParkClassKey;

         }
         else if(self.reportView.multiswitch1.indexOfSelectedItem == 2)//shop
         {
             classString = kTSPShopClassKey;

         }
        [self startUploadNotication];
        [SMUtility saveReport:classString withLocation:self.mapView.userLocation.location withName:self.reportView.nameTextView.text withDescription:self.reportView.textView.text withImage:self.reportView.pickedImage completionBlock:^(PFObject * object , BOOL succeeded, NSError * __nullable error) {
            if(succeeded)
            {
                [ws uploadSuccessedNotication];
                ws.reportView = nil;
                [ws loadReportView];
                
                if(([classString isEqualToString:kTSPSpotClassKey])&&(object))//SPOT立即显示
                {
                    PFGeoPoint * geo = [object valueForKey:kTSPSpotGeoKey];
                    
                    CLLocationCoordinate2D  co = CLLocationCoordinate2DMake(geo.latitude, geo.longitude);
                    SMSpotAnnotation * annotation = [[SMSpotAnnotation alloc] initWithCoordinate:co];
                    annotation.spot = object;
                    [ws.spotAnnoations addObject:annotation];
                    [ws refreshSpotAnnotation];
                }
                
            }
            else
            {
                [ws uploadFailedNotication];
            }
        }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"Show Park Card"])
    {
        if([((UINavigationController *)(segue.destinationViewController)).topViewController isKindOfClass:[SMPardCardViewController class]])
        {
            
            SMPardCardViewController * controller = (SMPardCardViewController *)((UINavigationController *)(segue.destinationViewController)).topViewController;
            controller.object = sender;
        }
    }
    else if([segue.identifier isEqualToString:@"Preview Image"])
    {
        if([(segue.destinationViewController) isKindOfClass:[SMImagePreviewViewController class]])
        {
            
            SMImagePreviewViewController * controller = (SMImagePreviewViewController *)(segue.destinationViewController);
            controller.image = sender;
        }
    }
    else if([segue.identifier isEqualToString:@"Profile View Controller"])
    {
        if([(segue.destinationViewController) isKindOfClass:[SMProfileViewController class]])
        {
            
//            SMProfileViewController * controller = (SMProfileViewController *)(segue.destinationViewController);
//            controller.view.backgroundColor = [UIColor clearColor];
        }
    }
}


@end
