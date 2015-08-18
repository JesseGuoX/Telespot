//
//  SMEditNameViewController.m
//  Spot Maps
//
//  Created by JG on 5/9/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMEditNameViewController.h"

@interface SMEditNameViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation SMEditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.textField)
        self.textField.text = _nickName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonPressed:)];
    [self.textField becomeFirstResponder];
    self.textField.font = [UIFont systemFontOfSize:17.0f];
    // Do any additional setup after loading the view.
}

-(void)awakeFromNib
{
    if(self.textField)
        self.textField.text = _nickName;
}

- (void)saveButtonPressed:(id)sender
{
    self.nickName = self.textField.text;
    [self performSegueWithIdentifier:@"DoneEditName" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    if(self.textField)
        self.textField.text = _nickName;
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
