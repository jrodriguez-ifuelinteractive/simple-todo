//
//  ItemsViewController.h
//  Timed List
//
//  Created by Jesus Rodriguez on 9/9/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JERUIViewControllerPresentation.h"
#import "JERDimView.h"

@interface ItemsViewController : UITableViewController <JERUIViewControllerPresentation> {
    NSInteger _currentPage;
    NSInteger _totalPages;
}

@property (nonatomic, strong) JERDimView *dimView;

- (void)fetchItems;
- (void)dismissViewController;

@end
