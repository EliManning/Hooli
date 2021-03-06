//
//  FormManager.h
//  Hooli
//
//  Created by Er Li on 1/12/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostFormViewController.h"
#import "CreateActivityViewController.h"
#import <Parse/Parse.h>
@interface FormManager : NSObject
+(FormManager *)sharedInstance;

@property (nonatomic, assign) DetailType detailType;
@property (nonatomic, assign) EventDetailType eventDetailType;

@property (nonatomic) NSString *itemName;
@property (nonatomic) NSString *itemDescription;
@property (nonatomic) NSString *itemPrice;
@property (nonatomic) NSString *itemCategory;
@property (nonatomic) NSString *itemCondition;
@property (nonatomic) NSString *itemLocation;

@property (nonatomic) PFUser *toUser;

@property (nonatomic) NSString *needItemDescription;
@property (nonatomic) NSString *needItemBudget;


@property (nonatomic) NSString *profileUsername;
@property (nonatomic) NSString *profileEmail;
@property (nonatomic) NSString *profileGender;
@property (nonatomic) NSString *profilePhone;
@property (nonatomic) NSString *profileWechat;
@property (nonatomic) NSString *profileSignature;
@property (nonatomic) NSString *profileHobbies;
@property (nonatomic) NSString *profileWorkingStatus;



@property (nonatomic) NSString *eventTitle;
@property (nonatomic) NSString *eventDescription;
@property (nonatomic) NSString *eventLocation;
@property (nonatomic) NSString *eventDate;


@property (nonatomic) NSMutableArray *profileDetailArray;
@end
