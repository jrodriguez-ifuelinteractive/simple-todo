//
//  JERActionSheet.h
//  TODO
//
//  Created by Jesus Rodriguez on 9/11/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JERActionSheet : NSObject

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)addDestructiveActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction * action))handler;

- (void)addCancelActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction * action))handler;

- (UIAlertController *)actionSheet;

@end
