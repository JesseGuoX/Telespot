//
//  WXConstants.h
//  Wheex
//
//  Created by JG on 3/14/15.
//  Copyright (c) 2015 JG. All rights reserved.
//

#ifndef SpotMaps_SMConstants_h
#define SpotMaps_SMConstants_h

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseUI.h>



#warning need add parse cloud client key and application id
#define CLOUD_CLIENT_KEY
#define CLOUD_APPLICATION_ID

#pragma mark -Local Pin Name
extern NSString *const kTSPTimelinePostPinName ;
extern NSString *const kTSPTimelinePeekPinName ;


#pragma mark - Activity Class
// Class key
extern NSString *const kTSPActivityClassKey ;
// Field keys
extern NSString *const kTSPActivityTypeKey        ;

extern NSString *const kTSPActivityFromUserKey   ;
extern NSString *const kTSPActivityToUserKey     ;
extern NSString *const kTSPActivityToParkKey     ;
extern NSString *const kTSPActivityToSpotKey     ;
extern NSString *const kTSPActivityToPinKey      ;
extern NSString *const kTSPActivityToShopKey      ;

extern NSString *const kTSPActivityStickToObject;

extern NSString *const kTSPActivityPostKey        ;

// Type values

extern NSString *const kTSPActivityTypeLike           ;
extern NSString *const kTSPActivityTypeFollow         ;
extern NSString *const kTSPActivityTypeComment        ;
extern NSString *const kTSPActivityTypeJoined         ;

extern NSString *const kTSPActivityTypeReportWrongInformation;
extern NSString *const kTSPActivityTypeReportPorn      ;
extern NSString *const kTSPActivityTypeReportSteeling  ;
extern NSString *const kTSPActivityTypeReportOther     ;

extern NSString *const kTSPActivityTypeStickOn     ;

#pragma mark - Pin Class
// Class key
extern NSString *const kTSPPinClassKey                ;

// Field keys
extern NSString *const kTSPPinGeoKey                  ;
extern NSString * const KTSPPinGeoHorizontalAccuracy  ;
extern NSString * const KTSPPinGeoVerticalAccuracy    ;

extern NSString *const kTSPPinStayTime                ;

extern NSString *const kTSPPinPosterKey               ;


#pragma mark - Spot Class
// Class key
extern NSString *const kTSPSpotClassKey               ;

// Field keys
extern NSString *const kTSPSpotGeoKey                 ;
extern NSString *const KTSPSpotGeoHorizontalAccuracy  ;
extern NSString *const KTSPSpotGeoVerticalAccuracy    ;
extern NSString *const kTSPSpotNameKey                  ;
extern NSString *const kTSPSpotPosterKey              ;

//extern NSString *const kTSPSpotPhotoKey               ;
//extern NSString *const kTSPSpotPhotoThumbnailKey      ;
extern NSString *const kTSPSpotDescriptionKey         ;

#pragma mark - Park Class
// Class key
extern NSString *const kTSPParkClassKey               ;

extern NSString *const kTSPParkPosterKey              ;

// Field keys
extern NSString *const kTSPParkNameKey              ;
extern NSString *const kTSPParkCityKey           	;
extern NSString *const kTSPParkAddressKey           ;
extern NSString *const kTSPParkChargeTypeKey          ;
extern NSString *const kTSPParkInOrOutTypeKey         ;

extern NSString * const kTSPParkVerified            ;

extern NSString *const kTSPParkGeoKey           	;
extern NSString *const KTSParkGeoHorizontalAccuracy   ;
extern NSString *const KTSParkGeoVerticalAccuracy     ;


//extern NSString *const kTSPParkPhotoKey               ;
//extern NSString *const kTSPParkPhotoThumbnailKey      ;
extern NSString *const kTSPParkDescriptionKey         ;


//Type keys
extern NSString *const kTSPParkChargeTypeFree         ;
extern NSString *const kTSPParkChargeTypePay          ;
extern NSString *const kTSPParkChargeTypeUnknow       ;

extern NSString *const kTSPParkInOrOutTypeIndoor      ;
extern NSString *const kTSPParkInOrOutTypeoOutdoor    ;
extern NSString *const kTSPParkInOrOutTypeBoth        ;

#pragma mark - Shop Class
// Class key
extern NSString *const kTSPShopClassKey               ;

extern NSString *const kTSPShopPosterKey              ;

// Field keys
extern NSString *const kTSPShopNameKey              ;
extern NSString *const kTSPShopCityKey           	;
extern NSString *const kTSPShopAddressKey           ;

extern NSString * const kTSPShopVerified            ;


extern NSString *const kTSPShopGeoKey           	;
extern NSString *const KTSShopGeoHorizontalAccuracy   ;
extern NSString *const KTSShopGeoVerticalAccuracy     ;


//extern NSString *const kTSPShopPhotoKey               ;
//extern NSString *const kTSPShopPhotoThumbnailKey      ;
extern NSString *const kTSPShopDescriptionKey         ;


#pragma mark - User Class
// Field keys
extern NSString *const kTSPUserDisplayNameKey                         ;
extern NSString *const kTSPUserGenderKey                              ;

extern NSString *const kTSPUserDescriptionKey                         ;
extern NSString *const kTSPUserProfilePicKey                          ;
extern NSString *const kTSPUserProfilePicThumbnailKey                 ;
extern NSString *const kTSPUserLocationKey                            ;

extern NSString *const kTSPUserContributionKey                        ;

#pragma mark - Post Class

// Class key
extern NSString *const kTSPPostClassKey            ;

// Field keys
extern NSString *const kTSPPostDescriptionKey      ;
extern NSString *const kTSPPostPosterKey           ;
extern NSString *const kTSPPostTypeKey             ;
extern NSString *const kTSPPostPhotoKey            ;
extern NSString *const kTSPPostPhotoThumbnailKey       ;
extern NSString *const kTSPPostVideoKey            ;

extern NSString *const kTSPPostGeoKey              ;
extern NSString *const kTSPPostGeoNameKey          ;

//Type values
extern NSString *const kTSPPostTypeVideo           ;
extern NSString *const kTSPPostTypePhoto           ;

#pragma mark -FilterProperty
extern NSString * const KTSPParkProperty ;
extern NSString * const KTSPPinProperty ;
extern NSString * const KTSPSpotProperty ;
extern NSString * const KTSPShopProperty;
#endif
