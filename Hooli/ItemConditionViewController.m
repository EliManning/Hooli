//
//  ItemConditionViewController.m
//  Hooli
//
//  Created by Er Li on 2/16/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ItemConditionViewController.h"
#import "FormManager.h"
#import "OfferCondition.h"
#import "HLTheme.h"
@interface ItemConditionViewController ()

@end

@implementation ItemConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[OfferCondition allConditions]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConditionCell" forIndexPath:indexPath];
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    cell.textLabel.text = [[OfferCondition allConditions]objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[FormManager sharedInstance]setDetailType:HL_ITEM_DETAIL_CONDITION];
    [[FormManager sharedInstance]setItemCondition:[[OfferCondition allConditions]objectAtIndex:indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];
    //[[HLSettings sharedInstance]setCategory:categoryArray];
    
}

@end
