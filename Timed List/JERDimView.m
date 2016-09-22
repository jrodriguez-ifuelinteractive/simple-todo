//
//  JERDimView.m
//  TODO
//
//  Created by Jesus Rodriguez on 9/21/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import "JERDimView.h"

static float kAnimationDuration = 0.5;
static float kStartOpacity = 0.0;
static float kEndOpacity = 0.8f;

@implementation JERDimView

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if ((self = [super init])) {
        self.viewController = viewController;
    }
    return self;
}

- (void)displayDimView {
    self.dimView = [[UIView alloc] initWithFrame:self.viewController.view.frame];
    self.dimView.backgroundColor = [UIColor blackColor];
    self.dimView.alpha = kStartOpacity;
    NSDictionary *view = @{@"dimView":self.dimView};
    
    [self.viewController.view addSubview:self.dimView];
    
    // Deal with Auto Layout
    [self.dimView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.viewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[dimView]|" options:0 metrics:nil views:view]];
    [self.viewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dimView]|" options:0 metrics:nil views:view]];
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.dimView.alpha = kEndOpacity;
                     }
                     completion:^(BOOL finished) {
                         self.isPresented = YES;
                     }];
}

- (void)removeDimView {
    if (!self.isPresented) {
        return;
    }
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.dimView.alpha = kStartOpacity;
                     }
                     completion:^(BOOL finished){
                         [self.dimView removeFromSuperview];
                     }];
}

@end
