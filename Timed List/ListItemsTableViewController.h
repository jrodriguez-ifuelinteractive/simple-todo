//
//  ListItemsTableViewController.h
//  Timed List
//
//  Created by Jesus Rodriguez on 9/10/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "JERUIViewControllerPresentation.h"
#import "JERDimView.h"

@interface ListItemsTableViewController : UITableViewController <JERUIViewControllerPresentation> {
    NSInteger _currentPage;
    NSInteger _totalPages;
}

@property (nonatomic, retain) List *list;
@property (nonatomic, strong) JERDimView *dimView;

- (void)fetchItems;
- (void)setList:(List *)list;

@end
