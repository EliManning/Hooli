//
//  MyCartViewController.h
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionViewFlowLayout.h"
#import "MainCollectionView.h"
@interface MyCartViewController : UIViewController
@property (weak, nonatomic) IBOutlet MainCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MainCollectionViewFlowLayout *layout;

@end