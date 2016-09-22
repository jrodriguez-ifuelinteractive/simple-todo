//
//  AddItemViewController.h
//  TODO
//
//  Created by Jesus Rodriguez on 9/20/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "ListItem.h"
#import "JERUIViewControllerPresentation.h"

@interface AddItemViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *addItemContainer;
@property (strong, nonatomic) IBOutlet UITextView *addItemTextView;

@property (strong, nonatomic) List *list;
@property (strong, nonatomic) ListItem *listItem;
@property (nonatomic, strong) NSString *segueAction;

@property (nonatomic, assign) id <JERUIViewControllerPresentation> customDelegate;

@end
