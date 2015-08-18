//
//  SMProfileViewController.m
//  Spot Maps
//
//  Created by JG on 5/2/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMProfileViewController.h"
#import "EPieChart.h"
#import "SMConstants.h"
#import <ParseUI.h>
#import <UIImageView+RJLoader.h>
#import "AppMacros.h"
#import <Masonry.h>
#import "SMImagePreviewViewController.h"

@interface SMProfileViewController ()<EPieChartDelegate, EPieChartDataSource>


@property (strong, nonatomic) NSString * nickName;
@property (strong, nonatomic) NSString * gender;
@property (strong, nonatomic) NSString * Bio;
@property (strong, nonatomic) NSString * locationName;

@property (strong, nonatomic) IBOutlet UILabel *locationLable;
@property (strong, nonatomic) IBOutlet PFImageView *profileImage;
@property (strong, nonatomic) IBOutlet UITextView * bioTextView;
@property (strong, nonatomic) UITapGestureRecognizer * tapGestureReco;

@end

@implementation SMProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.profileImage.layer.borderWidth = 3;
    self.profileImage.clipsToBounds = YES;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profileImage.image = [UIImage imageNamed:@"PlaceholderPhoto"];
    [self.profileImage setUserInteractionEnabled:YES];;
    self.tapGestureReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    
    [self.profileImage addGestureRecognizer:self.tapGestureReco];
    
    [self.bioTextView setTextAlignment:NSTextAlignmentCenter];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadUserData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)tapped:(id)sender
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     SMImagePreviewViewController * preview = [storyboard instantiateViewControllerWithIdentifier:@"ImagePreviewViewController"];

    preview.image = self.profileImage.image;
    
    PFFile * file =  [[PFUser currentUser] objectForKey:kTSPUserProfilePicKey];
    [file getDataInBackgroundWithBlock:^(NSData *PF_NULLABLE_S data, NSError *PF_NULLABLE_S error)
     {
         if((!error)&&(data))
         {
             preview.image = [UIImage imageWithData:data];
         }
     }];
    
    [self presentViewController:preview animated:YES completion:nil];
}



- (void)loadUserData
{
    PFUser * user = [PFUser currentUser];
    self.nickName = [user objectForKey:kTSPUserDisplayNameKey];
    self.gender = [user objectForKey:kTSPUserGenderKey];
    self.locationName = [user objectForKey:kTSPUserLocationKey];
    self.Bio = [user objectForKey:kTSPUserDescriptionKey];
    
    self.bioTextView.text = self.Bio;
    self.locationLable.text = self.locationName;

    
    if([self.gender isEqualToString:@"男"])
    {
        self.profileImage.layer.borderColor = [PROFILE_MAN_COLOR CGColor];
    }else if([self.gender isEqualToString:@"女"])
    {
        self.profileImage.layer.borderColor = [PROFILE_WOMAN_COLOR CGColor];

    }
    
    PFFile * file =  [user objectForKey:kTSPUserProfilePicThumbnailKey];
    self.profileImage.file = file;
    [self.profileImage loadInBackground];

    
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
