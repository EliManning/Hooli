
//
//  MyCameraViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MyCameraViewController.h"
#import "CameraOverlayViewController.h"
#import "HLTheme.h"
#import "HLSettings.h"
#import "OffersManager.h"
#import "HLConstant.h"
#import "MBProgressHUD.h"
#import "ImageManager.h"
#import "LocationManager.h"
#import "ImageCache.h"
#import "ItemDetailViewController.h"
#import "NeedsManager.h"
#import "PostFormViewController.h"


#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.24299 // this works for iOS 4.x


@interface MyCameraViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *takePhotosButton;
@property (nonatomic, strong) UIButton *selectPhotoButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) CameraOverlayViewController *overlayVC;
@property (nonatomic, strong) UIBarButtonItem *retakePhotosButton;
@property (nonatomic, strong) UIBarButtonItem *confirmButton;
@property (nonatomic,assign) BOOL cancelFlag;

@end

@implementation MyCameraViewController
//@synthesize priceInputBox,itemDetailTextView,itemNameTextField,postItemView;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //    [[HLSettings sharedInstance]setIsPostingOffer:NO];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCameraView)
                                                 name:@"Hooli.showCameraView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(takePhotoClicked)
                                                 name:@"Hooli.takephoto" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectPhotoFromAlbum)
                                                 name:@"Hooli.selectPhoto" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelCameraView)
                                                 name:@"Hooli.cancelCameraView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotToPostFrom)
                                                 name:@"Hooli.goToPostForm" object:nil];
    
    
    // [self configureUIElements];
    
    //    self.priceInputBox.delegate = self;
    //
    //    self.itemDetailTextView.delegate = self;
    //
    //    self.itemNameTextField.delegate = self;
    //
    //    self.categoryTextView.delegate = self;
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[ImageCache sharedInstance]setPhotoCount:0];
    
    if(self.picker)
        
        [self showCameraView];
    
    //    [self updateCurrentView];
    
    //   [self dismissKeyboards];
    
}

-(void)viewDidAppear:(BOOL)animated{
    

    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[HLSettings sharedInstance]setCategory:nil];
    
}
//-(void)submitOfferToCloud{
//
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//   [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];//
//    NSArray *imagesArray = [[ImageCache sharedInstance]getimagesArray];
//
//    OfferModel *offer = [[OfferModel alloc]initOfferModelWithUser:[PFUser currentUser] imageArray:imagesArray  price:self.priceInputBox.text offerName:self.itemNameTextField.text category:self.categoryTextView.text description:self.itemDetailTextView.text location:[[LocationManager sharedInstance]currentLocation] isOfferSold:[NSNumber numberWithBool:NO]];
//
//
//
//    //   [[OffersManager sharedInstance]uploadUserPhotosToCloudWithImages:imagesArray withSuccess:^{
//
//    [[OffersManager sharedInstance]updaloadOfferToCloud:offer withSuccess:^{
//
//         [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
//    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];

//        [[HLSettings sharedInstance]setIsPostingOffer:YES];
//        [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
//
//        //   [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.reloadHomeData" object:self];
//        //  [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.reloadMyCartData" object:self];
//        UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"Congratulations!"
//                                                              message:@"You have successfully post your item!"
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"OK"
//                                                    otherButtonTitles:nil];
//        [confirmAlert show];
//
//        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
//        ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
//        vc.offerObject = offer;
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [self.navigationController pushViewController:vc animated:NO];
//        [self updateCurrentView];
//
//    } withFailure:^(id error) {
//
//         [MBProgressHUD hideHUDForView:self.view.superview animated:YES];

//
//    }];
//
//    //    } withFailure:^(id error) {
//    //
//    //         [MBProgressHUD hideHUDForView:self.view.superview animated:YES];

//    //
//    //
//    //    }];
//
//
//
//
//}
//
//-(void)confirmOffer{
//
//    if([self.itemNameTextField.text isEqualToString: @""] || [self.itemDetailTextView.text isEqualToString:@"" ] || [self.priceInputBox.text isEqualToString:@""]){
//
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Offer information is missing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//
//        [alertView show];
//    }
//    else{
//
//
//        UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"Are you sure?"
//                                                              message:@"Do you confirm to make this offer?"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"Cancel"
//                                                    otherButtonTitles:@"Confirm" , nil];
//        [confirmAlert show];
//
//    }
//
//}
//
//
//-(void)updateCurrentView{
//
//    if(![[HLSettings sharedInstance]isPostingOffer]){
//
//        self.title = @"Make Offer";
//
//        self.makeOfferView.hidden = NO;
//        self.postItemView.hidden = YES;
//
//        self.retakePhotosButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Retake"
//                                   style:UIBarButtonItemStylePlain
//                                   target:self
//                                   action:@selector(showCameraView:)];
//        self.navigationItem.leftBarButtonItem =  self.retakePhotosButton;
//
//        self.confirmButton = [[UIBarButtonItem alloc]
//                              initWithTitle:@"Confirm"
//                              style:UIBarButtonItemStylePlain
//                              target:self
//                              action:@selector(confirmOffer)];
//        self.navigationItem.rightBarButtonItem = self.confirmButton;
//
//        if([[HLSettings sharedInstance]category]){
//
//            self.categoryTextView.text = [[HLSettings sharedInstance]category][0];
//
//        }
//
//
//        [self.itemNameTextField becomeFirstResponder];
//        self.itemDetailTextView.text = @"Add detail here...";
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                              action:@selector(dismissKeyboards)];
//
//        [self.view addGestureRecognizer:tap];
//
//        UITapGestureRecognizer *tapCategory = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                              action:@selector(selectCategory)];
//
//        [self.categoryTextView addGestureRecognizer:tapCategory];
//
//        self.tabBarController.tabBar.hidden=YES;
//    }
//
//    else{
//
//        self.makeOfferView.hidden = YES;
//        self.postItemView.hidden = NO;
//
//        self.navigationItem.leftBarButtonItem = nil;
//
//        self.navigationItem.rightBarButtonItem = nil;
//
//        self.title = @"Hooli";
//        self.priceInputBox.text = @"";
//        self.itemNameTextField.text = @"";
//        self.itemDetailTextView.text = @"Add detail here...";
//        self.categoryTextView.text = @"";
//
//        [self dismissKeyboards];
//
//        self.tabBarController.tabBar.hidden = NO;
//
//    }
//
//
//}
//
//-(void)selectCategory{
//
//    [self performSegueWithIdentifier:@"selectCategory" sender:self];
//
//}
//-(void)configureUIElements{
//
//    self.view.tintColor = [HLTheme mainColor];
//
//    [self.navigationController setNavigationBarHidden:NO];
//    //
//    UIImage* buttonImage = [[UIImage imageNamed:@"button-pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    UIImage* buttonPressedImage = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [self.showCameraButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [self.showCameraButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
//    self.showCameraButton.titleLabel.font = [UIFont fontWithName:[HLTheme boldFont] size:18.0f];
//    [self.showCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.showCameraButton setTitleColor:[HLTheme mainColor] forState:UIControlStateHighlighted];
//
//}
//
//#pragma  mark -UIAlertview delegate
//
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if(buttonIndex == 0){
//
//
//    }
//    else if(buttonIndex == 1){
//
//        [self dismissKeyboards];
//        [self submitOfferToCloud];
//
//    }
//}
//
//#pragma mark textview delegate
//
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//
//    if (textField == self.priceInputBox) {
//
//        self.priceInputBox.text = @"$";
//    }
//}
//
//-(void)textViewDidBeginEditing:(UITextView *)textView{
//
//    CGFloat fixedWidth = textView.frame.size.width;
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    textView.frame = newFrame;
//    textView.scrollEnabled = NO;
//
//}
//
//-(void)dismissKeyboards{
//
//    [self.itemDetailTextView resignFirstResponder];
//
//    [self.itemNameTextField resignFirstResponder];
//
//    [self.priceInputBox resignFirstResponder];
//
//    [self.categoryTextView resignFirstResponder];
//}



-(void)initCameraPickerWithCompletionBlock:(void (^)(BOOL succeeded))completionBlock{
    
    if(!self.overlayVC){
        
        self.overlayVC = [[CameraOverlayViewController alloc]initWithNibName:@"CameraOverlayViewController" bundle:nil];
        
    }
    
    [[ImageCache sharedInstance]clearCache];
    // Create a new image picker instance:
    
    if(!self.picker){
        
        self.picker = [[UIImagePickerController alloc] init];
        
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // Hide the controls:
        self.picker.showsCameraControls = NO;
        self.picker.navigationBarHidden = YES;
        
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        // Insert the overlay:
        self.picker.cameraOverlayView = self.overlayVC.view;
    }
    // Set the image picker source:
    
    
    completionBlock(YES);
    
    
    
}

-(void)showCameraView{
    
    if(self.picker){
        
        if ([self.presentedViewController class] != [UIImagePickerController class]) {
            
            [self presentViewController:self.picker animated:YES completion:NULL];
            
        }
        
    }
    
}



-(void)cancelCameraView{
    
    if ([self.presentedViewController class] == [UIImagePickerController class]) {
        
      //  [self dismissViewControllerAnimated:NO completion:^{
            
            UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
            vc.selectedIndex = [[HLSettings sharedInstance]currentPageIndex];
            
            [self.picker presentViewController:vc animated:NO completion:^{
                
                self.picker = nil;
                
            }];
            
     //   }];
        
    }
}


- (void)takePhotoClicked {
    
    if([[ImageCache sharedInstance]photoCount] < 4){
        
        [self.picker takePicture];
        
    }
    
}

-(void)selectPhotoFromAlbum{
    
    if([[ImageCache sharedInstance]photoCount] < 4){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    //    CGImageRef imageRef = CGImageCreateWithImageInRect([chosenImage CGImage], CGRectMake(0, 0, 640, 640));
    //    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    //    CGImageRelease(imageRef);
    
   // CGSize newSize = CGSizeMake(320.0f, 320.0f);
    
    CGSize imageSize = chosenImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat newDimension = MIN(width, height);
    CGFloat widthOffset = (width - newDimension) / 2;
    CGFloat heightOffset = (height - newDimension) / 2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.5f);
    [chosenImage drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                   blendMode:kCGBlendModeCopy
                       alpha:1.];
    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UIGraphicsBeginImageContext(newSize);
//    [chosenImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    self.imageData = UIImageJPEGRepresentation(chosenImage, 0.1f);
    NSLog(@"small image size %u kb", [self.imageData length]/1024);
    UIImage* smallImage = [UIImage imageWithData:self.imageData];
    UIGraphicsEndImageContext();

    int photoIndex = [[ImageCache sharedInstance]photoCount];
    photoIndex = photoIndex + 1;
    [[ImageCache sharedInstance]setPhotoCount:photoIndex ++];
    
    [self.overlayVC setImage:smallImage withImageIndex:[[ImageCache sharedInstance]photoCount]];
    
    [[ImageCache sharedInstance] setImage:smallImage withImageIndex:[[ImageCache sharedInstance]photoCount]];
    
    //  [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)gotToPostFrom{
    
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    PostFormViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"PostFormViewController"];
    vc.navigationItem.hidesBackButton = NO;
    vc.navigationController.navigationBarHidden = NO;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    [self.picker dismissViewControllerAnimated:NO completion:^{
        
        
    }];
    
    
}


-(void)dealloc{
    
    if(self.picker)
        self.picker = nil;
    
}

@end
