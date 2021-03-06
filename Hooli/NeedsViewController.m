//
//  NeedsViewController.m
//  Hooli
//
//  Created by Er Li on 12/24/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "NeedsViewController.h"
#import "NeedsManager.h"
#import "NeedsModel.h"
#import "HLSettings.h"
#import "NeedsCell.h"
#import "HLTheme.h"
#import "LoginViewController.h"
#import "NeedDetailViewController.h"
#import "HLUtilities.h"
@interface NeedsViewController ()

@end

@implementation NeedsViewController
@synthesize layout;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NeedsManager sharedInstance]setPageCounter:0];
    [[HLSettings sharedInstance]setPreferredDistance:25];
    
    self.view.tintColor = [HLTheme mainColor];
    [self.layout configureLayout] ;
    [self.collectionView configureView];
    self.collectionView.delegate = self;
    self.navigationItem.title = @"Needs";
    [self updateCollectionViewData];
    

    // Do any additional setup after loading the view.
}

-(void)updateCollectionViewData{
        
    [self.collectionView updateDataFromCloud];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([HLUtilities checkIfUserLoginWithCurrentVC:self]){

    NeedsCell *cell = (NeedsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    NeedDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"NeedDetail"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.needId = cell.needId;
    // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
        
    }
}

//- (BOOL)checkIfUserLogin{
//    
//    
//    if(![PFUser currentUser]){
//        
//        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        UIViewController *loginVC = [loginSb instantiateViewControllerWithIdentifier:@"LoginWelcomeViewController"];
//        self.navigationController.navigationBarHidden = NO;
//        [self.navigationController pushViewController:loginVC animated:YES];
//        return NO;
//        
//    }
//    
//    return YES;
//}


@end
