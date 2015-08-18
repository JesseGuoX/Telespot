//
//  SMEditLocationViewController.m
//  Spot Maps
//
//  Created by JG on 5/9/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMEditLocationViewController.h"

@interface SMEditLocationViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation SMEditLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.textField)
        self.textField.text = _locationName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonPressed:)];
    [self.textField becomeFirstResponder];
    self.textField.font = [UIFont systemFontOfSize:17.0f];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonPressed:(id)sender
{
    self.locationName = self.textField.text;
    [self performSegueWithIdentifier:@"DoneEditLocation" sender:nil];
}

-(void)setLocationName:(NSString *)locationName
{
    _locationName = locationName;
    if(self.textField)
        self.textField.text = _locationName;
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
