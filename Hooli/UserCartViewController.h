//
//  UserCartViewController.h
//  Hooli
//
//  Created by Er Li on 11/12/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionViewFlowLayout.h"
#import "MainCollectionView.h"
#import "OfferModel.h"
@interface UserCartViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet MainCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MainCollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *user;

@end
