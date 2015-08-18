//
//  WXConstant.m
//  Wheex
//
//  Created by JG on 3/14/15.
//  Copyright (c) 2015 JG. All rights reserved.
//

#import "SMConstants.h"


#pragma mark -Local Pin Name
NSString *const kTSPTimelinePostPinName = @"PinTimelinePost";
NSString *const kTSPTimelinePeekPinName = @"PinTimelinePeek";

#pragma mark - Activity Class
// Class key
NSString *const kTSPActivityClassKey = @"Activity";

// Field keys
NSString *const kTSPActivityTypeKey        = @"type";

NSString *const kTSPActivityFromUserKey    = @"fromUser";
NSString *const kTSPActivityToUserKey      = @"toUser";
NSString *const kTSPActivityToParkKey      = @"toPark";
NSString *const kTSPActivityToSpotKey      = @"toSpot";
NSString *const kTSPActivityToPinKey       = @"toPin";
NSString *const kTSPActivityToShopKey       = @"toShop";
NSString *const kTSPActivityStickToObject   = @"sticToObject";


NSString *const kTSPActivityPostKey                = @"post";


// Type values

NSString *const kTSPActivityTypeLike            = @"like";
NSString *const kTSPActivityTypeFollow          = @"follow";
NSString *const kTSPActivityTypeComment         = @"comment";
NSString *const kTSPActivityTypeJoined          = @"joined";
NSString *const kTSPActivityTypeStickOn         = @"stickOn";
NSString *const kTSPActivityTypeReportWrongInformation = @"reportWrongInformation";
NSString *const kTSPActivityTypeReportPorn      = @"reportPorn";
NSString *const kTSPActivityTypeReportSteeling  = @"reportSteeling";
NSString *const kTSPActivityTypeReportOther     = @"reportOther";




#pragma mark - Pin Class
// Class key
NSString *const kTSPPinClassKey                 = @"Pin";

// Field keys
NSString *const kTSPPinGeoKey                    = @"geo";
NSString * const KTSPPinGeoHorizontalAccuracy    = @"horizontalAccuracy";
NSString * const KTSPPinGeoVerticalAccuracy      = @"verticalAccuracy";

NSString *const kTSPPinStayTime                 = @"stayTime";

NSString *const kTSPPinPosterKey                = @"poster";


#pragma mark - Spot Class
// Class key
NSString *const kTSPSpotClassKey                 = @"Spot";

// Field keys
NSString *const kTSPSpotGeoKey                   = @"geo";
NSString *const KTSPSpotGeoHorizontalAccuracy    = @"horizontalAccuracy";
NSString *const KTSPSpotGeoVerticalAccuracy      = @"verticalAccuracy";
NSString *const kTSPSpotNameKey              	 = @"name";


NSString *const kTSPSpotPosterKey                = @"poster";

//NSString *const kTSPSpotPhotoKey                = @"photo";
//NSString *const kTSPSpotPhotoThumbnailKey       = @"photoThumbnail";
NSString *const kTSPSpotDescriptionKey          = @"description";

#pragma mark - Park Class
// Class key
NSString *const kTSPParkClassKey               = @"Skatepark";

NSString *const kTSPParkPosterKey                = @"poster";

// Field keys
NSString *const kTSPParkNameKey              		= @"name";
NSString *const kTSPParkCityKey           			= @"city";
NSString *const kTSPParkAddressKey           		= @"Address";
NSString *const kTSPParkChargeTypeKey           	= @"chargeType";
NSString *const kTSPParkInOrOutTypeKey           	= @"indoorType";
NSString * const kTSPParkVerified                   = @"verified";

NSString *const kTSPParkGeoKey           			= @"geo";
NSString *const KTSParkGeoHorizontalAccuracy        = @"horizontalAccuracy";
NSString *const KTSParkGeoVerticalAccuracy          = @"verticalAccuracy";


//NSString *const kTSPParkPhotoKey                = @"photo";
//NSString *const kTSPParkPhotoThumbnailKey       = @"photoThumbnail";
NSString *const kTSPParkDescriptionKey          = @"description";


//Type keys
NSString *const kTSPParkChargeTypeFree           	= @"free";
NSString *const kTSPParkChargeTypePay            	= @"pay";
NSString *const kTSPParkChargeTypeUnknow            = @"unknow";

NSString *const kTSPParkInOrOutTypeIndoor           = @"indoor";
NSString *const kTSPParkInOrOutTypeoOutdoor         = @"outdoor";
NSString *const kTSPParkInOrOutTypeBoth          	= @"inOrOutBoth";

#pragma mark - Shop Class
// Class key
NSString *const kTSPShopClassKey               = @"Shop";

NSString *const kTSPShopPosterKey                = @"poster";

// Field keys
NSString *const kTSPShopNameKey              		= @"name";
NSString *const kTSPShopCityKey           			= @"city";
NSString *const kTSPShopAddressKey           		= @"Address";
NSString * const kTSPShopVerified                   = @"verified";

NSString *const kTSPShopGeoKey           			= @"geo";
NSString *const KTSShopGeoHorizontalAccuracy        = @"horizontalAccuracy";
NSString *const KTSShopGeoVerticalAccuracy          = @"verticalAccuracy";


//NSString *const kTSPShopPhotoKey                = @"photo";
//NSString *const kTSPShopPhotoThumbnailKey       = @"photoThumbnail";
NSString *const kTSPShopDescriptionKey          = @"description";


#pragma mark - User Class
// Field keys
NSString *const kTSPUserDisplayNameKey                         = @"username";
NSString *const kTSPUserGenderKey                              = @"gender";

NSString *const kTSPUserDescriptionKey                         = @"description";
NSString *const kTSPUserProfilePicKey                          = @"profilePic";
NSString *const kTSPUserProfilePicThumbnailKey                 = @"profilePicThumbnail";
NSString *const kTSPUserLocationKey                            = @"profileLocation";

NSString *const kTSPUserContributionKey                         = @"contributionCounter";

#pragma mark - Post Class

// Class key
NSString *const kTSPPostClassKey               = @"Post";

// Field keys
NSString *const kTSPPostDescriptionKey          = @"description";
NSString *const kTSPPostPosterKey               = @"poster";
NSString *const kTSPPostTypeKey                 = @"type";
NSString *const kTSPPostPhotoKey                = @"photo";
NSString *const kTSPPostPhotoThumbnailKey       = @"photoThumbnail";
NSString *const kTSPPostVideoKey                = @"video";

NSString *const kTSPPostGeoKey                  = @"geo";
NSString *const kTSPPostGeoNameKey              = @"geoName";

//Type values
NSString *const kTSPPostTypeVideo           = @"video";
NSString *const kTSPPostTypePhoto           = @"photo";

//#pragma mark - Peek Class
//// Class key
//NSString *const kTSPPeekClassKey                = @"Peek";
//
//// Field keys
//NSString *const kTSPPeekDescriptionKey            = @"description";
//NSString *const kTSPPeekCenterKey                 = @"center";
//NSString *const kTSPPeekRadiusKey                 = @"radius";
//NSString *const kTSPPeekPosterKey                 = @"poster";

//#pragma mark - Post Class
//// Class key
//NSString *const kTSPPostClassKey               = @"Post";
//
//// Field keys
//NSString *const kTSPPostDescriptionKey          = @"description";
//NSString *const kTSPPostPosterKey               = @"poster";
//NSString *const kTSPPostTypeKey                 = @"type";
//NSString *const kTSPPostPhotoKey                = @"photo";
//NSString *const kTSPPostPhotoThumbnailKey       = @"photoThumbnail";
//NSString *const kTSPPostVideoKey                = @"video";
//NSString *const kTSPPostGeoKey                  = @"geo";
//NSString *const kTSPPostGeoNameKey              = @"geoName";
//
////Type values
//NSString *const kTSPPostTypeVideo           = @"video";
//NSString *const kTSPPostTypePhoto           = @"photo";

#pragma mark -FilterProperty
NSString * const KTSPParkProperty = @"SkatePark";
NSString * const KTSPPinProperty = @"Pin";
NSString * const KTSPSpotProperty = @"SkateSpot";
NSString * const KTSPShopProperty = @"Shop";


