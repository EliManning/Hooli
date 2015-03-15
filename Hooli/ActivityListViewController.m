//
//  ActivityListViewController.m
//  Hooli
//
//  Created by Er Li on 3/2/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityListCell.h"
#import "ActivityDetailViewController.h"
#import "CreateActivityViewController.h"
#import "EventManager.h"
#import "HLConstant.h"
#import "LocationManager.h"

@interface ActivityListViewController ()
@end

@implementation ActivityListViewController

@synthesize aObject;


- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    
    if (self) {
        // The className to query on
        self.parseClassName = kHLCloudEventClass;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;
    }
    return self;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query includeKey:kHLEventKeyHost];
    [query includeKey:kHLEventKeyImages];
    [query orderByAscending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    
    [super objectsDidLoad:error];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"发布"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(postEvent)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"类别"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(seeCategories)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Activities";
    // Do any additional setup after loading the view.
}


-(void)postEvent{
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    
    
    CreateActivityViewController *postVC = [mainSb instantiateViewControllerWithIdentifier:@"CreateActivityViewController"];
    
    postVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:postVC animated:YES];
    
}

-(void)seeCategories{
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //return 125.0f;
    return 220.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *kCellIdentifier = @"ActivityListCell";
    
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell updateCellDetail:object];
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc]init];
    detailVC.activityDetail = [self.objects objectAtIndex:indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
   //[self performSegueWithIdentifier:@"seeActivityDetail" sender:self];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"seeActivityDetail"])
    {
        ActivityDetailViewController *detailVC = segue.destinationViewController;
        detailVC.hidesBottomBarWhenPushed = YES;
    }
    
    
}


#pragma mark scrollview delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    CGPoint scrollVelocity = [self.tableView.panGestureRecognizer
                              velocityInView:self.tableView.superview];
    
    if (scrollVelocity.y > 0.0f){
        
        [self setTabBarVisible:YES animated:YES];
        [self setNavBarVisible:YES animated:YES];
        
        
    }
    else if(scrollVelocity.y < 0.0f){
        
        [self setTabBarVisible:NO animated:YES];
        [self setNavBarVisible:NO animated:YES];
        
    }
    
}

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated {
    
    // bail if the current state matches the desired state
    if ([self tabBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    }];
}

// know the current state
- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}



- (void)setNavBarVisible:(BOOL)visible animated:(BOOL)animated {
    
    // bail if the current state matches the desired state
    if ([self navBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat height = frame.size.height + 20;
    CGFloat offsetY = (visible)? height : -height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        

        CGRect tableViewframe = self.tableView.frame;
        
        tableViewframe.origin.y = (visible)? 0 : 0;
        tableViewframe.size.height = (visible)? 568: [[UIScreen mainScreen]bounds].size.height - tableViewframe.origin.y;
     
        self.tableView.frame = tableViewframe;
        self.navigationController.navigationBar.frame = CGRectOffset(frame, 0, offsetY);
        
    }];
}

- (BOOL)navBarIsVisible {
    
    return self.navigationController.navigationBar.frame.origin.y >= 0;
    
}

@end