//
//  SMPhotoPreviewViewController.m
//  Spot Maps
//
//  Created by JG on 5/11/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMPhotoPreviewViewController.h"
#import "SMPhotoPagesFactory.h"
#import "SMConstants.h"
#import "AppMacros.h"
#import "SMUtility.h"
#import <UIImageView+RJLoader.h>
#import <CSNotificationView.h>
@interface SMPhotoPreviewViewController ()
{
    NSInteger _currentIndex;
    NSInteger _currentReportIndex;
}
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) NSMutableArray * likeArray;
@end

@implementation SMPhotoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(ws);

    self.likeArray  =[[NSMutableArray alloc] initWithCapacity:100];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}


-(void)updateToolbarsWithPhotoAtIndex:(NSInteger)index
{
    WS(ws);

    _currentIndex = index;
    UIBarButtonItem * upperQuitItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"thumb_clear"] style:UIBarButtonItemStylePlain target:self action:@selector(quitItemPressed:)];
    
    UIBarButtonItem * upperMoreItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more_button"] style:UIBarButtonItemStylePlain target:self action:@selector(moreItemPressed:)];

    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    useButton.frame = CGRectMake(0, 0, 30, 30);
    useButton.layer.masksToBounds = YES;
    useButton.layer.cornerRadius = 15;
    [useButton addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * avatarButton = [[UIBarButtonItem alloc] initWithCustomView:useButton];
    
    PFUser * user = [[self.activityObjects objectAtIndex:index] objectForKey:kTSPActivityFromUserKey];
    PFFile * file = [user objectForKey:kTSPUserProfilePicThumbnailKey];
    if(!file.isDataAvailable)
    {
        [useButton.imageView startLoader];
        [file getDataInBackgroundWithBlock:^(NSData *PF_NULLABLE_S data, NSError *PF_NULLABLE_S error){
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [useButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                    [useButton.imageView reveal];
                });

            }
        } progressBlock:^(int percentDone)
         {
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 [useButton.imageView updateImageDownloadProgress:percentDone/100.f];

             });
         }];
    }
    else
    {
        [useButton setImage:[UIImage imageWithData:file.getData] forState:UIControlStateNormal];

    }
    UIBarButtonItem *upperFlexibleSpace = [self.photoPagesFactory flexibleSpaceItemForPhotoPagesController:self];


    
    UIBarButtonItem *lowerFlexibleSpace = [self.photoPagesFactory flexibleSpaceItemForPhotoPagesController:self];

    UIBarButtonItem *likeNumItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil ];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    customView.layer.cornerRadius = 10;
    UIButton *likeButton = [[UIButton alloc] initWithFrame:customView.bounds];
    likeButton.tag = index;
//    [likeButton setImage:[UIImage imageNamed:@"pic_preview_like"] forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(likedPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:likeButton];
    
    UIBarButtonItem *likeItem = [[UIBarButtonItem alloc] initWithCustomView:customView];

    PFObject * object = [[self.activityObjects objectAtIndex:index] objectForKey:kTSPActivityPostKey];

    PFQuery * likeQuery = [SMUtility queryForActivityCurrentUserIsLikedPost:object];
    [likeQuery findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            if(activities.count > 0)
            {
                [likeButton setImage:[UIImage imageNamed:@"pic_preview_like_b"] forState:UIControlStateNormal];
                likeButton.selected = YES;
            }
            else
            {
                [likeButton setImage:[UIImage imageNamed:@"pic_preview_like"] forState:UIControlStateNormal];
                likeButton.selected = NO;

            }
        }
    }];
    NSArray *items = @[avatarButton, lowerFlexibleSpace, likeNumItem, likeItem,  ];
    
//    NSArray *items = @[avatarButton, lowerFlexibleSpace, likeNumItem,   ];

    [self setUpperToolbarItems:@[upperQuitItem, upperFlexibleSpace, upperMoreItem,]];
//    [self setUpperToolbarBackgroundForState:self.currentState];
    
    [self setLowerToolbarItems:items];

//    [self setLowerToolbarItems:mutableLowerItems];
//    [self setLowerToolbarBackgroundForState:self.currentState];
}

- (void)quitItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreItemPressed:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"此信息有误" otherButtonTitles:@"举报不良信息", nil];
    action.destructiveButtonIndex = 1;
    action.tag = 10;
    [action showInView:self.view];
}


- (void)userButtonPressed:(id)sender
{
    
}

- (void)likedPhoto:(UIButton *)sender
{
    PFObject * post = [[self.activityObjects objectAtIndex:sender.tag] objectForKey:kTSPActivityPostKey];

    if(sender.selected)
    {
        sender.selected = NO;
        [sender setImage:[UIImage imageNamed:@"pic_preview_like"] forState:UIControlStateNormal];
        [SMUtility unlikePostInBackground:post block:^(BOOL succeeded, NSError *error) {
            if(succeeded && (!error))
            {
                [sender setImage:[UIImage imageNamed:@"pic_preview_like"] forState:UIControlStateNormal];
                
            }
            else
            {
                [sender setImage:[UIImage imageNamed:@"pic_preview_like_b"] forState:UIControlStateNormal];
                
            }
        }];
    }
    else
    {
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"pic_preview_like_b"] forState:UIControlStateNormal];
        [SMUtility likePostInBackground:post block:^(BOOL succeeded, NSError *error) {
            if(succeeded && (!error))
            {
                [sender setImage:[UIImage imageNamed:@"pic_preview_like_b"] forState:UIControlStateNormal];
                
            }
            else
            {
                [sender setImage:[UIImage imageNamed:@"pic_preview_like"] forState:UIControlStateNormal];
                
            }
        }];
    }
}


#pragma --actionview delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 10)//举报错误信息
    {
        if(buttonIndex == 0)
        {
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"确定此内容有误？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
            view.tag = 11111;
            [view show];
        }
        else if(buttonIndex == 1)
        {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"带有色情或政治内容", @"盗用他人作品", @"其他原因", nil];
            action.tag = 11;
            [action showInView:self.view];
            
        }
    }
    else if(actionSheet.tag == 11)//举报色情等内容
    {
        if(buttonIndex != 3)
        {
            _currentReportIndex = buttonIndex;
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"确定举报此内容?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" ,nil];
            view.tag = 555;
            [view show];
        }

    }

    
}


#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    PFObject * post = [[self.activityObjects objectAtIndex:_currentIndex] objectForKey:kTSPActivityPostKey];

    if((alertView.tag == 11111)&&(buttonIndex == 1))//此内容有误
    {
        PFObject * activity = [PFObject objectWithClassName:kTSPActivityClassKey];
        [activity setObject:kTSPActivityTypeReportWrongInformation forKey:kTSPActivityTypeKey];
        [activity setObject:[PFUser currentUser] forKey:kTSPActivityFromUserKey];
        [activity setObject:post forKey:kTSPActivityPostKey];
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
    else if((alertView.tag == 555)&&(buttonIndex == 1))//举报此内容
    {
        PFObject * activity = [PFObject objectWithClassName:kTSPActivityClassKey];
        switch (_currentReportIndex) {
            case 0:
                [activity setObject:kTSPActivityTypeReportPorn forKey:kTSPActivityTypeKey];
                break;
            case 1:
                [activity setObject:kTSPActivityTypeReportSteeling forKey:kTSPActivityTypeKey];

                break;
            case 2:
                [activity setObject:kTSPActivityTypeReportOther forKey:kTSPActivityTypeKey];

                break;
                
            default:
                break;
        }
        [activity setObject:[PFUser currentUser] forKey:kTSPActivityFromUserKey];
        [activity setObject:post forKey:kTSPActivityPostKey];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
