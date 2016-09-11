//
//  ListViewController.h
//  Timed List
//
//  Created by Jesus Rodriguez on 9/10/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "ListItem.h"

@interface ListViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *createNavigationButton;
@property (strong, nonatomic) IBOutlet UITextField *listName;
@property (strong, nonatomic) List *list;
@property (strong, nonatomic) ListItem *listItem;
@property (nonatomic, strong) NSString *segueAction;
- (IBAction)cancelAction:(id)sender;
- (IBAction)createAction:(id)sender;

@end
