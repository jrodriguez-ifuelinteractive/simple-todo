//
//  ItemsViewController.h
//  Timed List
//
//  Created by Jesus Rodriguez on 9/9/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsViewController : UITableViewController {
    NSInteger _currentPage;
    NSInteger _totalPages;
}

- (void)fetchItems;

@end
