//
//  MyRelationshipViewController.m
//  Hooli
//
//  Created by Er Li on 2/9/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "MyRelationshipViewController.h"
#import "FollowListViewController.h"
@interface MyRelationshipViewController ()
@property (nonatomic) FollowListViewController *followListVC;

@end

@implementation MyRelationshipViewController
@synthesize followListVC = _followListVC;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUIElements];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)configureUIElements{
    
//    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    scroll.contentSize = CGSizeMake(320, 700);
//    scroll.backgroundColor = [UIColor whiteColor];
//    scroll.showsHorizontalScrollIndicator = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"我关注的", @"关注我的", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(35, 70, 250, 30);
    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:segmentedControl];
    
    _followListVC = [[FollowListViewController alloc]init];
    _followListVC.followStatus =  HL_RELATIONSHIP_TYPE_IS_FOLLOWED;
    _followListVC.fromUser = [PFUser currentUser];
    _followListVC.view.frame = CGRectMake(0, 108, 320, self.view.frame.size.height - segmentedControl.frame.origin.y - segmentedControl.frame.size.height);
    
    [self.view addSubview:_followListVC.view];
    
    
}

- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0){

        _followListVC.followStatus =  HL_RELATIONSHIP_TYPE_IS_FOLLOWED;
        
        [_followListVC loadObjects];
        
        [_followListVC.view setNeedsDisplay];

    }
    else if(segment.selectedSegmentIndex == 1)
    {
        
        _followListVC.followStatus =  HL_RELATIONSHIP_TYPE_IS_FOLLOWING;

        [_followListVC loadObjects];
        
        [_followListVC.view setNeedsDisplay];

    }

}

@end
