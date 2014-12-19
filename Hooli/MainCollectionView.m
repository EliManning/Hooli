//
//  MainCollectionView.m
//  Hooli
//
//  Created by Er Li on 10/28/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MainCollectionView.h"
#import "ItemCell.h"
#import "DataSource.h"
#import "HLTheme.h"
#import "OffersManager.h"
#import <Parse/Parse.h>
#import "HLConstant.h"
#import "LocationManager.h"
#import "ItemDetailViewController.h"
static NSString * const reuseIdentifier = @"Cell";

@implementation MainCollectionView{
    
    MBProgressHUD *HUD;
}

@synthesize refreshControl, objectDataSource;
-(id)init{
    
    if(!self){
        self = [super init];
 
    }
    
    return self;
}


-(void)configureView{
    
    self.backgroundColor = [HLTheme viewBackgroundColor];
    self.dataSource = self;
  //  self.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle: nil];
    [self registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    //  self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadCollectionViews)
                  forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.refreshControl];
    
    self.scrollEnabled = YES;
    self.alwaysBounceVertical = YES;
}

-(void)updateDataFromCloud{
    
    HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
    [[OffersManager sharedInstance]retrieveOffersWithSuccess:^(NSArray *objects) {
        
        self.objectDataSource = [[NSMutableArray alloc]initWithArray:objects];
        
        if(self.objectDataSource){
            
            [self reloadData];
        }

        [HUD hide:YES];
        

    } failure:^(id error) {
        
        NSLog(@"Retrived Images Error %@",[error description] );
        [HUD hide:YES];
        
    }];
}

-(void)reloadCollectionViews{
    
    if (self.refreshControl) {
        
        [HUD hide:YES];

        
        [[OffersManager sharedInstance]retrieveOffersWithSuccess:^(NSArray *objects) {
            
            self.objectDataSource = [[NSMutableArray alloc]initWithArray:objects];
            
            if(self.objectDataSource){
                
                    [self reloadData];
            }
            
            [self.refreshControl endRefreshing];
            
            
        } failure:^(id error) {
            
            NSLog(@"Retrived Images Error %@",[error description] );
            
            [self.refreshControl endRefreshing];

        }];
    }

}

-(void)reloadDataByOffersArray:(NSArray *)offers{
    
    self.objectDataSource = [[NSMutableArray alloc]initWithArray:offers];
    
    if(self.objectDataSource){
        
        [self reloadData];
    }


}

#pragma mark collectionview delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.objectDataSource count];
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    OfferModel *offer = [self.objectDataSource objectAtIndex:indexPath.row];
    
    [cell updateCellWithOfferModel:offer];

    
    return cell;
}


#pragma mark MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    [HUD removeFromSuperview];
    HUD = nil;

}


@end
