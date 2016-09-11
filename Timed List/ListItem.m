//
//  ListItem.m
//  Timed List
//
//  Created by Jesus Rodriguez on 9/10/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import "ListItem.h"

@implementation ListItem

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.listItemId = [[dictionary objectForKey:@"id"] intValue];
        self.listId = [[dictionary objectForKey:@"list_id"] intValue];
        self.title = [dictionary objectForKey:@"title"];
        self.createdAt = [dictionary objectForKey:@"created_at"];
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[ListItem class]]) {
        return NO;
    }
    
    ListItem *other = (ListItem *)object;
    return other.listItemId == self.listItemId;
}

@end
