//
//  SMPasswordChangeController.m
//  Spot Maps
//
//  Created by JG on 5/5/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMPasswordChangeController.h"
#import "SMPasswordCell.h"
#import <CSNotificationView.h>
#import "SMConstants.h"
@interface SMPasswordChangeController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) UIColor * buttonTintColor;
@end

@implementation SMPasswordChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self setSaveButtonEnable:NO];

    self.buttonTintColor = self.saveButton.tintColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSaveButtonEnable:(BOOL)enable
{
    if(enable)
    {
        self.saveButton.enabled = YES;
        [self.saveButton setTintColor:self.buttonTintColor];
    }
    else
    {
        self.saveButton.enabled = NO;
        [self.saveButton setTintColor:[UIColor grayColor]];

    }
}
- (IBAction)returnButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
    [self.view endEditing:YES];
    PFUser * user = [PFUser currentUser];
    if([(( SMPasswordCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]).textField.text isEqualToString:(( SMPasswordCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]]).textField.text ])
    {
        if((( SMPasswordCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]).textField.text.length >= 6)
        {
            [PFUser logInWithUsernameInBackground:user.username password:(( SMPasswordCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField.text block: ^(PFUser *user, NSError *error)
             {
                 if(!error)
                 {
                     [PFUser currentUser].password =(( SMPasswordCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]]).textField.text;
                     [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                      {
                          if(succeeded)
                          {
                              [self dismissViewControllerAnimated:YES completion:nil];
                              
                          }
                      }];
                 }
                 else
                 {
                     [CSNotificationView showInViewController:self
                                                        style:CSNotificationViewStyleError
                                                      message:@"旧密码不正确!"];
                 }
             }];
        }
        else
        {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:@"密码应不小于6位"];
        }

    }
    else
    {
        [CSNotificationView showInViewController:self
                                           style:CSNotificationViewStyleError
                                         message:@"新密码不匹配!"];
    }
 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;

        default:
            return 0;
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];


    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    SMPasswordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PasswordCell"];
    if (!cell){
        cell =(SMPasswordCell *)[[[NSBundle mainBundle] loadNibNamed:@"SMPasswordCell" owner:self options:nil] objectAtIndex:0];
        cell.textField.delegate = self;
        [cell.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    if(indexPath.section == 0)
    {
        cell.textField.placeholder = @"旧密码";
        cell.textField.tag = 0;

    }
    else
    {
        if(indexPath.row == 0)
        {
            cell.textField.placeholder = @"新密码";
            cell.textField.tag = 1;
        }
        else
        {
            cell.textField.placeholder = @"确认新密码";
            cell.textField.tag = 2;
        }
    }
    return cell;
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


-(void)textFieldChanged:(id)sender
{
    if(((( SMPasswordCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField.text.length > 0)&&
       ((( SMPasswordCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]).textField.text.length >= 6)&&
       ((( SMPasswordCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]]).textField.text.length >= 6))
    {
        [self setSaveButtonEnable:YES];
    }
    else
        [self setSaveButtonEnable:NO];
}


#pragma mark -- UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:

            break;
        case 1:
            if(textField.text.length < 6)
            {
                [CSNotificationView showInViewController:self
                                                   style:CSNotificationViewStyleError
                                                 message:@"密码应不小于6位"];
            }
            break;
        case 2:
            break;
            
        default:
            break;
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
