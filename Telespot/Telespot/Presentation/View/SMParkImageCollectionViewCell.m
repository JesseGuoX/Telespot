//
//  SMParkImageCollectionViewCell.m
//  Spot Maps
//
//  Created by JG on 4/6/15.
//  Copyright (c) 2015 TeleSpot. All rights reserved.
//

#import "SMParkImageCollectionViewCell.h"
#import <UIImageView+RJLoader.h>
#import <ParseUI.h>
#import "AppMacros.h"
#import "SMUtility.h"
@interface SMParkImageCollectionViewCell()


@end
@implementation SMParkImageCollectionViewCell

-(void)setActivity:(PFObject *)activity
{
    WS(ws);
    _activity = activity;
    self.nameLable.text = [NSString stringWithFormat:@"By %@", ((PFUser *)[activity objectForKey:kTSPActivityFromUserKey]).username];
    PFObject * post = [activity objectForKey:kTSPActivityPostKey];
    [post fetchIfNeeded];
    PFFile * file = [post objectForKey:kTSPPostPhotoThumbnailKey];
    if(!file.isDataAvailable)
    {
        [self.imageView startLoader];
        
        [file getDataInBackgroundWithBlock:^(NSData *PF_NULLABLE_S data, NSError *PF_NULLABLE_S error){
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [ws.imageView setImage:[UIImage imageWithData:data]];
                    [ws.imageView reveal];
                });
            }
        }progressBlock:^(int percentDone){
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [ws.imageView updateImageDownloadProgress:percentDone/100.f];
            });
        }];
    }else
    {
        [ws.imageView setImage:[UIImage imageWithData:file.getData]];

    }


    PFQuery * query = [SMUtility queryForActivityIsLikedPost:post];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *PF_NULLABLE_S error)
     {
         if(!error)
         {
             ws.favoriteCountLable.text = [self suffixNumber:[NSNumber numberWithInt:number]];
         }
     }];
    

}

- (void)refreshLikeCounts
{
    WS(ws);
    PFObject * post = [self.activity objectForKey:kTSPActivityPostKey];
    PFQuery * query = [SMUtility queryForActivityIsLikedPost:post];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *PF_NULLABLE_S error)
     {
         if(!error)
         {
             ws.favoriteCountLable.text = [self suffixNumber:[NSNumber numberWithInt:number]];
         }
     }];
}

-(NSString*) suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"...";
    
    long long num = [number longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log(num) / log(1000));
    
    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%.0f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}

@end
