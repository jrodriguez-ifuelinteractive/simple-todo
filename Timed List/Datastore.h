//
//  Datastore.h
//  Timed List
//
//  Created by Jesus Rodriguez on 9/9/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Datastore : NSObject

@property (strong, nonatomic) FMDatabase *db;

- (void)createDatabase;

- (void)openDatabase;

@end
