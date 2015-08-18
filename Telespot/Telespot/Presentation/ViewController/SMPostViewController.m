//
//  SMPostViewController.m
//  Spot Maps
//
//  Created by JG on 4/18/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMPostViewController.h"
#import "IGAssetsCollectionViewCell.h"
#import <Masonry.h>
#import "AppMacros.h"
#import "SMImageThumbView.h"
#import "SMImagePreviewViewController.h"
#import <SZTextView.h>
#import "NSDate+StringDisplayOnPost.h"
#import <MBProgressHUD.h>
#import "SMUtility.h"

@interface SMPostViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, SMImageThumbViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) IBOutlet UIButton *pickerButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintPickerBottom;
@property (strong, nonatomic) IBOutlet SZTextView *textView;
@property (strong, nonatomic) UIImagePickerController * pickerController;

@property (strong, nonatomic) SMImageThumbView * imageThumb;
@property (strong, nonatomic) UIImage * selectImage;
@property ( nonatomic) BOOL thumbSelected;

@property (nonatomic, strong) MBProgressHUD * hud;
@property (nonatomic) __block BOOL uploadSuccess;

@end

@implementation SMPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUpForDismissKeyboard];
//    [self loadPhotos];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(post:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.textView.delegate  = self;
    self.textView.placeholder = @"说点什么!";
    self.textView.placeholderTextColor = [UIColor lightGrayColor];
    self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    self.textView.textColor = [UIColor blackColor];
    
    self.pickerController = [[UIImagePickerController alloc] init];
    self.pickerController.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];

    
    [self.view addSubview:self.collectionView];
    WS(ws);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view.mas_left);
        make.right.mas_equalTo(ws.view.mas_right);
        make.bottom.mas_equalTo(ws.view.mas_bottom);
        make.top.mas_equalTo(ws.view.mas_bottom);
    }];
    
    self.imageThumb = [[SMImageThumbView alloc] initWithFrame:CGRectZero];
    self.imageThumb.delegate = self;
    [self.view addSubview:self.imageThumb];
    [self.imageThumb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.textView.mas_left);
        make.top.mas_equalTo(ws.textView.mas_bottom);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
    }];
    self.imageThumb.hidden = YES;
    [self.view layoutIfNeeded];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self addObserver:self forKeyPath:@"thumbSelected" options:NSKeyValueObservingOptionNew context:nil];


}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self removeObserver:self forKeyPath:@"thumbSelected"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (MBProgressHUD *)hud
{
    if(!_hud)
    {
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.mode = MBProgressHUDModeAnnularDeterminate;
        _hud.dimBackground = YES;
        _hud.delegate = self;
    }
    return _hud;
}


-(void)post:(id)sender
{
    [self.view endEditing:YES];

    self.hud.labelText = @"正在上传";
    [self.hud show:YES];
    WS(ws);
    [SMUtility saveActivityOnObject:self.object withImage:self.selectImage withDesciption:self.textView.text withLocation:nil completionBlock:^(BOOL succeeded, NSError * __nullable error) {
        if(succeeded)
        {
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UploadCheckMark"]];
            ws.hud.customView = imageView;
            ws.hud.mode = MBProgressHUDModeCustomView;
            ws.hud.labelText = @"上传成功";
            [ws.hud hide:YES afterDelay:2];
            ws.uploadSuccess = YES;
        }
        else
        {
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UploadFailedMark"]];
            ws.hud.customView = imageView;
            ws.hud.mode = MBProgressHUDModeCustomView;
            ws.hud.labelText = @"上传失败";
            [ws.hud show:YES];
            [ws.hud hide:YES afterDelay:2];
        }
    } progressBlock:^(int precent) {
        ws.hud.progress = (float)precent/100;

    }];

}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self showPostButton];
}

- (NSMutableArray *)assets {
    if (_assets == nil) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (void)loadPhotos {
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets insertObject:result atIndex:0];
        }
        
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
        
        if (group == nil) {
            if (self.assets.count) {
//                ALAsset * asset = [self.assets objectAtIndex:0];
//                [self.cropView setAlAsset:asset];
            }
            [self.collectionView reloadData];
        }
        
        
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        NSLog(@"Load Photos Error: %@", error);
    }];
    
    
}

-(UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        CGFloat colum = 4.0, spacing = 2.0;
        CGFloat value = floorf((CGRectGetWidth(self.view.bounds) - (colum - 1) * spacing) / colum);
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake(value, value);
        layout.sectionInset                 = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[IGAssetsCollectionViewCell class] forCellWithReuseIdentifier:@"IGAssetsCollectionViewCell"];
        


    }
    return _collectionView;
}


- (IBAction)pickerButtonPressed:(id)sender {

    [self showCollection];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    
    if(self.uploadSuccess)
    {
        self.uploadSuccess = false;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage * image =[info objectForKey:UIImagePickerControllerOriginalImage];
    self.selectImage = image;
    self.imageThumb.image = image;
    self.thumbSelected = YES;
    [self.textView becomeFirstResponder];
}


#pragma mark --UITextViewDelegate

- (void)keyboardFrameDidChange:(NSNotification *)notification
{
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
//    CGRect newFrame = self.commentView.frame;
//    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
//    CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
    
//    newFrame.origin.y = keyboardFrameEnd.origin.y - keyboardFrameEnd.origin.y ;
    
    
    self.constraintPickerBottom.constant = keyboardEndFrame.size.height;
    
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    
    
}



-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self showPickerButtonOrThumb];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self showPostButton];
}

- (void)showPostButton
{
    if(self.textView.text.length > 0 )
    {
        if(self.thumbSelected)
            self.navigationItem.rightBarButtonItem.enabled = YES;
        else
            self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
        self.navigationItem.rightBarButtonItem.enabled = NO;

}

-(void)showPickerButtonOrThumb
{
    if(!self.thumbSelected)
    {
        self.pickerButton.hidden = NO;
        self.imageThumb.hidden = YES;

    }
    else
    {
        self.imageThumb.hidden = NO;
        self.pickerButton.hidden = YES;

    }
    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view.mas_left);
            make.right.mas_equalTo(ws.view.mas_right);
            make.bottom.mas_equalTo(ws.view.mas_bottom);
            make.top.mas_equalTo(ws.view.mas_bottom);
        }];
        [self.view layoutIfNeeded];
    }];

    
}

-(void)showCollection
{
    WS(ws);
    self.pickerButton.hidden = YES;
    self.imageThumb.hidden = YES;
    [self loadPhotos];
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.view.mas_left);
            make.right.mas_equalTo(ws.view.mas_right);
            make.bottom.mas_equalTo(ws.view.mas_bottom);
            make.top.mas_equalTo(ws.textView.mas_bottom);
        }];
        [self.view layoutIfNeeded];
    }];
}



#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IGAssetsCollectionViewCell";
    
    if(indexPath.row == 0)
    {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        UIImageView * imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_pick"]];
        imageview.center = cell.center;
        [cell addSubview:imageview];
        cell.backgroundColor = [UIColor blackColor];
        return cell;
    }
    else
    {
        IGAssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell applyAsset:[self.assets objectAtIndex:indexPath.row-1]];
        return cell;
    }

}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ALAsset * asset = [self.assets objectAtIndex:indexPath.row - 1];
    
    if(indexPath.row == 0)
    {
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:self.pickerController animated:YES completion:^{
            
        }];
    }
    else
    {
        UIImage * image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        self.selectImage = image;
        self.imageThumb.image = [UIImage imageWithCGImage:asset.thumbnail];
        self.thumbSelected = YES;
        [self.textView becomeFirstResponder];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -SMImageThumbDelegate
-(void)touchedOnThumbView:(SMImageThumbView *)view inDeleteArea:(BOOL)isin
{
    if(isin)
    {
        self.thumbSelected = NO;
        [self showPickerButtonOrThumb];
    }
    else
    {
        [self performSegueWithIdentifier:@"Preview Image" sender:nil];
    }
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSLog(@"velocity:%f", velocity.y);
//    if (velocity.y >= 2.0 && self.topView.frame.origin.y == 0) {
//        [self tapGestureAction:nil];
//    }
//}

/*
#pragma mark - Navigation
*/
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.destinationViewController isKindOfClass:[SMImagePreviewViewController class]])
    {
        SMImagePreviewViewController * viewController = segue.destinationViewController;
        viewController.image = self.selectImage;
//        viewController.image = [UIImage imageNamed:@"loading_finished"];
    }
}


@end
