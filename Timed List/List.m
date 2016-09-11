//
//  List.m
//  Timed List
//
//  Created by Jesus Rodriguez on 9/10/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import "List.h"

@implementation List

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.listId = [[dictionary objectForKey:@"id"] intValue];
        self.title = [dictionary objectForKey:@"title"];
        self.createdAt = [dictionary objectForKey:@"created_at"];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[List class]]) {
        return NO;
    }
    
    List *other = (List *)object;
    return other.listId == self.listId;
}

@end
