//
//  ListItemsTableViewController.m
//  Timed List
//
//  Created by Jesus Rodriguez on 9/10/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import "ListItemsTableViewController.h"
#import "ItemsViewController.h"
#import "ListViewController.h"
#import "Datastore.h"
#import "ListItem.h"
#import "FMResultSet.h"
#import "JERActionSheet.h"

const int kLoadingCellTag2 = 1378;

@interface ListItemsTableViewController ()
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) Datastore *store;
@end

@implementation ListItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Create Datastore
    self.store = [[Datastore alloc] init];
    [self.store openDatabase];
    
    // Create empty array
    self.items = [NSMutableArray array];
    
    _currentPage = 0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController topViewController].title = self.list.title;
    if (_currentPage > 0) {
        [self fetchItems];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_currentPage == 0) {
        return 1;
    }
    
    if (_currentPage < _totalPages) {
        return self.items.count + 1;
    }
    
    return self.items.count;
}

- (UITableViewCell *)listCellForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    ListItem *listItem = [self.items objectAtIndex: indexPath.row];
    cell.textLabel.text = listItem.title;
    cell.detailTextLabel.text = listItem.createdAt;
    
    return cell;
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag2;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.items.count) {
        return [self listCellForIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag2) {
        _currentPage++;
        [self fetchItems];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Edit table view

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ListItem *listItem = [self.items objectAtIndex: indexPath.row];
        NSString *listItemIdString = [NSString stringWithFormat:@"%ld", listItem.listItemId];
        if ([self.store.db executeUpdate:@"DELETE FROM list_items WHERE id = ?", listItemIdString]) {
            [self.items removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Done!";
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"AddListItemSegue"]) {
        ListViewController *vc = [[[segue destinationViewController] childViewControllers] firstObject];
        
        vc.list = self.list;
        vc.segueAction = @"AddListItemSegue";
    }
}

#pragma mark - Fetching

- (void)fetchItems {
    
    float offset = 0;
    float limit = 20;
    NSString *listIdString = [NSString stringWithFormat:@"%ld", self.list.listId];
    FMResultSet *totalPages = [self.store.db executeQuery:@"SELECT COUNT(*) FROM list_items WHERE list_id = ?", listIdString];
    if ([totalPages next]) {
        _totalPages = ceil([totalPages intForColumnIndex: 0] / limit);
    }
    
    offset = (_currentPage - 1) * limit;
    
    NSString *offsetString = [NSString stringWithFormat:@"%f", offset];
    NSString *limitString = [NSString stringWithFormat:@"%f", limit];
    
    FMResultSet *s = [self.store.db executeQuery:@"SELECT * FROM list_items WHERE list_id = ? LIMIT ? OFFSET ?;", listIdString, limitString, offsetString];
    while ([s next]) {
        NSDictionary *listDictionary = [s resultDictionary];
        
        ListItem *list = [[ListItem alloc] initWithDictionary:listDictionary];
        if (![self.items containsObject:list]) {
            [self.items addObject:list];
        }
    }
    
    [self.tableView reloadData];
    
}

@end
