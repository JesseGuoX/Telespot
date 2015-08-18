//
//  TSPUtility.m
//  Wheex
//
//  Created by JG on 3/17/15.
//  Copyright (c) 2015 JG. All rights reserved.
//

#import "SMUtility.h"
#import "AppMacros.h"

@implementation SMUtility

+ (void)savePinInLocation:(CLLocation *)location withMins:(int) mins blocks:(void (^)(PFObject * pinObject, BOOL succeeded, NSError *PF_NULLABLE_S error))block
{
    PFGeoPoint * geoPoint = [PFGeoPoint geoPointWithLocation:location];
    PFObject * pin = [PFObject objectWithClassName:kTSPPinClassKey];
    [pin setObject:geoPoint forKey:kTSPPinGeoKey];
    [pin setObject:@(location.horizontalAccuracy) forKey:KTSPPinGeoHorizontalAccuracy];
    [pin setObject:@(location.verticalAccuracy) forKey:KTSPPinGeoVerticalAccuracy];
    [pin setObject:@(mins) forKey:kTSPPinStayTime];
    [pin setObject:[PFUser currentUser] forKey:kTSPPinPosterKey];
    [pin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error)
     {
         block(pin, succeeded, error);
     }];
}


+(void)saveReport:(NSString *)kindClass withLocation:(CLLocation * )location withName:(NSString *)name withDescription:(NSString *)description withImage:(UIImage *)postImage completionBlock:(void (^)(PFObject * object ,BOOL succeeded, NSError *PF_NULLABLE_S error))completionBlock
{
    NSString * classString;
    NSString * posterString;
    NSString * descriptionString;
    NSString * geoString;
    NSString * activityToString;
    NSString * activityTypeString;
    NSString * nameString;

    if([kindClass isEqualToString:kTSPSpotClassKey])//spot
    {
        classString         = kTSPSpotClassKey;
        posterString        = kTSPSpotPosterKey;
        descriptionString   = kTSPSpotDescriptionKey;
        geoString           = kTSPSpotGeoKey;
        activityToString    = kTSPActivityToSpotKey;
        nameString          = kTSPSpotNameKey;
//        activityTypeString  = kTSPActivityTypeStickOnSpot;
    }
    else if([kindClass isEqualToString:kTSPShopClassKey])//shop
    {
        classString         = kTSPShopClassKey;
        posterString        = kTSPShopPosterKey;
        descriptionString   = kTSPShopDescriptionKey;
        geoString           = kTSPShopGeoKey;
        activityToString    = kTSPActivityToShopKey;
        nameString          = kTSPShopNameKey;

//        activityTypeString  = kTSPActivityTypeStickOnShop;
    }
    else if([kindClass isEqualToString:kTSPParkClassKey])//park
    {
        classString         = kTSPParkClassKey;
        posterString        = kTSPParkPosterKey;
        descriptionString   = kTSPParkDescriptionKey;
        geoString           = kTSPParkGeoKey;
        activityToString    = kTSPActivityToParkKey;
        nameString          = kTSPParkNameKey;

//        activityTypeString  = kTSPActivityTypeStickOnPark;
    }
    else
    {
        return;
    }
    
    PFObject * spot = [PFObject objectWithClassName:classString];
    [spot setObject:[PFUser currentUser] forKey:posterString];
    [spot setObject:description forKey:descriptionString];
    PFGeoPoint * geo = [PFGeoPoint geoPointWithLocation:location];
    [spot setObject:geo forKey:geoString];
    [spot setObject:name forKey:nameString];
    [spot saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error)
     {
         if(succeeded && (!error))
         {
             PFFile * image = [PFFile fileWithName:@"file" data:UIImageJPEGRepresentation(postImage, kDefPostCompressFactor) contentType:@"jpg"];
             [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error)
              {
                  if(succeeded && (!error))
                  {
                      PFFile * imageThumbnail =[PFFile fileWithName:@"thumbnailFile" data:UIImageJPEGRepresentation(postImage, kDefPostThumbnailCompressFactor) contentType:@"jpg"];
                      [imageThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error)
                       {
                           if(succeeded && (!error))
                           {
                               PFObject *post = [PFObject objectWithClassName:kTSPPostClassKey];
                               [post setObject:kTSPPostTypePhoto forKey:kTSPPostTypeKey];
                               [post setObject:description forKey:kTSPPostDescriptionKey];
                               [post setObject:geo forKey:kTSPPostGeoKey];
                               [post setObject:image forKey:kTSPPostPhotoKey];
                               [post setObject:imageThumbnail forKey:kTSPPostPhotoThumbnailKey];
                               [post  saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error)
                                {
                                    if(succeeded && (!error))
                                    {
                                        PFObject * activity = [PFObject objectWithClassName:kTSPActivityClassKey];
                                        [activity setObject:kTSPActivityTypeStickOn forKey:kTSPActivityTypeKey];
                                        [activity setObject:post forKey:kTSPActivityPostKey];
                                        [activity setObject:spot forKey:activityToString];
                                        [activity setObject:[PFUser currentUser] forKey:kTSPActivityFromUserKey];
                                        [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error)
                                         {
                                             completionBlock(spot, succeeded, error);
                                             
                                         }];
                                    }
                                    else
                                    {
                                        completionBlock(nil, succeeded, error);
                                    }
                                    
                                }];
                               
                           }
                           else
                           {
                               completionBlock(nil, succeeded, error);
                               
                           }
                       }];
                  }
                  else
                  {
                      completionBlock(nil, succeeded, error);
                      
                  }
              }];
             
             
         }
         else
         {
             completionBlock(nil, succeeded, error);
         }
         
     }];
    

}

//为地点之类的添加照片
+(void)saveActivityOnObject:(id)object withImage:(UIImage * )image  withDesciption:(NSString *)description  withLocation:(CLLocation * )location  completionBlock:(void (^)(BOOL succeeded, NSError *PF_NULLABLE_S error))completionBlock progressBlock:(void(^)(int precent))progressBlock

{
    PFGeoPoint * geo = [PFGeoPoint geoPointWithLocation:location];
    PFFile * file = [PFFile fileWithName:@"file" data:UIImageJPEGRepresentation(image, kDefPostCompressFactor) contentType:@"jpg"];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Handle success or failure here ...
        if(succeeded)
        {
          PFFile * imageThumbnail =[PFFile fileWithName:@"thumbnailFile" data:UIImageJPEGRepresentation(image, kDefPostThumbnailCompressFactor) contentType:@"jpg"];
            [imageThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error)
            {
                if(succeeded)
                {
                    PFObject * post = [PFObject objectWithClassName:kTSPPostClassKey];
                    [post setObject:description forKey:kTSPPostDescriptionKey];
                    [post setObject:file forKey:kTSPPostPhotoKey];
                    [post setObject:imageThumbnail forKey:kTSPPostPhotoThumbnailKey];
                    [post setObject:kTSPPostTypePhoto forKey:kTSPPostTypeKey];
                    [post setObject:geo forKey:kTSPPostGeoKey];
                    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error)
                     {
                         
                         if(succeeded)
                         {
                             progressBlock(95);
                             
                             PFObject * activity = [PFObject objectWithClassName:kTSPActivityClassKey];
                             
                             [activity setObject:kTSPActivityTypeStickOn forKey:kTSPActivityTypeKey];
                             [activity setObject:post forKey:kTSPActivityPostKey];
                             if([[object parseClassName] isEqualToString:kTSPParkClassKey])//park
                             {
                                 
                                 [activity setObject:object forKey:kTSPActivityToParkKey];
                                 
                             }
                             else if([[object parseClassName] isEqualToString:kTSPShopClassKey])//shop
                             {
                                 
                                 [activity setObject:object forKey:kTSPActivityToShopKey];
                                 
                             }
                             else if([[object parseClassName] isEqualToString:kTSPPinClassKey])//pin
                             {
                                 
                             }
                             else if([[object parseClassName] isEqualToString:kTSPSpotClassKey])//spot
                             {
                                 
                                 [activity setObject:object forKey:kTSPActivityToSpotKey];
                                 
                             }
                             
                             [activity setObject:[PFUser currentUser] forKey:kTSPActivityFromUserKey];
                             [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                 progressBlock(100);
                                 completionBlock(succeeded, error);
                             }];
                         }
                         else
                         {
                             completionBlock(succeeded, error);
                             
                         }
                         
                     }];

                }else
                {
                    completionBlock(succeeded, error);

                }
                
            }];
            
        }
        else{
            completionBlock(succeeded, error);
            }
    }progressBlock:^(int percentDone){
        if(percentDone < 90)
            progressBlock(percentDone);
    }];
}

//返回spot，park等上面的活动
+(PFQuery *)queryForActivityOnObject:(PFObject *)object
{
    NSString * activityToString;
    if([[object parseClassName] isEqualToString:kTSPParkClassKey])//park
    {
        activityToString = kTSPActivityToParkKey;
        
    }
    else if([[object parseClassName] isEqualToString:kTSPShopClassKey])//shop
    {

        activityToString = kTSPActivityToShopKey;

    }
    else if([[object parseClassName] isEqualToString:kTSPPinClassKey])//pin
    {
        
    }
    else if([[object parseClassName] isEqualToString:kTSPSpotClassKey])//spot
    {
        activityToString = kTSPActivityToSpotKey;
    }
    
    PFQuery * activityQuery = [PFQuery queryWithClassName:kTSPActivityClassKey];
    [activityQuery whereKey:activityToString equalTo:object];
    return activityQuery;
}

+(PFQuery *)queryForActivityCurrentUserIsLikedPost:(PFObject *)post
{
    if([PFUser currentUser])
    {
        PFQuery * likedQuery = [PFQuery queryWithClassName:kTSPActivityClassKey];
        [likedQuery whereKey:kTSPActivityTypeKey equalTo:kTSPActivityTypeLike];
        [likedQuery whereKey:kTSPActivityPostKey equalTo:post];
        [likedQuery whereKey:kTSPActivityFromUserKey equalTo:[PFUser currentUser]];
        return likedQuery;
    }
    else{
        PFQuery *query = [PFQuery queryWithClassName:kTSPActivityClassKey];
        [query setLimit:0];
        return query;
    }
}

+(PFQuery *)queryForActivityIsLikedPost:(PFObject *)post
{
    PFQuery * likeQuery = [PFQuery queryWithClassName:kTSPActivityClassKey];
    [likeQuery whereKey:kTSPActivityTypeKey equalTo:kTSPActivityTypeLike];
    [likeQuery whereKey:kTSPActivityPostKey equalTo:post];
    [likeQuery whereKeyExists:kTSPActivityFromUserKey];
    
    return likeQuery;
}





+(void)likePostEventually:(id)post
{
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kTSPActivityClassKey];
    [queryExistingLikes fromLocalDatastore];
    [queryExistingLikes whereKey:kTSPActivityPostKey equalTo:post];
    [queryExistingLikes whereKey:kTSPActivityTypeKey equalTo:kTSPActivityTypeLike];
    [queryExistingLikes whereKey:kTSPActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteEventually];
            }
        }
        
        // proceed to creating new like
        PFObject *likeActivity = [PFObject objectWithClassName:kTSPActivityClassKey];
        [likeActivity setObject:kTSPActivityTypeLike forKey:kTSPActivityTypeKey];
        [likeActivity setObject:[PFUser currentUser] forKey:kTSPActivityFromUserKey];
        [likeActivity setObject:[post objectForKey:kTSPPostPosterKey] forKey:kTSPActivityToUserKey];
        [likeActivity setObject:post forKey:kTSPActivityPostKey];
        
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        [likeACL setWriteAccess:YES forUser:[post objectForKey:kTSPPostPosterKey]];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveEventually];
    }];
}


+(void)likePostInBackground:(id)post block:(void (^)(BOOL, NSError *))completionBlock
{
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kTSPActivityClassKey];
    [queryExistingLikes whereKey:kTSPActivityPostKey equalTo:post];
    [queryExistingLikes whereKey:kTSPActivityTypeKey equalTo:kTSPActivityTypeLike];
    [queryExistingLikes whereKey:kTSPActivityFromUserKey equalTo:[PFUser currentUser]];
//    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
        }
        
        // proceed to creating new like
        PFObject *likeActivity = [PFObject objectWithClassName:kTSPActivityClassKey];
        [likeActivity setObject:kTSPActivityTypeLike forKey:kTSPActivityTypeKey];
        [likeActivity setObject:[PFUser currentUser] forKey:kTSPActivityFromUserKey];
//        [likeActivity setObject:[post objectForKey:kTSPPostPosterKey] forKey:kTSPActivityToUserKey];
        [likeActivity setObject:post forKey:kTSPActivityPostKey];
        
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
//        [likeACL setWriteAccess:YES forUser:[post objectForKey:kTSPPostPosterKey]];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
            
        }];
    }];
}


+(void)unlikePostEventually:(id)post
{
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kTSPActivityClassKey];
    [queryExistingLikes whereKey:kTSPActivityPostKey equalTo:post];
    [queryExistingLikes whereKey:kTSPActivityTypeKey equalTo:kTSPActivityTypeLike];
    [queryExistingLikes whereKey:kTSPActivityFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteEventually];
            }
        }
        
    }];
}



+(void)unlikePostInBackground:(id)post block:(void (^)(BOOL, NSError *))completionBlock
{
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kTSPActivityClassKey];
    [queryExistingLikes whereKey:kTSPActivityPostKey equalTo:post];
    [queryExistingLikes whereKey:kTSPActivityTypeKey equalTo:kTSPActivityTypeLike];
    [queryExistingLikes whereKey:kTSPActivityFromUserKey equalTo:[PFUser currentUser]];
//    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
        }
        
    }];
}



+(BOOL)userHasProfilePictures:(PFUser *)user
{
    PFFile *profilePictureMedium = [user objectForKey:kTSPUserProfilePicKey];
    PFFile *profilePictureSmall = [user objectForKey:kTSPUserProfilePicThumbnailKey];
    
    return (profilePictureMedium && profilePictureSmall);
}

+(UIImage *)defaultProfilePicture
{
    return  [UIImage imageNamed:@"default_avatar"];
}







@end
