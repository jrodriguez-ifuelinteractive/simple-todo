//
//  ListViewController.m
//  Timed List
//
//  Created by Jesus Rodriguez on 9/10/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import "ListViewController.h"
#import "Datastore.h"

@interface ListViewController ()
@property (nonatomic, retain) Datastore *store;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Added event observer
    [self.listName addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    self.store = [[Datastore alloc] init];
    [self.store openDatabase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.segueAction isEqual:@"AddListItemSegue"]) {
        [self.navigationController topViewController].title = @"New Item";
    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewController];
}

- (IBAction)createAction:(id)sender {
    [self create];
}

# pragma mark - Veiw Controller helpers

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - Create List

- (void)create {
    BOOL result;
    if ([self.segueAction isEqualToString:@"AddListItem"]) {
        result = [self.store.db executeUpdate:@"INSERT INTO lists VALUES (NULL, ?, ?);", self.listName.text, [NSDate date].description];
    } else if ([self.segueAction isEqualToString:@"AddListItemSegue"]) {
        NSString *listIdString = [NSString stringWithFormat:@"%ld", self.list.listId];
        result = [self.store.db executeUpdate:@"INSERT INTO list_items VALUES (NULL, ?, ?, ?);", listIdString, self.listName.text, [NSDate date].description];
    }

    [self dismissViewController];
}

# pragma mark - Text field event

- (void)textFieldDidChange {
    NSUInteger textLength = self.listName.text.length;
    
    if (textLength > 0) {
        self.createNavigationButton.enabled = YES;
    } else {
        self.createNavigationButton.enabled = NO;
    }
}


@end
