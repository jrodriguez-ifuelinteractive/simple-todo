//
//  ItemsViewController.m
//  Timed List
//
//  Created by Jesus Rodriguez on 9/9/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import "ItemsViewController.h"
#import "ListItemsTableViewController.h"
#import "Datastore.h"
#import "List.h"
#import "FMResultSet.h"
#import "JERActionSheet.h"
#import "AddItemViewController.h"

const int kLoadingCellTag = 1337;

@interface ItemsViewController ()
@property (nonatomic, retain) NSMutableArray *lists;
@property (nonatomic, retain) Datastore *store;
@end

@implementation ItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Datastore
    self.store = [[Datastore alloc] init];
    [self.store openDatabase];
    
    // Create empty array
    self.lists = [NSMutableArray array];
    
    _currentPage = 0;
    
    self.dimView = [[JERDimView alloc] initWithViewController:self.navigationController];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_currentPage > 0) {
        [self fetchItems];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return self.lists.count + 1;
    }

    return self.lists.count;
}

- (UITableViewCell *)listCellForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    List *list = [self.lists objectAtIndex: indexPath.row];
    cell.textLabel.text = list.title;
    cell.detailTextLabel.text = list.createdAt;
    
    return cell;
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.lists.count) {
        return [self listCellForIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag) {
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
        List *list = [self.lists objectAtIndex: indexPath.row];
        JERActionSheet *alert = [[JERActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"\"%@\" will be deleted forever.", list.title]
                                                               message:nil];
        [alert addDestructiveActionWithTitle:@"Delete List"
                                      handler:^(UIAlertAction * action) {
                                          NSString *listIdString = [NSString stringWithFormat:@"%ld", list.listId];
                                          if ([self.store.db executeUpdate:@"DELETE FROM lists WHERE id = ?", listIdString]) {
                                              [self.store.db executeUpdate:@"DELETE FROM list_items WHERE list_id = ?", listIdString];
                                              [self.lists removeObjectAtIndex:indexPath.row];
                                              [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                          }
                                      }];
        [alert addCancelActionWithTitle:@"Cancel"
                                handler:^(UIAlertAction * action) {
                                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                                }];
        
        [self presentViewController:[alert actionSheet] animated:YES completion:nil];
    }
    
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual: @"ListItemsSegue"]) {
        ListItemsTableViewController *vc = [segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        List *list = [self.lists objectAtIndex: indexPath.row];
        vc.list = list;
        
    } else if ([[segue identifier] isEqualToString:@"AddListItem"]) {
        AddItemViewController *vc = [segue destinationViewController];
        vc.customDelegate = self;
        vc.segueAction = @"AddListItem";
        
        [self.dimView displayDimView];
    }
}

- (void)dismissViewController {
    [self fetchItems];
    [self.dimView removeDimView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Fetching

- (void)fetchItems {
    
    float offset = 0;
    float limit = 20;
    FMResultSet *totalPages = [self.store.db executeQuery:@"SELECT COUNT(*) FROM lists"];
    if ([totalPages next]) {
        _totalPages = ceil([totalPages intForColumnIndex: 0] / limit);
    }
    
    offset = (_currentPage - 1) * limit;
    
    NSString *offsetString = [NSString stringWithFormat:@"%f", offset];
    NSString *limitString = [NSString stringWithFormat:@"%f", limit];
    
    FMResultSet *s = [self.store.db executeQuery:@"SELECT * FROM lists LIMIT ? OFFSET ?;", limitString, offsetString];
    while ([s next]) {
        NSDictionary *listDictionary = [s resultDictionary];
        List *list = [[List alloc] initWithDictionary:listDictionary];
        if (![self.lists containsObject:list]) {
            [self.lists addObject:list];
        }
    }
    
    [self.tableView reloadData];
    
}


@end
