//
//  BidHistoryViewController.h
//  Hooli
//
//  Created by Er Li on 2/24/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface BidHistoryViewController : PFQueryTableViewController
@property (nonatomic) NSString *offerId;
@end
