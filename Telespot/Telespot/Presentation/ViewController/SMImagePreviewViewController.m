//
//  SMImagePreviewViewController.m
//  Spot Maps
//
//  Created by JG on 4/19/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMImagePreviewViewController.h"
#import <MHNatGeoViewControllerTransition.h>

@interface SMImagePreviewViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SMImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.image)
        self.imageView.image = self.image;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    if(self.image)
        self.imageView.image = self.image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    
}];
//    [self dismissNatGeoViewController];
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


-(void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = _image;
    
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
