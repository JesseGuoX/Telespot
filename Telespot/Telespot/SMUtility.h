//
//  TSPUtility.h
//  Wheex
//
//  Created by JG on 3/17/15.
//  Copyright (c) 2015 JG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMConstants.h"

@interface SMUtility : NSObject

+ (void)savePinInLocation:(CLLocation *)location withMins:(int) mins blocks:(void (^)(PFObject * pinObject, BOOL succeeded, NSError *PF_NULLABLE_S error))block;


+(PFQuery *)queryForActivityCurrentUserIsLikedPost:(PFObject *)post;
+(PFQuery *)queryForActivityIsLikedPost:(PFObject *)post;

+(PFQuery *)queryForActivityOnObject:(PFObject *)object;

+(void)likePostEventually:(id)post;
+(void)unlikePostEventually:(id)post;

+ (void)likePostInBackground:(id)post block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unlikePostInBackground:(id)post block:(void (^)(BOOL succeeded, NSError *error))completionBlock;


+ (BOOL)userHasProfilePictures:(PFUser *)user;

+ (UIImage *)defaultProfilePicture;
+(void)saveReport:(NSString *)kindClass withLocation:(CLLocation * )location withName:(NSString *)name withDescription:(NSString *)description withImage:(UIImage *)postImage completionBlock:(void (^)(PFObject * object ,BOOL succeeded, NSError *PF_NULLABLE_S error))completionBlock;
+(void)saveActivityOnObject:(id)object withImage:(UIImage * )image  withDesciption:(NSString *)description withLocation:(CLLocation * )location completionBlock:(void (^)(BOOL succeeded, NSError *PF_NULLABLE_S error))completionBlock progressBlock:(void(^)(int precent))progressBlock;


@end
