//
//  ItemDetailViewController.m
//  Hooli
//
//  Created by Er Li on 10/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "DataSource.h"
#import "HLTheme.h"
#import "OffersManager.h"
#import "AccountManager.h"
#import <Parse/Parse.h>
#import "LocationManager.h"
#import "HLConstant.h"
#import "MBProgressHUD.h"
#import "HLSettings.h"
#import "MapViewController.h"
#import "UserCartViewController.h"
#import "ActivityManager.h"
#import "NSString+MD5.h"
//#import "ChatViewController.h"
#import "messages.h"
#import "ChatView.h"
#import "UpdateOfferDetailsViewController.h"
#import "HomeTabBarController.h"
#import "UserAccountViewController.h"
#import "BidHistoryViewController.h"
#import "CreateItemViewController.h"

#define kScrollViewOffset 44
#define kBottomButtonOffset 44


#define deleteIndex 0
#define priceIndex 1
@interface ItemDetailViewController ()<MFMailComposeViewControllerDelegate>
{
    MBProgressHUD *HUD;
    BOOL toggleIsOn;
}
@property (nonatomic) CLLocationCoordinate2D offerLocation;
@property (nonatomic) BOOL toggleIsOn;
@property (nonatomic) NSString *chattingId;
@property (nonatomic) NSString *offerPrice;

@end

@implementation ItemDetailViewController
@synthesize offerId,offerObject,locationLabel,offerDescription,itemNameLabel,categoryLabel,likeButton,offerLocation,updateCollectionViewDelegate,userID,soldImageView,chattingId,isFirstPosted,commentVC,offerPrice,topDetailBar,showBidButton;

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHLItemDetailsReloadContentSizeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHLItemDetailsLiftCommentViewNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHLItemDetailsPutDownCommentViewNotification object:nil];
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liftCommentView:) name:kHLItemDetailsLiftCommentViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContentsize) name:kHLItemDetailsReloadContentSizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(putDownCommentView) name:kHLItemDetailsPutDownCommentViewNotification object:nil];
    
    [self configureUIElements];
    
    [self getOfferDetailsFromCloud];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self setNavBarVisible:YES animated:NO];
    //  self.navigationController.navigationBar.hidden = YES;
    
    // [self refreshOfferDetailsFromCloud];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    // self.navigationController.navigationBar.hidden = NO;
}

- (void)setNavBarVisible:(BOOL)visible animated:(BOOL)animated {
    
    // bail if the current state matches the desired state
    if ([self navBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat height = frame.size.height + 20;
    CGFloat offsetY = (visible)? height : -height;
    
    self.navigationController.navigationBar.frame = CGRectOffset(frame, 0, offsetY);
    
    
}

// know the current state
- (BOOL)navBarIsVisible {
    
    return self.navigationController.navigationBar.frame.origin.y >= 0;
    
}

-(void)deleteSelf{
    
    
    UIAlertView *deleteAlert = [[UIAlertView alloc]initWithTitle:@"Delete this offer?" message:@"Are you sure you want to delete this offer?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    deleteAlert.tag = deleteIndex;
    [deleteAlert show];
    
    
}

-(void)reportItem{
    
    MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    [mailVC setSubject:[NSString stringWithFormat:@"Report item %@",self.offerObject.offerName]];
    [mailVC setMessageBody:@"Hi there," isHTML:NO];
    [mailVC setToRecipients:[NSArray arrayWithObject:@"erli.0715@gmail.com"]];
    
    if (mailVC)
        
        [self presentViewController:mailVC animated:YES completion:^{
            
        }];
    
}


-(void)getOfferDetailsFromCloud{
    
    if(!self.offerObject){
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            
            [[OffersManager sharedInstance]fetchOfferByID:self.offerId
                                              withSuccess:^(id downloadObject) {
                                                  
                                                  self.offerObject = [[OfferModel alloc]initOfferDetailsWithPFObject:(PFObject *)downloadObject];
                                                  
                                                  [self updateOfferDetailInfo:self.offerObject];
                                                  
                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  
                                              } failure:^(id error) {
                                                  
                                                  NSLog(@"%@",[error description]);
                                                  
                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  
                                              }];
            
        });
        
    }else{
        
        
        
        [self updateOfferDetailInfo:self.offerObject];
        
    }
    
}

-(void)refreshOfferDetailsFromCloud{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(self.isFirstPosted){
        
        [self updateOfferDetailInfo:self.offerObject];
        
        //        [self.parentScrollView setContentSize:self.contentView.frame.size];
        
        self.navigationController.navigationItem.hidesBackButton = YES;
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]
                                          initWithTitle:@"Close"
                                          style:UIBarButtonItemStyleDone
                                          target:self
                                          action:@selector(closeDetailPage)];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        
        self.profilePicture.userInteractionEnabled = NO;
        
        self.categoryLabel.userInteractionEnabled = NO;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ;
        
    }
    else{
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            
            [[OffersManager sharedInstance]fetchOfferByID:self.offerId
                                              withSuccess:^(id downloadObject) {
                                                  
                                                  self.offerObject = [[OfferModel alloc]initOfferDetailsWithPFObject:(PFObject *)downloadObject];
                                                  
                                                  [self updateOfferDetailInfo:self.offerObject];
                                                  
                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  
                                                  
                                              } failure:^(id error) {
                                                  
                                                  NSLog(@"%@",[error description]);
                                                  
                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  
                                                  
                                              }];
            
        });
        
    }
}

- (IBAction)makeOffer:(id)sender {
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    //    PFUser *user1 = [PFUser currentUser];
    //
    //    NSString *user2_Id = self.offerObject.user.objectId;
    //
    //
    //    [[AccountManager sharedInstance]fetchUserWithUserId:user2_Id success:^(id object) {
    //
    //
    //        PFUser *user2 = (PFUser *)object;
    //        NSString *roomId = StartPrivateChat(user1, user2);
    //        ChatView *chatView = [[ChatView alloc] initWith:roomId];
    //        chatView.toUser = user2;
    //        chatView.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:chatView animated:YES];
    //
    //    } failure:^(id error) {
    //
    //    }];
    
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make Offer" message:@"Enter the price you will offer (in US dollar):" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField* tf = [alertView textFieldAtIndex:0];
    
    tf.text = [self.offerObject.offerPrice substringFromIndex:1];
    
    tf.keyboardType = UIKeyboardTypeNumberPad;
    
    alertView.tag = priceIndex;
    
    [alertView show];
    
}


-(void)updateOfferDetailInfo:(OfferModel *)offerModel{
    
    
    if(!self.isFirstPosted){
        
            UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                               initWithTitle:@"Report"
                                               style:UIBarButtonItemStyleDone
                                               target:self
                                               action:@selector(reportItem)];
            self.navigationItem.rightBarButtonItem = rightBarButton;
        
        
    }
    else{
        
        self.makeOfferButton.hidden = YES;
        self.showBidButton.hidden = YES;
        self.likeButton.hidden = YES;
        self.likeCountLabel.hidden = YES;
    }

    
    [[LocationManager sharedInstance]convertGeopointToAddressWithGeoPoint:offerModel.offerLocation block:^(NSString *address, NSError *error) {
        
        if(address){
            
            
            [self.seeMapButton setTitle:[NSString stringWithFormat:@"自取:%@",address] forState:UIControlStateNormal];
            
            [self.seeMapButton setEnabled:YES];

        }
        else{
            
            [self.seeMapButton setTitle:[NSString stringWithFormat:@"包送"] forState:UIControlStateNormal];
            
            [self.seeMapButton setEnabled:NO];
        }
        
    }];
    
        
    self.itemNameLabel.text =  [NSString stringWithFormat:@"(%@)%@",offerModel.offerCondition,offerModel.offerName];
    
    NSString *distanceText = [[LocationManager sharedInstance]getApproximateDistance:offerModel.offerLocation];
    self.locationLabel.text = [NSString stringWithFormat:@"Location: %@", distanceText];
    self.categoryLabel.text = [NSString stringWithFormat:@"In %@",offerModel.offerCategory];
    self.offerDescription.text = offerModel.offerDescription;
    [self.offerDescription sizeToFit];
    self.priceLabel.text = offerModel.offerPrice;
    
    if([offerModel.isOfferSold boolValue]){
        
        self.soldImageView.image = [UIImage imageNamed:@"sold"];
        
    }
    else{
        
        self.soldImageView.image = nil;
    }
    
    
    [[AccountManager sharedInstance]loadAccountDataWithUserId:offerModel.user.objectId Success:^(id object) {
        
        
        UserModel *userModel = [[UserModel alloc]initUserWithPFObject:object];
        
        self.profilePicture.image = userModel.portraitImage;
        
        
    } Failure:^(id error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.masksToBounds = YES;
    
    [self setOffersScrollViewWithImageArray:offerModel.imageArray];
    self.offerLocation = offerModel.offerLocation;
    
    self.userID = offerModel.user.objectId;
    
    UITapGestureRecognizer *tapPortrait = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(seeItemOwner)];
    
    [self.profilePicture addGestureRecognizer:tapPortrait];
    tapPortrait.numberOfTapsRequired = 1;
    self.profilePicture.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapCategory = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(seeCategory)];
    
    [self.categoryLabel addGestureRecognizer:tapCategory];
    tapCategory.numberOfTapsRequired = 1;
    self.categoryLabel.userInteractionEnabled = YES;
    
    if(offerModel.offerId){
        
        [[ActivityManager sharedInstance]isOfferLikedByCurrentUser:offerModel block:^(BOOL succeeded, NSError *error) {
            
            toggleIsOn = succeeded;
            
            if(toggleIsOn){
                
                self.likeCountLabel.text = @"Liked";
                self.likeButton.alpha = 1.0;
                
            }
            else{
                
                self.likeCountLabel.text = @"Like";
                self.likeButton.alpha = 0.5;

                
            }
            // [self updateLikeButtonImage:!succeeded];
            
        }];
        
    }
    
    if(self.offerObject && self.offerId){
        
        PFObject *object = [[PFObject alloc]initWithClassName:kHLCloudOfferClass];
        
        [object setObject:self.offerObject.user forKey:kHLOfferModelKeyUser];
        
        object.objectId  = self.offerId;
        
        [object setObject:kHLCommentTypeOffer forKey:kHLCommentTypeKey];
        
        self.commentVC = [[ItemCommentViewController alloc]initWithObject:object];
        
        [self.commentVC.view setFrame:CGRectMake(0, self.makeOfferButton.frame.origin.y + self.makeOfferButton.frame.size.height, 320, self.commentVC.tableView.contentSize.height)];
        
        [self.offerDetailView addSubview:self.commentVC.view];
        
        //   [self.parentScrollView setFrame:CGRectMake(0, 0, 320, self.parentScrollView.contentSize.height )];
        
        
    }
    
}

-(void)liftCommentView:(NSNotification*)note{
    
    [self reloadContentsize];
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.offerDetailView setContentOffset:CGPointMake(0.0f, self.offerDetailView.contentSize.height - kbSize.height - 200 ) animated:YES];
    
}

-(void)putDownCommentView{
    
    [self.offerDetailView setContentOffset:CGPointMake(0.0f, -64.0f) animated:YES];
    
}

-(void)dismissKeyboard{
    
    self.commentVC.repliedUser = nil;
    self.commentVC.commentTextField.placeholder = @"Leave your comment...";
    [self.commentVC.commentTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHLItemDetailsPutDownCommentViewNotification object:self];
    
}

-(void)reloadContentsize{
    
    //    [self.offerDetailView setFrame:CGRectMake(0, 0, 320, self.offerDetailView.frame.size.height + self.commentVC.tableView.contentSize.height)];
    
    [self.offerDetailView setContentSize:CGSizeMake(320, self.offerDetailView.frame.size.height  + self.commentVC.tableView.contentSize.height + 100)];
    
    [self.commentVC.view setFrame:CGRectMake(0, self.makeOfferButton.frame.origin.y + self.makeOfferButton.frame.size.height, 320, self.commentVC.tableView.contentSize.height)];
    
    
}


-(void)configureUIElements{
    
    self.tabBarController.tabBar.hidden = YES;
    // self.navigationController.navigationBar.hidden = YES;
    self.title = @"Item Detail";
    

    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.topDetailBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [self.topDetailBar.layer insertSublayer:gradient atIndex:0];
    
    // [self.makeOfferButton setFrame:CGRectMake(55, 450, 216, 37)];
    // [self.makeOfferButton bringSubviewToFront:self.parentScrollView];
    self.offerDetailView.bounces = YES;
    [self.offerDetailView setBackgroundColor:[UIColor whiteColor]];
    
    UIImage* buttonImage = [UIImage imageNamed:@"heart-64"];
    UIImage* buttonPressedImage = [UIImage imageNamed:@"heart-64"];
    
    
    [self.addToCartButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [self.addToCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addToCartButton setTitleColor:[HLTheme mainColor] forState:UIControlStateHighlighted];
    
    [self.likeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    [self.likeButton bringSubviewToFront:self.offerDetailView];
    [self.makeOfferButton bringSubviewToFront:self.offerDetailView];
    self.makeOfferButton.layer.cornerRadius = 10.0f;
    self.makeOfferButton.layer.masksToBounds = YES;
    self.showBidButton.layer.cornerRadius = 10.0f;
    self.showBidButton.layer.masksToBounds = YES;
 
    //self.likeButton.titleLabel.font = [UIFont fontWithName:[HLTheme boldFont] size:18.0f];
    //    [self.likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.likeButton setTitleColor:[HLTheme mainColor] forState:UIControlStateHighlighted];
    
    self.itemNameLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:15.0f];
    self.offerDescription.font = [UIFont fontWithName:[HLTheme mainFont] size:15.0f];
    self.locationLabel.font =[UIFont fontWithName:[HLTheme boldFont] size:15.0f];
    self.categoryLabel.font =[UIFont fontWithName:[HLTheme mainFont] size:15.0f];
    
    
    if(self.isFirstPosted){
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Cancel"
                                         style:UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(goToHomePage)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        [self.showBidButton setTitle:@"No bid yet" forState:UIControlStateNormal];

        self.showBidButton.enabled = NO;
        
        self.makeOfferButton.enabled = NO;
        
        self.likeButton.enabled = NO;
        

    }
    else{
        
        [self updateBidButton];
        
        
    }
    
}

-(void)goToHomePage{
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

-(void)seeItemOwner{
    
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userAccount"];
    vc.userID = self.userID;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)seeCategory{
    
    NSDictionary *filterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      kHLFilterDictionarySearchKeyCategory, kHLFilterDictionarySearchType,
                                      self.offerObject.offerCategory,kHLFilterDictionarySearchKeyCategory,nil];
    
    [[OffersManager sharedInstance]setFilterDictionary:filterDictionary];
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserCartViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"searchResult"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = ceil(scrollView.contentOffset.x / self.scrollView.bounds.size.width);
    
}


-(void)setOffersScrollViewWithImageArray:(NSArray *)imagesArray{
    
    [self.pageControl setPageIndicatorImage:[UIImage imageNamed:@"pageControl-dot"]];
    [self.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"pageControl-dot-selected"]];
    self.pageControl.numberOfPages = imagesArray.count;
    
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    self.scrollView.delegate = self;
    
    CGFloat scrollContentWidth = 0;
    
    CGFloat scrollHeight = self.scrollView.bounds.size.height; // -20;
    CGFloat padding = (self.scrollView.bounds.size.width - scrollHeight) / 2;
    
    for (UIImage *image in imagesArray) {
        
        CGRect frame = CGRectMake(scrollContentWidth + 0  , (self.scrollView.bounds.size.height - scrollHeight)/2, 320, 320);
        
        UIImageView *preview = [[UIImageView alloc] initWithFrame:frame];
        
        preview.image = image;
        
        scrollContentWidth += self.scrollView.bounds.size.width;
        
        [self.scrollView addSubview:preview];
    }
    
    self.scrollView.contentSize = CGSizeMake(scrollContentWidth, scrollHeight);
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    [self scrollViewDidEndDecelerating:self.scrollView];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == deleteIndex){
        
        if(buttonIndex== 1){
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[OffersManager sharedInstance]deleteOfferModelWithOfferId:self.offerId block:^(BOOL succeeded, NSError *error) {
                
                if(succeeded){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    
                    NSLog(@"Delete self error %@", [error description]);
                    
                }
                
            }];
            
        }
        
    }
    else if(alertView.tag == priceIndex){
        
        if(buttonIndex== 1){
            
            NSString *price = [NSString stringWithFormat:@"$%@",[alertView textFieldAtIndex:0].text];
            
//            if(![[ActivityManager sharedInstance]checkBalanceStatus:price]){
//                
//                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Your balance is not enough." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                
//                [alertView show];
//                
//                
//            }
//            else{
            
                [[ActivityManager sharedInstance]makeOfferToOffer:self.offerObject withPrice:price block:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                        
                       // [self.navigationController popToRootViewControllerAnimated:YES];
                        
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Congratulations" message:@"Succesfully made offer!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alertView show];
                        
                        [self updateBidButton];
                        
                    }
                    else{
                        
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry..." message:@"Some problems occurs. Fail to make offer." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alertView show];
                    }
                    
                    
                }];
            }
  //      }
    }
    
}





- (IBAction)likeButtonPressed:(id)sender {
    
    PFUser *user1 = [PFUser currentUser];
    
    NSString *user2_Id = self.offerObject.user.objectId;
    
    
    //    [[AccountManager sharedInstance]fetchUserWithUserId:user2_Id success:^(id object) {
    //
    //
    //        PFUser *user2 = (PFUser *)object;
    //
    //        [[ActivityManager sharedInstance]unFollowUserInBackground:user2 block:^(BOOL succeeded, NSError *error) {
    //
    //            //            [[ActivityManager sharedInstance]getFollowersByUser:[PFUser currentUser] WithSuccess:^(id downloadObjects) {
    //            //
    //            //            } Failure:^(id error) {
    //            //
    //            //            }];
    //            //
    //            //
    //            //            [[ActivityManager sharedInstance]getFollowedUsersByUser:[PFUser currentUser] WithSuccess:^(id downloadObjects) {
    //            //
    //            //            } Failure:^(id error) {
    //            //
    //            //            }];
    //
    //        }];
    //
    //
    //    } failure:^(id error) {
    //
    //    }];
    
    
    [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
    
    if(!toggleIsOn){
        
        [[ActivityManager sharedInstance]likeOfferInBackground:self.offerObject block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                NSLog(@"Like Success!");
                
            }
            else{
                
                NSLog(@"%@",[error description]);
            }
        }];
    }
    else {
        
        [[ActivityManager sharedInstance]dislikeOfferInBackground:self.offerObject block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                NSLog(@"dislike Success!");
                
            }
            else{
                
                NSLog(@"%@",[error description]);
            }
        }];
    }
    
    toggleIsOn = !toggleIsOn;
    
    [self updateLikeButtonImage:!toggleIsOn];
    
    [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
    
    
}

-(void)updateLikeButtonImage:(BOOL)flag{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.likeCountLabel.alpha = 0;
        self.likeButton.alpha = 0;
        
    } completion: ^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.likeCountLabel.alpha = 1.0;
            
            if(!flag){
                
                self.likeCountLabel.text = @"Liked";
                self.likeButton.alpha = 1.0;

            }
            else{
                
                self.likeCountLabel.text = @"Like";
                self.likeButton.alpha = 0.5;

                
            }
            
        } completion: ^(BOOL finished) {
            
            
            
        }];
        
    }];
    
    
    
    //[self.likeButton setImage:nil forState:UIControlStateNormal];
    
    //[self.likeButton setImage:[UIImage imageNamed:flag ? @"unlike-48.png" :@"like-48.png"] forState:UIControlStateNormal];
    
    
}

- (IBAction)contactSeller:(id)sender {
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFUser *user1 = [PFUser currentUser];
    
    NSString *user2_Id = self.offerObject.user.objectId;
    
    
    [[AccountManager sharedInstance]fetchUserWithUserId:user2_Id success:^(id object) {
        
        
        PFUser *user2 = (PFUser *)object;
        
        //       [[ActivityManager sharedInstance]followUserInBackground:user2 block:^(BOOL succeeded, NSError *error) {
        
        
        
        
        
        [[ActivityManager sharedInstance]followUserInBackground:user2 block:^(BOOL succeeded, NSError *error) {
            
            [[ActivityManager sharedInstance]getUserRelationshipWithUserOne:[PFUser currentUser] UserTwo:user2 WithBlock:^(RelationshipType relationType, NSError *error) {
                
                NSLog(@"Relation type %d",relationType);
                
            }];
            
            
        }];
        //
        //
        //            [[ActivityManager sharedInstance]getFollowedUsersByUser:[PFUser currentUser] WithSuccess:^(id downloadObjects) {
        //
        //            } Failure:^(id error) {
        //
        //            }];
        //
        //            [[ActivityManager sharedInstance]getFriendsByUser:[PFUser currentUser] WithSuccess:^(id downloadObjects) {
        //
        //                NSLog(@"Get friends count %d %@", [downloadObjects count], downloadObjects);
        //
        //
        //            } Failure:^(id error) {
        //
        //            }];
        //
        //
        //
        //
        //        }];
        
        
        
        
        
        //        NSString *roomId = StartPrivateChat(user1, object);
        //        ChatView *chatView = [[ChatView alloc] initWith:roomId];
        //        chatView.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:chatView animated:YES];
        
    } failure:^(id error) {
        
    }];
    
    
    
    //    __weak ItemDetailViewController *weakSelf = self;
    //
    //    [[AccountManager sharedInstance]loadAccountDataWithUserId:self.offerObject.user.objectId Success:^(id object) {
    //
    //        PFUser *currentUser = [PFUser currentUser];
    //        UserModel *userModel = (UserModel *)object;
    //
    //
    //        EMConversation *conversation = [[EMConversation alloc]init];
    //        conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:userModel.chattingId isGroup:NO];
    //        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:conversation.chatter isGroup:conversation.isGroup];
    //        chatVC.receiver = [[ChatterObject alloc]initWithChatterID:conversation.chatter username:userModel.username portrait: userModel.portraitImage isSender:NO];
    //
    //        PFFile *profileImage = [currentUser objectForKey:kHLUserModelKeyPortraitImage];
    //
    //        [profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
    //            if (!error) {
    //
    //                UIImage *image = [UIImage imageWithData:data];
    //
    //                chatVC.sender = [[ChatterObject alloc]initWithChatterID:[currentUser objectForKey:kHLUserModelKeyUserIdMD5] username:[currentUser objectForKey:kHLUserModelKeyUserName] portrait:image isSender:YES];
    //
    //                chatVC.hidesBottomBarWhenPushed = YES;
    //                [weakSelf.navigationController pushViewController:chatVC animated:YES];
    //
    //                // image can now be set on a UIImageView
    //            }
    //        }];
    //
    //    } Failure:^(id error) {
    //
    //        NSLog(@"%@",error);
    //
    //    }];
    
}

- (IBAction)seeMapButtonClicked:(id)sender {
    
    
    [self performSegueWithIdentifier:@"map" sender:self];
    
    
}


- (IBAction)showBidHistory:(id)sender {
    
    [self performSegueWithIdentifier:@"showBidHisotory" sender:self];
    
}

-(void)closeDetailPage{
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
    vc.selectedIndex = 0;
    [self presentViewController:vc animated:NO completion:^{
        
    }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"map"])
    {
        MapViewController *map = segue.destinationViewController;
        map.title = @"自取地点";
        map.offerLocation = self.offerLocation;
    }
    else if([segue.identifier isEqualToString:@"editOffer"]){
        
        UpdateOfferDetailsViewController *destVC = segue.destinationViewController;
        destVC.offerId = self.offerObject.offerId;
        destVC.oldName = self.offerObject.offerName;
        destVC.oldPrice = self.offerObject.offerPrice;
        destVC.oldDescription = self.offerObject.offerDescription;
        
    }
    else if([segue.identifier isEqualToString:@"showBidHisotory"]){
        
        BidHistoryViewController *destVC = segue.destinationViewController;
        destVC.offerId = self.offerObject.offerId;
    }
    
}

-(void)updateBidButton{
    
    [[OffersManager sharedInstance]getLastestBillWithOfferId:self.offerId block:^(PFObject *object, NSError *error) {
        
        if(object){
            
            
            [self.showBidButton setTitle:[NSString stringWithFormat:@"Latest Bid: %@", [object objectForKey:kHLNotificationContentKey]] forState:UIControlStateNormal];
        }
        else{
            
            [self.showBidButton setTitle:@"No bid yet" forState:UIControlStateNormal];
            
        }
        
    }];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
