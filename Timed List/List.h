//
//  List.h
//  Timed List
//
//  Created by Jesus Rodriguez on 9/10/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface List : NSObject

@property (nonatomic, assign) NSInteger listId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *createdAt;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
