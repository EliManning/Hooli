//
//  AppDelegate.h
//  Hooli
//
//  Created by Er Li on 10/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EaseMob.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
//@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>
@property (nonatomic, readonly) int networkStatus;

@property (strong, nonatomic) UIWindow *window;

- (void)logOut;
- (BOOL)isParseReachable;

@end
