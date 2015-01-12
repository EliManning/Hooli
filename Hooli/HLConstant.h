//
//  HLConstant.h
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>


#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		PF_INSTALLATION_CLASS_NAME			@"_Installation"		//	Class name
#define		PF_INSTALLATION_OBJECTID			@"objectId"				//	String
#define		PF_INSTALLATION_USER				@"user"					//	Pointer to User Class

#define		PF_USER_CLASS_NAME					@"_User"				//	Class name
#define		PF_USER_OBJECTID					@"objectId"				//	String
#define		PF_USER_USERNAME					@"username"				//	String
#define		PF_USER_PASSWORD					@"password"				//	String
#define		PF_USER_EMAIL						@"email"				//	String
#define		PF_USER_EMAILCOPY					@"emailCopy"			//	String
#define		PF_USER_FULLNAME					@"name"                 //	String
#define		PF_USER_FULLNAME_LOWER				@"fullname_lower"		//	String
#define		PF_USER_FACEBOOKID					@"facebookId"			//	String
#define		PF_USER_PICTURE						@"PortraitImage"		//	File
#define		PF_USER_THUMBNAIL					@"PortraitImage"			//	File

#define		PF_CHAT_CLASS_NAME					@"Chat"					//	Class name
#define		PF_CHAT_USER						@"user"					//	Pointer to User Class
#define		PF_CHAT_ROOMID						@"roomId"				//	String
#define		PF_CHAT_TEXT						@"text"					//	String
#define		PF_CHAT_PICTURE						@"picture"				//	File
#define		PF_CHAT_CREATEDAT					@"createdAt"			//	Date

#define		PF_CHATROOMS_CLASS_NAME				@"ChatRooms"			//	Class name
#define		PF_CHATROOMS_NAME					@"name"					//	String

#define		PF_MESSAGES_CLASS_NAME				@"Messages"				//	Class name
#define		PF_MESSAGES_USER					@"user"					//	Pointer to User Class
#define		PF_MESSAGES_ROOMID					@"roomId"				//	String
#define		PF_MESSAGES_DESCRIPTION				@"description"			//	String
#define		PF_MESSAGES_CHATTER                 @"chatter"				//	Pointer to User Class
#define		PF_MESSAGES_LASTMESSAGE				@"lastMessage"			//	String
#define		PF_MESSAGES_COUNTER					@"counter"				//	Number
#define		PF_MESSAGES_UPDATEDACTION			@"updatedAction"		//	Date

//-------------------------------------------------------------------------------------------------------------------------------------------------
#define		NOTIFICATION_APP_STARTED			@"NCAppStarted"
#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"

#define     FIRST_LAUNCH_KEY @"FIRST_LAUNCH_KEY"

#define     ITEM_CONDITION_NEW @"New"
#define     ITEM_CONDITION_RARELY_USED @"Rarely used"
#define     ITEM_CONDITION_USED @"USED"

@interface HLConstant : NSObject


extern NSString *const kHLOfferCategoryHomeGoods;
extern NSString *const kHLOfferCategoryFurniture;
extern NSString *const kHLOfferCategoryBabyKids;
extern NSString *const kHLOfferCategoryBooks;
extern NSString *const kHLOfferCategoryWomenClothes;
extern NSString *const kHLOfferCategoryMenClothes;

extern NSString *const kHLOfferCategoryClothes;
extern NSString *const kHLOfferCategoryBooks;
extern NSString *const kHLOfferCategoryElectronics ;
extern NSString *const kHLOfferCategorySportingGoods;
extern NSString *const kHLOfferCategoryCollectiblesArt;
extern NSString *const kHLOfferCategoryOther;

extern int const kHLOfferCellHeight;
extern int const kHLOfferCellWidth;
extern int const kHLOffersNumberShowAtFirstTime;
extern int const kHLNeedsNumberShowAtFirstTime;
extern int const kHLMaxSearchDistance;
extern int const kHLDefaultSearchDistance;

extern NSString *const kHLUserModelKeyEmail;
extern NSString *const kHLUserModelKeyUserName;
extern NSString *const kHLUserModelKeyPortraitImage;
extern NSString *const kHLUserModelKeyUserId;
extern NSString *const kHLUserModelKeyPassword;
extern NSString *const kHLUserModelKeyUserIdMD5;
extern NSString *const kHLOfferModelKeyImage;
extern NSString *const kHLOfferModelKeyThumbNail;


extern NSString *const kHLOfferModelKeyPrice;
extern NSString *const kHLOfferModelKeyLikes;
extern NSString *const kHLOfferModelKeyDescription;
extern NSString *const kHLOfferModelKeyCategory;
extern NSString *const kHLOfferModelKeyUser;
extern NSString *const kHLOfferModelKeyOfferId;
extern NSString *const kHLOfferModelKeyOfferName;
extern NSString *const kHLOfferModelKeyGeoPoint;
extern NSString *const kHLOfferModelKeyOfferStatus;

extern NSString *const kHLNeedsModelKeyPrice;
extern NSString *const kHLNeedsModelKeyLikes;
extern NSString *const kHLNeedsModelKeyDescription;
extern NSString *const kHLNeedsModelKeyCategory;
extern NSString *const kHLNeedsModelKeyUser;
extern NSString *const kHLNeedsModelKeyId;
extern NSString *const kHLNeedsModelKeyName;
extern NSString *const kHLNeedsModelKeyGeoPoint;
extern NSString *const kHLNeedsModelKeyStatus;

extern NSString *const kHLOfferPhotoKeyOfferID;
extern NSString *const kHLOfferPhotKeyPhoto;

extern NSString *const kHLCloudOfferClass;
extern NSString *const kHLCloudActivityClass;
extern NSString *const kHLCloudNeedClass;
extern NSString *const kHLCloudUserClass;

extern NSString *const kHLActivityKeyOffer;
extern NSString *const kHLActivityKeyUser;


extern NSString *const kHLFilterDictionarySearchType;
extern NSString *const kHLFilterDictionarySearchKeyCategory;
extern NSString *const kHLFilterDictionarySearchKeyWords;
extern NSString *const kHLFilterDictionarySearchKeyUser;
extern NSString *const kHLFilterDictionarySearchKeyUserLikes;

extern NSString *const kHLOfferAttributesLikeCountKey;
extern NSString *const kHLOfferAttributesLikersKey;
extern NSString *const kHLOfferAttributesIsLikedByCurrentUserKey;
extern NSString *const kHLOfferAttributesLikerdOffersKey;

@end
