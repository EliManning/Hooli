//
//  EditProfileDetailViewController.h
//  Hooli
//
//  Created by Er Li on 2/15/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormManager.h"
#import "MyProfileDetailViewController.h"

@protocol UpdateProfileDelegate;

//@[@"用户名",@"性别", @"年龄",@"职业",@"兴趣爱好", @"个性签名",];

typedef enum {
    
    PROFILE_INDEX_IMAGE = -1,
    PROFILE_INDEX_USERNAME ,
    PROFILE_INDEX_GENDER,
    PROFILE_INDEX_AGE,
    PROFILE_INDEX_WORK,
    PROFILE_INDEX_HOBBY,
    PROFILE_INDEX_SIGNATURE,
//    PROFILE_INDEX_EMAIL,
//    PROFILE_INDEX_PHONE,
//    PROFILE_INDEX_WECHAT,
    
} ProfileTypeIndex;

@interface EditProfileDetailViewController : UIViewController

@property (nonatomic) ProfileTypeIndex profileTypeIndex;

@property (nonatomic) NSString *content;

@property (nonatomic, weak) id<UpdateProfileDelegate> delegate;

@end

@protocol UpdateProfileDelegate <NSObject>

-(void)updateProfileDetailWithDetailType:(ProfileTypeIndex)typeIndex WithContent:(NSString *)contentStr;

@end