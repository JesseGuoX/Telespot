//
//  SMCollectionImagePreviewController.m
//  Spot Maps
//
//  Created by JG on 4/21/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMCollectionImagePreviewController.h"
#import "SMImagePreviewCollectionViewCell.h"
#import "RGCardViewLayout.h"
#import <MHNatGeoViewControllerTransition.h>
#import "SMConstants.h"

@interface SMCollectionImagePreviewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@end

static NSString * const reuseIdentifier = @"SMImagePreviewell";
//static NSString * const reuseIdentifier = @"imageCell";
@implementation SMCollectionImagePreviewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = self.collectionView.bounds.size;
//    layout.itemSize = CGSizeMake(100, 100);

    self.collectionView.collectionViewLayout = layout;
    
    
   [self.collectionView registerNib:[UINib nibWithNibName:@"SMImagePreviewCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    

}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissNatGeoViewController];

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.collectionArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMImagePreviewCollectionViewCell *cell = (SMImagePreviewCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    [self configureCell:cell withIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blueColor];
    cell.imageView.file = [[self.collectionArray objectAtIndex:indexPath.row] objectForKey:kTSPActivityPostKey];
    [cell.imageView loadInBackground];
    self.titleLable.text = [NSString stringWithFormat:@"By %@", ((PFUser *)[[self.collectionArray objectAtIndex:indexPath.row] objectForKey:kTSPActivityFromUserKey]).username] ;
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.frame.size;
}



@end
