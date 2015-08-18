//
//  SMPardCardViewController.m
//  Spot Maps
//
//  Created by JG on 4/5/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMPardCardViewController.h"
#import "SMParkImageCollectionViewCell.h"
#import "SMLoadingCollectionViewCell.h"
#import "SMParkAddressCollectionViewCell.h"
#import "SMPostViewController.h"
#import "AppMacros.h"
#import <MHNatGeoViewControllerTransition.h>
#import "SMImagePreviewViewController.h"
#import "SMCollectionImagePreviewController.h"
#import "SMPhotoPreviewViewController.h"
#import "SMPhotoPagesFactory.h"
#import "SMUtility.h"
#import <MapKit/MapKit.h>
#import <CSNotificationView.h>
#import <UIImageView+RJLoader.h>
#import "SMLoadmoreCollectionViewCell.h"
//#import <MJRefresh.h>


@interface SMPardCardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EBPhotoPagesDataSource, EBPhotoPagesDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (strong, nonatomic) NSMutableArray * dictArray;
@property ( nonatomic) BOOL dataIsLoading;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSIndexPath * selectedIndexPath;
@property (nonatomic, strong) CLLocation * location;
@property (nonatomic, strong)NSMutableArray * availableMaps;
@property (nonatomic) BOOL haveMoreCellToLoad;
@property (nonatomic, strong)SMLoadmoreCollectionViewCell *loadmoreCell;
@end

@implementation SMPardCardViewController

static NSString * const reuseIdentifier = @"ParkPostImageCell";
static NSString * const loadingReuseIdentifier = @"PostImageLoading";
static NSString * const addressReuseIdentifier = @"AddressCell";
static NSString * const noContributeReuseIdentifier = @"noContribute";
static NSString * const loadmoreReuseIdentifier = @"loadmore";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
 
    self.haveMoreCellToLoad = NO;

    [self.navigationController.navigationBar setBarTintColor:kDefCardColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.collectionView.alwaysBounceVertical = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;//去除顶部留白
    // Do any additional setup after loading the view.

    [self.collectionView registerNib:[UINib nibWithNibName:@"SMParkImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMLoadingCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:loadingReuseIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMParkAddressCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:addressReuseIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMParkNoContribute" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:noContributeReuseIdentifier];

    [self.collectionView registerNib:[UINib nibWithNibName:@"SMLoadmoreCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:loadmoreReuseIdentifier];

    self.availableMaps = [NSDictionary new];
    
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*) suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"...";
    
    long long num = [number longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log(num) / log(1000));
    
    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%.0f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}

-(void)loadData
{
    self.dataArray = [NSMutableArray array];
    self.dictArray = [NSMutableArray array];
    self.dataIsLoading = YES;
    __block int xxx= 0;
    WS(ws);
    PFQuery * activityQuery = [SMUtility queryForActivityOnObject:self.object];
    [activityQuery whereKey:kTSPActivityTypeKey equalTo:kTSPActivityTypeStickOn];//必须是stickon，不能是report
    [activityQuery setLimit:10];
    [activityQuery orderByDescending:@"createdAt"];
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            ws.dataArray = [NSMutableArray arrayWithArray:activities];
            if(activities.count >= 10)
            {
                ws.haveMoreCellToLoad = YES;
            }
            else
            {
                ws.haveMoreCellToLoad = NO;
            }
            
            if(activities.count == 0)
            {
                ws.dataIsLoading = NO;
                [ws.collectionView reloadData];
            }
            

            
            for (int i = 0; i < ws.dataArray.count; i++) {
                
                PFObject * activity = [ws.dataArray objectAtIndex:i];
                [ws.dictArray insertObject:[NSMutableDictionary dictionary] atIndex:i];
                NSMutableDictionary * dic = [ws.dictArray objectAtIndex:i];

                [dic setValue:[NSString stringWithFormat:@"By %@", ((PFUser *)[activity objectForKey:kTSPActivityFromUserKey]).username] forKey:@"name"];
                
                PFObject * post = [activity objectForKey:kTSPActivityPostKey];
                PFQuery * query = [SMUtility queryForActivityIsLikedPost:post];
                [query countObjectsInBackgroundWithBlock:^(int number, NSError *PF_NULLABLE_S error)
                 {
                     if(!error)
                     {
                         [dic setValue:[self suffixNumber:[NSNumber numberWithInt:number]] forKey:@"countText"];
                         xxx++;
                         if(xxx>=ws.dataArray.count)
                         {
                             ws.dataIsLoading = NO;
                             [ws.collectionView reloadData];
                         }

                     }
                     else
                     {
                     }
                 }];
            }
            

        }
    }];
}

- (void)loadMoreData
{
    WS(ws);
    __block int xxx= 0;

    PFQuery * activityQuery = [SMUtility queryForActivityOnObject:self.object];
    [activityQuery whereKey:kTSPActivityTypeKey equalTo:kTSPActivityTypeStickOn];//必须是stickon，不能是report
    [activityQuery setLimit:10];
    [activityQuery setSkip:self.dataArray.count];
    [activityQuery orderByDescending:@"createdAt"];
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            [ws.dataArray addObjectsFromArray:activities];
        
            if(activities.count >= 10)
            {
                ws.haveMoreCellToLoad = YES;
            }
            else
            {
                ws.haveMoreCellToLoad = NO;
            }
            
            for (int i = ws.dataArray.count - 10; i < ws.dataArray.count; i++) {
                
                PFObject * activity = [ws.dataArray objectAtIndex:i];
                [ws.dictArray insertObject:[NSMutableDictionary dictionary] atIndex:i];
                NSMutableDictionary * dic = [ws.dictArray objectAtIndex:i];
                
                [dic setValue:[NSString stringWithFormat:@"By %@", ((PFUser *)[activity objectForKey:kTSPActivityFromUserKey]).username] forKey:@"name"];
                
                PFObject * post = [activity objectForKey:kTSPActivityPostKey];
                PFQuery * query = [SMUtility queryForActivityIsLikedPost:post];
                [query countObjectsInBackgroundWithBlock:^(int number, NSError *PF_NULLABLE_S error)
                 {
                     if(!error)
                     {
                         [dic setValue:[self suffixNumber:[NSNumber numberWithInt:number]] forKey:@"countText"];
                         xxx++;
                         if(xxx>=10)
                         {
                             if(ws.loadmoreCell)
                                 [ws.loadmoreCell stopLoading];
                             
                             [ws.collectionView reloadData];
                         }
                         
                     }
                     else
                     {
                     }
                 }];
            }
            
            
        }
    }];

}

- (IBAction)returnButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonPressed:(id)sender {
//    [self.actionSheet showInView:self.view];
}

- (void)setObject:(PFObject *)object
{
    _object = object;
    PFGeoPoint * geo;
    if([[object parseClassName] isEqualToString:kTSPParkClassKey])//park
    {
        self.navigationItem.title = [_object objectForKey:kTSPParkNameKey];
//        self.address = [object objectForKey:kTSPParkAddressKey];
        geo = [_object objectForKey:kTSPParkGeoKey];

    }
    else if([[object parseClassName] isEqualToString:kTSPShopClassKey])//shop
    {
        self.navigationItem.title = [_object objectForKey:kTSPShopNameKey];
//        self.address = [object objectForKey:kTSPShopAddressKey];
        geo = [_object objectForKey:kTSPShopGeoKey];

    }
    else if([[object parseClassName] isEqualToString:kTSPPinClassKey])//pin
    {
//        self.navigationItem.title = [_object objectForKey:k];
//        self.address = [skatepark objectForKey:kTSPParkAddressKey];
        geo = [_object objectForKey:kTSPPinGeoKey];

    }
    else if([[object parseClassName] isEqualToString:kTSPSpotClassKey])//spot
    {
        self.navigationItem.title = [_object objectForKey:kTSPSpotNameKey];
//        self.address = [skatepark objectForKey:kTSPParkAddressKey];
        geo = [_object objectForKey:kTSPSpotGeoKey];

    }
    
    self.location = [[CLLocation alloc] initWithLatitude:geo.latitude longitude:geo.longitude];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.location
                   completionHandler:^(NSArray *placemarks,
                                       NSError *error)
     {
         if(!error)
         {
             CLPlacemark *placemark=[placemarks objectAtIndex:0];
             self.address = placemark.name;
             
             NSLog(@"name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@ \n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
                   placemark.name,
                   placemark.country,
                   placemark.postalCode,
                   placemark.ISOcountryCode,
                   placemark.ocean,
                   placemark.inlandWater,
                   placemark.administrativeArea,
                   placemark.subAdministrativeArea,
                   placemark.locality,
                   placemark.subLocality,
                   placemark.thoroughfare,
                   placemark.subThoroughfare);
         }

     }];
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//#pragma mark <UIActionSheetDelegate>
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex == 1)//拍照
//    {
//        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//
//        [self presentViewController:self.pickerController animated:YES completion:^{
//            
//        }];
//    }
//    else if(buttonIndex == 0)//选择照片
//    {
//        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:self.pickerController animated:YES completion:^{
//            
//        }];
//    }
//}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    if((self.dataIsLoading)||(!self.dataIsLoading && (self.dataArray.count == 0)))
        return 2;
    else{
        if(self.haveMoreCellToLoad)
            return self.dataArray.count + 2;
        else
            return self.dataArray.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if((self.dataIsLoading)||(!self.dataIsLoading && (self.dataArray.count == 0)))
    {
        if(indexPath.row == 0)
        {
            SMParkAddressCollectionViewCell * parkCell = (SMParkAddressCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:addressReuseIdentifier forIndexPath:indexPath];

            parkCell.address = self.address;
            return parkCell;
        }
        else
        {
            if(self.dataIsLoading)
            {
                SMLoadingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:loadingReuseIdentifier forIndexPath:indexPath];
                return cell;
            }
            else
            {
                UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:noContributeReuseIdentifier forIndexPath:indexPath];
                return cell;
            }
        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            SMParkAddressCollectionViewCell * parkCell = (SMParkAddressCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:addressReuseIdentifier forIndexPath:indexPath];

            parkCell.address = self.address;
            return parkCell;
        }
        else if(indexPath.row == self.dataArray.count + 1)//最后一个
        {
            SMLoadmoreCollectionViewCell * loadmoreCell = (SMLoadmoreCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:loadmoreReuseIdentifier forIndexPath:indexPath];
            [loadmoreCell stopLoading];
            self.loadmoreCell = loadmoreCell;
            return loadmoreCell;
        }
        else
        {
            SMParkImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            
//            SMParkImageCollectionViewCell *cell =[[NSBundle mainBundle] loadNibNamed:@"SMParkImageCollectionViewCell" owner:self options:nil];
//            [UINib nibWithNibName:@"SMParkImageCollectionViewCell" bundle:[NSBundle mainBundle]];
            
            cell.layer.borderWidth = 0.5f;
            cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
            cell.imageView.image = [UIImage imageNamed:@"PlaceholderPhoto"];

            PFObject * activity = [self.dataArray objectAtIndex:indexPath.row - 1];
            PFObject * post = [activity objectForKey:kTSPActivityPostKey];
            
            
            if([((NSDictionary *)[self.dictArray objectAtIndex:indexPath.row - 1]) objectForKey:@"name"])
                cell.nameLable.text = [((NSDictionary *)[self.dictArray objectAtIndex:indexPath.row - 1]) objectForKey:@"name"];
            else
                cell.nameLable.text = @"";
            
            if([((NSDictionary *)[self.dictArray objectAtIndex:indexPath.row - 1]) objectForKey:@"countText"])
                cell.favoriteCountLable.text = [((NSDictionary *)[self.dictArray objectAtIndex:indexPath.row - 1]) objectForKey:@"countText"];
            else
                cell.favoriteCountLable.text = @"0";
            

  
            
            [post fetchIfNeededInBackgroundWithBlock:^(PFObject *PF_NULLABLE_S object,  NSError *PF_NULLABLE_S error){
                    if(!error)
                    {

                        if([[post objectForKey:kTSPPostPhotoKey] isDataAvailable])
                        {
                            cell.imageView.file = [post objectForKey:kTSPPostPhotoKey];
                            [cell.imageView loadInBackground];
                        }
                        else
                        {
                            PFFile * file = [object objectForKey:kTSPPostPhotoThumbnailKey];
                            cell.imageView.file = file;
                            if([cell.imageView.file isDataAvailable])
                                [cell.imageView loadInBackground];
                        }

                    }
                }];

            return cell;
        }
    }

//    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)sizingForRowAtIndexPath:(NSIndexPath *)indexPath {

    static SMParkAddressCollectionViewCell *sizingCell   = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell                          = [[NSBundle mainBundle] loadNibNamed:@"SMParkAddressCollectionViewCell" owner:self options:nil][0];
    });
    

    sizingCell.address = self.address;
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize cellSize = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    cellSize.width = self.view.frame.size.width;
    return cellSize;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return [self sizingForRowAtIndexPath:indexPath];
    }
    else
    {
        if(self.dataIsLoading)
        {
            CGFloat width = self.view.frame.size.width  ;
            return CGSizeMake(width, 320);

        }
        else
        {
            if(self.dataArray.count == 0)//没有数据
            {
                return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
            }
            else
            {
                if(indexPath.row == self.dataArray.count + 1)//最后一个
                {
                    return CGSizeMake(self.view.frame.size.width, 50);
                }else
                {
                    CGFloat width = (self.view.frame.size.width - 1)/ 2 ;
                    return CGSizeMake(width, width + 20);
                }

            }
        }
            
    }

}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

//- (void)availableMapsApps {
//    [self.availableMaps removeAllObjects];
//    
//    CLLocationCoordinate2D startCoor = self.mapView.userLocation.location.coordinate;
//    CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(startCoor.latitude+0.01, startCoor.longitude+0.01);
//    NSString *toName = @"to name";
//    
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
//        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",
//                               startCoor.latitude, startCoor.longitude, endCoor.latitude, endCoor.longitude, toName];
//        
//        NSDictionary *dic = @{@"name": @"百度地图",
//                              @"url": urlString};
//        [self.availableMaps addObject:dic];
//    }
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
//        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",
//                               @"云华时代", endCoor.latitude, endCoor.longitude];
//        
//        NSDictionary *dic = @{@"name": @"高德地图",
//                              @"url": urlString};
//        [self.availableMaps addObject:dic];
//    }
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
//        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f¢er=%f,%f&directionsmode=transit", endCoor.latitude, endCoor.longitude, startCoor.latitude, startCoor.longitude];
//        
//        NSDictionary *dic = @{@"name": @"Google Maps",
//                              @"url": urlString};
//        [self.availableMaps addObject:dic];
//    }
//}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"导航至该地点" otherButtonTitles:@"此信息有误", nil];

        action.destructiveButtonIndex = 1;
//        [action addButtonWithTitle:@"导航至该地点"];
//
//        [action addButtonWithTitle:@"取消"];
//        action.cancelButtonIndex = self.availableMaps.count + 1;
//        action.delegate = self;
        [action showInView:self.view];
        
        

    }
    else
    {
        if(!self.dataIsLoading && (self.dataArray.count != 0))
        {
            if(indexPath.row == self.dataArray.count + 1)//load more
            {
                SMLoadmoreCollectionViewCell *loadmoreCell = (SMLoadmoreCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                if(!loadmoreCell.loading)
                    [self loadMoreData];
                [loadmoreCell startLoading];

                
            }
            else
            {
                self.selectedIndexPath = indexPath;
                //    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                //    SMCollectionImagePreviewController * imagePreviewController = [storyboard instantiateViewControllerWithIdentifier:@"ImageCollection"];
                //    imagePreviewController.collectionArray =self.dataArray;
                //    [self presentNatGeoViewController:imagePreviewController];
                
                SMPhotoPreviewViewController *photoPagesController = [[SMPhotoPreviewViewController alloc] initWithDataSource:self delegate:self photoAtIndex:(indexPath.row - 1)];
                photoPagesController.activityObjects = self.dataArray;
                //    [self setPhotoPagesFactory:[SMPhotoPagesFactory new]];
                [photoPagesController setPhotoPagesFactory:[SMPhotoPagesFactory new]];
                
                [self.navigationController pushViewController:photoPagesController animated:YES];
            }

        }
    }


}


#pragma mark - EBPhotoPagesDataSource
- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController
    shouldExpectPhotoAtIndex:(NSInteger)index
{
    if(index < self.dataArray.count){
        return YES;
    }
    
    return NO;
}

- (void)photoPagesController:(EBPhotoPagesController *)controller
                imageAtIndex:(NSInteger)index
           completionHandler:(void(^)(UIImage *image))handler;
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        PFObject * post= [[self.dataArray objectAtIndex:index] objectForKey:kTSPActivityPostKey];
        [post fetchIfNeeded];
        PFFile * file =[post objectForKey:kTSPPostPhotoKey];
        PFFile * thFile = [post objectForKey:kTSPPostPhotoThumbnailKey];
        if(!file.isDataAvailable)
        {
            [thFile getDataInBackgroundWithBlock:^(NSData *PF_NULLABLE_S data, NSError *PF_NULLABLE_S error){
                handler([UIImage imageWithData:data]);
                
            }];
        }
        [file getDataInBackgroundWithBlock:^(NSData *PF_NULLABLE_S data, NSError *PF_NULLABLE_S error){
            handler([UIImage imageWithData:data]);

        }];
        
    });

}

- (void)photoPagesController:(EBPhotoPagesController *)controller
      captionForPhotoAtIndex:(NSInteger)index
           completionHandler:(void (^)(NSString *))handler
{
    
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            PFObject * post= [[self.dataArray objectAtIndex:index] objectForKey:kTSPActivityPostKey];
            [post fetchIfNeeded];
            NSString * string = [post objectForKey:kTSPPostDescriptionKey];
            handler(string);
        });

}

#pragma mark - EBPPhotoPagesDelegate
//Return NO to cancel dismissal of the photoPagesController, for example, so you can handle
//its dismiss animation on your own.
- (BOOL)shouldDismissPhotoPagesController:(EBPhotoPagesController *)photoPagesController
{
    [self.navigationController popViewControllerAnimated:YES];

    return NO;
}

#pragma --actionview delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        CLLocationCoordinate2D  coo = self.location.coordinate;
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coo addressDictionary:nil]];
        toLocation.name = @"终点";
        
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }
    else if(buttonIndex == 1)
    {
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"确定此内容有误？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
        view.tag = 11111;
        [view show];
        
 

    }
    
}


#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if((alertView.tag == 11111)&&(buttonIndex == 1))
    {
        PFObject * activity = [PFObject objectWithClassName:kTSPActivityClassKey];
        [activity setObject:kTSPActivityTypeReportWrongInformation forKey:kTSPActivityTypeKey];
        [activity setObject:[PFUser currentUser] forKey:kTSPActivityFromUserKey];
        if([[self.object parseClassName] isEqualToString:kTSPParkClassKey])//park
        {
            
            [activity setObject:self.object forKey:kTSPActivityToParkKey];
            
        }
        else if([[self.object parseClassName] isEqualToString:kTSPShopClassKey])//shop
        {
            [activity setObject:self.object forKey:kTSPActivityToShopKey];
            
            
        }
        else if([[self.object parseClassName] isEqualToString:kTSPSpotClassKey])//spot
        {
            [activity setObject:self.object forKey:kTSPActivityToSpotKey];
            
        }
        [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error)
         {
             if(succeeded)
             {
                 [CSNotificationView showInViewController:self
                                                    style:CSNotificationViewStyleSuccess
                                                  message:@"已经提交!"];
             }
             else
             {
                 [CSNotificationView showInViewController:self
                                                    style:CSNotificationViewStyleError
                                                  message:@"提交失败!"];
             }
         }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[SMPostViewController class]])
    {
        SMPostViewController * post = (SMPostViewController *)segue.destinationViewController;
        post.object = self.object;
    }
    else if([segue.destinationViewController isKindOfClass:[SMCollectionImagePreviewController class]])
    {
        SMCollectionImagePreviewController * previewController = (SMCollectionImagePreviewController *)segue.destinationViewController;
        previewController.collectionArray = self.dataArray;
    }
}


@end
