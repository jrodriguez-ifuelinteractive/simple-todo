//
//  JERDimView.h
//  TODO
//
//  Created by Jesus Rodriguez on 9/21/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JERDimView : NSObject

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, assign) BOOL isPresented;

- (instancetype)initWithViewController:(UIViewController*)viewController;

- (void)displayDimView;

- (void)removeDimView;

@end
