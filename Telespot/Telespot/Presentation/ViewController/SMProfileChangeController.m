//
//  SMProfileChangeController.m
//  Spot Maps
//
//  Created by JG on 5/6/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMProfileChangeController.h"
#import <RSKImageCropViewController.h>
#import <RSKImageCropper.h>
#import "SMConstants.h"
#import "AppMacros.h"
#import <JVFloatLabeledTextView.h>
#import <Masonry.h>
#import "SMProfileImageCell.h"
#import "SMProfileTextCell.h"
#import "SMEditNameViewController.h"
#import "SMEditBioViewController.h"
#import "SMEditLocationViewController.h"
#import <MBProgressHUD.h>
#import <UIImageView+RJLoader.h>
@interface SMProfileChangeController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,RSKImageCropViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate>
{
    BOOL _imageChanged;
    BOOL _uploadSuccessed;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIActionSheet * actionSheet;
@property (strong, nonatomic) UIActionSheet * genderActionSheet;
@property (strong, nonatomic) UIImagePickerController * pickerController;
@property (strong, nonatomic) RSKImageCropViewController * cropViewController;
@property (strong, nonatomic) UIGestureRecognizer * tapGestureReco;

@property (strong, nonatomic) NSString * nickName;
@property (strong, nonatomic) NSString * gender;
@property (strong, nonatomic) NSString * Bio;
@property (strong, nonatomic) NSString * locationName;

@property (strong, nonatomic) MBProgressHUD * hud;

@end

@implementation SMProfileChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    UIView * tableFooterView = [UIView new];
//    [tableFooterView setBackgroundColor:[UIColor redCo;lor]];
    self.tableView.tableFooterView = tableFooterView;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    

    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择照片", @"拍照", nil];
    self.actionSheet.tag = 0;
    
    self.genderActionSheet =[[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", @"未指定", nil];
    self.genderActionSheet.tag = 1;
    
    self.pickerController = [[UIImagePickerController alloc] init];
    self.pickerController.delegate = self;
    // Do any additional setup after loading the view.
    self.cropViewController = [[RSKImageCropViewController alloc] init];
    self.cropViewController.delegate = self;
    
//    self.nickName = @"haha";
//    self.gender = @"男";
//    self.Bio = @"我就是我颜色不一样的二货";
    [self loadUserData];

}

- (MBProgressHUD *)hud
{
    if(!_hud)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.mode = MBProgressHUDModeAnnularDeterminate;
        _hud.delegate = self;
    }
    return _hud;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnButtonPressed:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveButtonPressed:(id)sender {
    
    [self saveUserData];
}


-(void)loadUserData
{
    PFUser * user = [PFUser currentUser];
    self.nickName = [user objectForKey:kTSPUserDisplayNameKey];
    self.gender = [user objectForKey:kTSPUserGenderKey];
    self.locationName = [user objectForKey:kTSPUserLocationKey];
    self.Bio = [user objectForKey:kTSPUserDescriptionKey];
        SMProfileImageCell * imageCell =(SMProfileImageCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [imageCell.profileImageView startLoader];
    PFFile * file =  [user objectForKey:kTSPUserProfilePicKey];
    if(!file)
    {
        [imageCell.profileImageView setImage:[UIImage imageNamed:@"PlaceholderPhoto"]];
        [imageCell.profileImageView reveal];

    }
    else{
        [file getDataInBackgroundWithBlock:^(NSData *PF_NULLABLE_S data, NSError *PF_NULLABLE_S error){
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [imageCell.profileImageView setImage:[UIImage imageWithData:data]];
                    [imageCell.profileImageView reveal];
                });
                
            }
        }progressBlock:^(int percentDone){
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [imageCell.profileImageView updateImageDownloadProgress:percentDone/100.f];
            });
        }];
    }

    [self.tableView reloadData];
}
//if(succeeded)
//{
//    self.hud.progress = 1.0;
//    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UploadCheckMark"]];
//    self.hud.customView = imageView;
//    self.hud.mode = MBProgressHUDModeCustomView;
//    self.hud.labelText = @"上传成功";
//    [self.hud hide:YES afterDelay:2];
//    self.uploadSuccess = YES;
//}
//else
//{
//    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UploadFailedMark"]];
//    self.hud.customView = imageView;
//    self.hud.mode = MBProgressHUDModeCustomView;
//    self.hud.labelText = @"上传失败";
//    [self.hud show:YES];
//    [self.hud hide:YES afterDelay:2];

- (void)saveUserData
{
    WS(ws);
    SMProfileImageCell * imageCell =(SMProfileImageCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    [self.hud show:YES];
    if(_imageChanged)
    {
        PFFile * file = [PFFile fileWithData:UIImageJPEGRepresentation(imageCell.profileImageView.image, 0.5f) contentType:@"png"];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if(succeeded)
             {
                 PFFile * thumbFile = [PFFile fileWithData:UIImageJPEGRepresentation(imageCell.profileImageView.image, 0.1f) contentType:@"png"];
                 [thumbFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                    if(succeeded)
                    {
                        ws.hud.progress = 0.95f;
                        PFUser * user = [PFUser currentUser];
                        [user setObject:thumbFile forKey:kTSPUserProfilePicThumbnailKey];
                        [user setObject:file forKey:kTSPUserProfilePicKey];
                        [user setObject:self.nickName forKey:kTSPUserDisplayNameKey];
                        [user setObject:self.gender forKey:kTSPUserGenderKey];
                        [user setObject:self.locationName forKey:kTSPUserLocationKey];
                        [user setObject:self.Bio forKey:kTSPUserDescriptionKey];
                        
                        [user saveInBackground];
                        
                        _uploadSuccessed = YES;
                        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UploadCheckMark"]];
                        ws.hud.customView = imageView;
                        ws.hud.mode = MBProgressHUDModeCustomView;
                        ws.hud.labelText = @"上传成功";
                        [ws.hud hide:YES afterDelay:1.5];
                    }
                     else
                     {
                         _uploadSuccessed = NO;
                         
                         UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UploadFailedMark"]];
                         ws.hud.customView = imageView;
                         ws.hud.mode = MBProgressHUDModeCustomView;
                         ws.hud.labelText = @"上传失败";
                         [ws.hud hide:YES afterDelay:1.5];
                     }
                 }];

             }
             else
             {
                 _uploadSuccessed = NO;

                 UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UploadFailedMark"]];
                 ws.hud.customView = imageView;
                 ws.hud.mode = MBProgressHUDModeCustomView;
                 ws.hud.labelText = @"上传失败";
                 [ws.hud hide:YES afterDelay:1.5];

             }
         }progressBlock:^(int percentDone)
         {
             if(percentDone < 90)
                 ws.hud.progress = percentDone/100.0f;
         }];
    }
    else
    {
        PFUser * user = [PFUser currentUser];
        
        [user setObject:self.nickName forKey:kTSPUserDisplayNameKey];
        [user setObject:self.gender forKey:kTSPUserGenderKey];
        [user setObject:self.locationName forKey:kTSPUserLocationKey];
        [user setObject:self.Bio forKey:kTSPUserDescriptionKey];
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error){
            if(succeeded)
            {
                [ws.hud setProgress:1.0f];
                UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UploadCheckMark"]];
                ws.hud.customView = imageView;
                ws.hud.mode = MBProgressHUDModeCustomView;
                ws.hud.labelText = @"上传成功";
                [ws.hud hide:YES afterDelay:1.5];
                _uploadSuccessed = YES;
            }
            else
            {
                _uploadSuccessed = NO;
                
                UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UploadFailedMark"]];
                ws.hud.customView = imageView;
                ws.hud.mode = MBProgressHUDModeCustomView;
                ws.hud.labelText = @"上传失败";
                [ws.hud hide:YES afterDelay:1.5];
            }
        }];

    }


}


-(void)tapped:(id)sender
{
    [self.actionSheet showInView:self.view];

}


#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    if(_uploadSuccessed)
        [self.navigationController popViewControllerAnimated:YES];


}

#pragma mark <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 0)
    {
        if(buttonIndex == 1)//拍照
        {
            self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:self.pickerController animated:YES completion:^{
                
            }];
        }
        else if(buttonIndex == 0)//选择照片
        {
            self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.pickerController animated:YES completion:^{
                
            }];
        }
    }else if(actionSheet.tag == 1)
    {
        if(buttonIndex == 0)//男生
        {
            self.gender = @"男";
        }
        else if(buttonIndex == 1)//女生
        {
            self.gender = @"女";

        }
        else if(buttonIndex == 2)//未指定
        {
            self.gender = @"未指定";
        }
        [self.tableView reloadData];
    }

}

#pragma  mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    WS(ws);
    dispatch_async(dispatch_get_main_queue(), ^{
        ws.cropViewController.originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [ws presentViewController:ws.cropViewController animated:YES completion:^{
        }];
    });

    [picker dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark -RSKImageCropViewControllerDelegate
// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    SMProfileImageCell * imageCell =(SMProfileImageCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    imageCell.profileImageView.image = croppedImage;
    [imageCell.profileImageView reveal];

    _imageChanged = YES;
    [self.tableView reloadData];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SMProfileTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTextCell" ];
    
    switch (indexPath.row) {
        case 0:
        {
            SMProfileImageCell * imageCell =[tableView dequeueReusableCellWithIdentifier:@"ProfileImageCell"];
            if(!imageCell)
            {
                imageCell = (SMProfileImageCell *)[[[NSBundle mainBundle] loadNibNamed:@"SMProfileCell" owner:self options:nil] objectAtIndex:0];
                [imageCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            return imageCell;
           
        }
            break;
        case 1:
        case 2:
        case 3:
        case 4:
        {
            SMProfileTextCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTextCell" ];

            // Configure the cell...
            if(!textCell)
            {
                textCell = (SMProfileTextCell *)[[[NSBundle mainBundle] loadNibNamed:@"SMProfileCell" owner:self options:nil] objectAtIndex:1];
                [textCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            
            switch (indexPath.row) {
                case 1:
                    textCell.textLabel.text = @"昵称";
                    textCell.textView.text = self.nickName;
                    break;
                case 2:
                    textCell.textLabel.text = @"性别";
                    textCell.textView.text = self.gender;

                    break;
                case 3:
                    textCell.textLabel.text = @"地区";
                    textCell.textView.text = self.locationName;

                    break;
                case 4:
                    textCell.textLabel.text = @"简介";
                    textCell.textView.text = self.Bio;
                    
                    break;
                default:
                    break;
            }
            textCell.textLabel.textColor = [UIColor grayColor];
            textCell.textView.font = [UIFont systemFontOfSize:17.0f];
            textCell.textView.textAlignment = NSTextAlignmentRight;

            return textCell;
        }
            break;

            
        default:
            break;
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        if(indexPath.row == 0)
        {
            [self.actionSheet showInView:self.view];
        }
        if(indexPath.row == 1)
        {
            
            [self performSegueWithIdentifier:@"Edit Name" sender:nil];
        }
        else if(indexPath.row == 2)
        {
            [self.genderActionSheet showInView:self.view];
        }
        else if(indexPath.row == 3)
        {
            [self performSegueWithIdentifier:@"Edit Location" sender:nil];

        }
        else if(indexPath.row == 4)
        {
            [self performSegueWithIdentifier:@"Edit Bio" sender:nil];

        }


    
    //FIXME: 没有退出成功的情况
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"Edit Name"])
    {
        if([segue.destinationViewController isKindOfClass:[SMEditNameViewController class]])
        {
            SMEditNameViewController * editName = (SMEditNameViewController * )segue.destinationViewController;
            editName.nickName = self.nickName;
        }
    }
    else if([segue.identifier isEqualToString:@"Edit Bio"])
    {
        if([segue.destinationViewController isKindOfClass:[SMEditBioViewController class]])
        {
            SMEditBioViewController * editBio = (SMEditBioViewController * )segue.destinationViewController;
            editBio.Bio = self.Bio;
        }
    }
    else if([segue.identifier isEqualToString:@"Edit Location"])
    {
        if([segue.destinationViewController isKindOfClass:[SMEditLocationViewController class]])
        {
            SMEditLocationViewController * editLocation = (SMEditLocationViewController * )segue.destinationViewController;
            editLocation.locationName = self.locationName;
        }
    }
}

- (IBAction)doneEditName:(UIStoryboardSegue *)segue
{
    SMEditNameViewController * edit =    segue.sourceViewController;
    self.nickName = edit.nickName;
    [self.tableView reloadData];

}

- (IBAction)doneEditBio:(UIStoryboardSegue *)segue
{
    SMEditBioViewController * edit =    segue.sourceViewController;
    self.Bio = edit.Bio;
    [self.tableView reloadData];
    
}
- (IBAction)doneEditLocation:(UIStoryboardSegue *)segue
{
    SMEditLocationViewController * edit =    segue.sourceViewController;
    self.locationName = edit.locationName;
    [self.tableView reloadData];
    
}




@end
