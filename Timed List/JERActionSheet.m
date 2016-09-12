//
//  JERActionSheet.m
//  TODO
//
//  Created by Jesus Rodriguez on 9/11/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import "JERActionSheet.h"

@interface JERActionSheet () {
    UIAlertController *_alertController;
}

@end

@implementation JERActionSheet

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    
    if (self = [super init]) {
    
        _alertController = [UIAlertController alertControllerWithTitle:title
                                                               message:message
                                                        preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    return self;
}

- (void)addDestructiveActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction * action))handler {
    [self addActionWithTitle:title
                        Type:UIAlertActionStyleDestructive
                     Handler:handler];
}

- (void)addCancelActionWithTitle:(NSString *)title handler:(void (^)(UIAlertAction * action))handler {
    [self addActionWithTitle:title
                       Type:UIAlertActionStyleCancel
                     Handler:handler];
}

- (UIAlertController *)actionSheet {
    return _alertController;
}

#pragma mark - Private methods

- (void)addActionWithTitle:(NSString *)title Type:(UIAlertActionStyle)type Handler:(void (^)(UIAlertAction * action))handler  {
    UIAlertAction *action = [UIAlertAction actionWithTitle:title
                                                     style:type
                                                   handler:handler];
    
    [_alertController addAction: action];
}

@end
