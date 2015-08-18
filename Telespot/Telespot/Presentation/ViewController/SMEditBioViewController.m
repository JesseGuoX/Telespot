//
//  SMEditBioViewController.m
//  Spot Maps
//
//  Created by JG on 5/9/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMEditBioViewController.h"

@interface SMEditBioViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SMEditBioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.textView)
        self.textView.text = _Bio;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonPressed:)];
    [self.textView becomeFirstResponder];
    self.textView.font = [UIFont systemFontOfSize:17.0f];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    // Do any additional setup after loading the view.
}

-(void)awakeFromNib
{
    if(self.textView)
        self.textView.text = _Bio;
}

- (void)saveButtonPressed:(id)sender
{
    self.Bio = self.textView.text;
    [self performSegueWithIdentifier:@"DoneEditBio" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBio:(NSString *)Bio
{
    _Bio = Bio;
    if(self.textView)
        self.textView.text = _Bio;
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
