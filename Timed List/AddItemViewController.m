//
//  AddItemViewController.m
//  TODO
//
//  Created by Jesus Rodriguez on 9/20/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import "AddItemViewController.h"
#import "Datastore.h"

NSString * const kAddItemLabelTextPlaceholder = @"What would you like to do?";

@interface AddItemViewController ()
@property (nonatomic, retain) CAShapeLayer *maskLayer;
@property (nonatomic, retain) Datastore *store;
@property (nonatomic, strong) UILabel *textViewLabel;
@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.store = [[Datastore alloc] init];
    [self.store openDatabase];
    
    _textViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 6.7, self.addItemTextView.frame.size.width - 10.0, 34.0)];
    
    
    [_textViewLabel setText:kAddItemLabelTextPlaceholder];
    [_textViewLabel setBackgroundColor:[UIColor clearColor]];
    [_textViewLabel setTextColor:[UIColor lightGrayColor]];
    UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:26.0f];
    [_textViewLabel setFont:labelFont];
    
    [self.addItemTextView setDelegate:self];
    [self.addItemTextView addSubview:_textViewLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewDidLayoutSubviews {
    UIBezierPath *topCornersBezier = [UIBezierPath bezierPathWithRoundedRect:self.addItemContainer.bounds
                                                           byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                                 cornerRadii:CGSizeMake(5, 5)];
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.frame = self.addItemContainer.bounds;
    _maskLayer.path = topCornersBezier.CGPath;
    
    self.addItemContainer.layer.mask = _maskLayer;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.addItemTextView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)dismissViewController {
    [self.addItemTextView resignFirstResponder];
    [self.customDelegate dismissViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Create List

- (BOOL)create {
    BOOL result;
    if ([self.segueAction isEqualToString:@"AddListItem"]) {
        NSLog(@"INSERTED: %@", self.addItemTextView.text);
        result = [self.store.db executeUpdate:@"INSERT INTO lists VALUES (NULL, ?, ?);", self.addItemTextView.text, [NSDate date].description];
    } else if ([self.segueAction isEqualToString:@"AddListItemSegue"]) {
        NSString *listIdString = [NSString stringWithFormat:@"%ld", (long)self.list.listId];
        result = [self.store.db executeUpdate:@"INSERT INTO list_items VALUES (NULL, ?, ?, ?);", listIdString, self.addItemTextView.text, [NSDate date].description];
    }

    return result;
}

# pragma mark - UITextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{    
    if ([text isEqualToString:@"\n"]) {
        if ([self create]) {
            [self dismissViewController];
        }
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (![textView hasText]) {
        _textViewLabel.hidden = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (![textView hasText]) {
        _textViewLabel.hidden = NO;
    }else {
        _textViewLabel.hidden = YES;
    }
}

@end
