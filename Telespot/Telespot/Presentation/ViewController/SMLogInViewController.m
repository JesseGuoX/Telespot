//
//  WXLogInViewController.m
//  Wheex
//
//  Created by JG on 3/5/15.
//  Copyright (c) 2015 JG. All rights reserved.
//

#import "SMLogInViewController.h"
#import <Masonry.h>
#import <parse/PFAnonymousUtils.h>
#import "AppMacros.h"
#import "UIIndicatorButton.h"
//@class PFAnonymousUtils;
@interface SMLogInViewController ()<PFSignUpViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UIIndicatorButton * ghostButton;
@property (nonatomic, strong) UILabel * signUplogoLable;
@property (nonatomic, strong) UILabel * loginInlogoLable;

@end

@implementation SMLogInViewController


-(UILabel *)loginInlogoLable
{
    if(_loginInlogoLable == nil)
    {
        _loginInlogoLable = [[UILabel alloc] init];
        [_loginInlogoLable setText:@"Telespot"];
        [_loginInlogoLable setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:45]];
    }
    return _loginInlogoLable;
}

-(UILabel *)signUplogoLable
{
    if(_signUplogoLable == nil)
    {
        _signUplogoLable = [[UILabel alloc] init];
        [_signUplogoLable setText:@"Telespot"];
        [_signUplogoLable setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:45]];
    }
    return _signUplogoLable;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.fields = (PFLogInFieldsUsernameAndPassword
                   | PFLogInFieldsLogInButton
                   | PFLogInFieldsSignUpButton
                   | PFLogInFieldsPasswordForgotten
                   
                   );

    self.signUpController.delegate = self;
    self.signUpController.signUpView.usernameField.delegate = self;
    self.logInView.usernameField.delegate = self;
    

    
    self.ghostButton = [[UIIndicatorButton alloc] init];
//    self.ghostButton.buttonType = UIButtonTypeCustom;
    [self.ghostButton setBackgroundColor:[UIColor redColor]];
    [self.ghostButton setTitle:@"我是幽灵👻" forState:UIControlStateNormal];
    [self.ghostButton addTarget:self action:@selector(ghostIIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.ghostButton.layer setCornerRadius:4.0f];
    [self.view addSubview:self.ghostButton];
        
    [self.ghostButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logInView.signUpButton.mas_left);
        make.right.mas_equalTo(self.logInView.signUpButton.mas_right);
        make.height.mas_equalTo(self.logInView.signUpButton.mas_height);
        make.bottom.mas_equalTo(self.logInView.signUpButton.mas_top).offset(UI_IS_IPHONE4?-12:-20);
    }];
    
    

    
    self.logInView.logo = self.loginInlogoLable;
    self.logInView.usernameField.placeholder = @"用户名";
    self.logInView.passwordField.placeholder = @"密码";
    
    [self.logInView.logInButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"注册" forState:UIControlStateNormal];
    
    self.signUpController.signUpView.logo = self.signUplogoLable;
    [self.signUpController.signUpView.signUpButton setTitle:@"注册" forState:UIControlStateNormal];
    self.signUpController.signUpView.usernameField.placeholder = @"用户名";
    self.signUpController.signUpView.passwordField.placeholder = @"密码";
    self.signUpController.signUpView.emailField.placeholder = @"邮箱";
}

-(instancetype)initWithDismissButton:(BOOL)with
{
    self = [super init];
    if(self)
    {
        if(!with)
        {
            self.fields = (PFLogInFieldsUsernameAndPassword
                           | PFLogInFieldsLogInButton
                           | PFLogInFieldsSignUpButton
                           | PFLogInFieldsPasswordForgotten
                           
                           );
            
            self.ghostButton = [[UIIndicatorButton alloc] init];
            //    self.ghostButton.buttonType = UIButtonTypeCustom;
            [self.ghostButton setBackgroundColor:[UIColor redColor]];
            [self.ghostButton setTitle:@"我是幽灵👻" forState:UIControlStateNormal];
            [self.ghostButton addTarget:self action:@selector(ghostIIn:) forControlEvents:UIControlEventTouchUpInside];
            [self.ghostButton.layer setCornerRadius:4.0f];
            [self.view addSubview:self.ghostButton];
            [self.ghostButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.logInView.signUpButton.mas_left);
                make.right.mas_equalTo(self.logInView.signUpButton.mas_right);
                make.height.mas_equalTo(self.logInView.signUpButton.mas_height);
                make.bottom.mas_equalTo(self.logInView.signUpButton.mas_top).offset(UI_IS_IPHONE4?-12:-20);
            }];
        }
        else
        {
            self.fields = (PFLogInFieldsUsernameAndPassword
                           | PFLogInFieldsLogInButton
                           | PFLogInFieldsSignUpButton
                           | PFLogInFieldsPasswordForgotten
                           | PFLogInFieldsDismissButton
                           );
            UILabel * label = [[UILabel alloc] init];
            [label setText:@"⚠️未登录只能使用部分功能!⚠️"];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:[UIColor redColor]];
            [self.view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.logInView.signUpButton.mas_left);
                make.right.mas_equalTo(self.logInView.signUpButton.mas_right);
                make.height.mas_equalTo(self.logInView.signUpButton.mas_height);
                make.bottom.mas_equalTo(self.logInView.signUpButton.mas_top).offset(-20);
            }];
            
        }


        
        self.signUpController.delegate = self;
        self.signUpController.signUpView.usernameField.delegate = self;
        self.logInView.usernameField.delegate = self;
        
        
        

        
        
        
        self.logInView.logo = self.loginInlogoLable;
        self.logInView.usernameField.placeholder = @"用户名";
        self.logInView.passwordField.placeholder = @"密码";
        
        [self.logInView.logInButton setTitle:@"登陆" forState:UIControlStateNormal];
        [self.logInView.passwordForgottenButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [self.logInView.signUpButton setTitle:@"注册" forState:UIControlStateNormal];
        
        self.signUpController.signUpView.logo = self.signUplogoLable;
        [self.signUpController.signUpView.signUpButton setTitle:@"注册" forState:UIControlStateNormal];
        self.signUpController.signUpView.usernameField.placeholder = @"用户名";
        self.signUpController.signUpView.passwordField.placeholder = @"密码";
        self.signUpController.signUpView.emailField.placeholder = @"邮箱";
    }
    return self;
    
}


- (void)setCanbeDismiss:(BOOL)canbeDismiss
{
    _canbeDismiss = canbeDismiss;
    if(canbeDismiss)
    {

    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.logInView.logo = self.loginInlogoLable;
    self.logInView.usernameField.placeholder = @"用户名";
    self.logInView.passwordField.placeholder = @"密码";

    [self.logInView.logInButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"注册" forState:UIControlStateNormal];

    self.signUpController.signUpView.logo = self.signUplogoLable;
    [self.signUpController.signUpView.signUpButton setTitle:@"注册" forState:UIControlStateNormal];
    self.signUpController.signUpView.usernameField.placeholder = @"用户名";
    self.signUpController.signUpView.passwordField.placeholder = @"密码";
    self.signUpController.signUpView.emailField.placeholder = @"邮箱";

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)presentMainView
{
    [self performSegueWithIdentifier:@"Present Main View" sender:nil];
}


-(void)ghostIIn:(id)sender
{
    WS(ws);
    [self.ghostButton.activityIndicatorView startAnimating];
    [self.view setUserInteractionEnabled:NO];
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"Anonymous login failed.");
            [ws.view setUserInteractionEnabled:YES];
            UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"警告!" message:@"隐身失败，稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [view show];
        } else {
            NSLog(@"Anonymous user logged in.");
            [ws presentMainView];
        }
    }];
}



#pragma mark -SignUpViewController delegate


-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"🎉🎉🎉" message:@"注册成功，请登录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    view.tag = 11111;
    [view show];
    
    
    
}


- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    
    if(((NSString *)[info objectForKey:@"password"]).length < 6)
    {
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"警告!" message:@"密码不应小于六位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [view show];
        return NO;
    }
    
    
    
    if(![self validateUserName:((NSString *)[info objectForKey:@"username"])])
    {
        
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"警告!" message:@"用户名应使用数字、字母或下划线并且不小于5位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [view show];
        return NO;
    }
    
    
    if(![self validateEmail:((NSString *)[info objectForKey:@"email"])])
    {
        
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"警告!" message:@"邮箱格式不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [view show];
        return NO;
    }
    
    return YES;
}


- (void)signUpViewController:(PFSignUpViewController *)signUpController
    didFailToSignUpWithError:(PFUI_NULLABLE NSError *)error
{
    if(error.code == 203)//邮箱已经被注册
    {
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"邮箱已经被注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [view show];
    }
    else if(error.code == 202)//用户名被注册
    {
        UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"用户名已经被注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [view show];
    }
}



- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    
}


#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 11111 )
    {
        [self.signUpController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ((textField == self.logInView.usernameField) ||(textField == self.signUpController.signUpView.usernameField))
    { // use self.signUpView.usernameField in your PFSignUpViewController subclass
        textField.text = [textField.text lowercaseString];
        return YES;
    }
    return YES;
}

//用户名
- (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9_]{5,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
