//
//  SMSettingController.m
//  Spot Maps
//
//  Created by JG on 5/3/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMSettingController.h"
#import "SMConstants.h"
#import <ParseUI.h>
#import "SMLogInViewController.h"
#import "AppDelegate.h"
#import <Masonry.h>
#import "AppMacros.h"

@interface SMSettingController ()<UITableViewDelegate, UITableViewDataSource, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  SMLogInViewController * logInViewController;

@end

@implementation SMSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    //账户：编辑资料，更改密码
    //设置：
    //简介：隐私政策，条款，关于
    //注销账户
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
        case 2:
            return 1;
        default:
            return 0;
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [UIView new];
//    view.backgroundColor = [UIColor redColor];
    view.frame  = CGRectMake(0, 0, 310, 40);
    UILabel * lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(10, 10, 100, 20 );
    lable.textColor = [UIColor grayColor];
    lable.font = [UIFont systemFontOfSize:14.0f];
    switch (section) {
        case 0:
            lable.text = @"账户";
            break;
        case 1:
            lable.text = @"简介";
            break;
        case 2:
            lable.text = @"";
        default:
            break;
    }
    [view addSubview:lable];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" ];
    
    // Configure the cell...
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
    
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"编辑资料";
                    break;
                case 1:
                    cell.textLabel.text = @"更改密码";
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"隐私策略";
                    break;
                case 1:
                    cell.textLabel.text = @"条款";
                    break;
                case 2:
                    cell.textLabel.text = @"关于";
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"注销账户";
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.textColor = [UIColor whiteColor];
                    cell.backgroundColor = [UIColor redColor];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(ws);
    if(indexPath.section == 2)
    {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel setText:@"正在注销..."];
//        [tableView relo];
        UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc]init];
        [cell addSubview:indicatorView];
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell.mas_centerX).offset(-60);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        [cell layoutIfNeeded];
        [indicatorView startAnimating];
        [self.view setUserInteractionEnabled:NO];
        [PFUser logOutInBackgroundWithBlock:^(NSError *PF_NULLABLE_S error)
         {
             PFUser * current = [PFUser currentUser];
             if(current == nil)
             {
                 
                 
                 UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 ws.logInViewController = [storyboard instantiateViewControllerWithIdentifier:@"LogInView"];
                 ws.logInViewController.delegate = self;
                 [ws presentViewController:self.logInViewController animated:YES completion:nil];
             }
             else
             {
                 UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"注销失败" message:@"注销失败，请稍候重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 [view show];
                 
                 [ws.view setUserInteractionEnabled:YES];
                 [indicatorView removeFromSuperview];
                 [cell.textLabel setText:@"注销"];
                 
             }
         
         }];

        
    }
    else if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"Change Profile" sender:nil];
        }
        else if(indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"Change Password" sender:nil];
        }
    }

    //FIXME: 没有退出成功的情况
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
