//
//  Datastore.m
//  Timed List
//
//  Created by Jesus Rodriguez on 9/9/16.
//  Copyright © 2016 Jesus Rodriguez. All rights reserved.
//

#import "Datastore.h"

static NSString *const kInstalledDbKey = @"db_installed";
static NSString *const kDatabaseFile = @"items.db";

@implementation Datastore

- (void)createDatabase
{
    [self openDatabase];
}

- (void)openDatabase
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Database"];
    NSString *filePath = [path stringByAppendingPathComponent:kDatabaseFile];
    
    
    BOOL directoryCreated = [self createDirectoryWithPath: path];
    if (!directoryCreated) {
        return;
    }
    
    if (![self isDatabaseInstalled]) {
        [self removeDatabaseFileAtPath:path];
    }
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    if (![_db open]) {
        return;
    }
    
    if (![self isDatabaseInstalled]) {
        [self databaseSetup];
    }
}

#pragma mark - Private Methods

- (BOOL)createDirectoryWithPath:(NSString *)path
{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    NSError *error;
    if (![manager fileExistsAtPath:path]) {
        if (![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Create directory error: %@", error.description);
            return false;
        }
    }
    
    return true;
}

- (void)removeDatabaseFileAtPath:(NSString *)path {
    NSString *filePath = [path stringByAppendingPathComponent:kDatabaseFile];
    NSLog(@"Removing file: %@", filePath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

- (BOOL)isDatabaseInstalled {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:kInstalledDbKey]) {
        [defaults setBool:YES forKey:kInstalledDbKey];
        [defaults synchronize];

        return NO;
    }

    return YES;
}

- (void)databaseSetup {
    
    NSString *sql = @"CREATE TABLE `lists` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT, `created_at` TEXT);"
                     "CREATE TABLE `list_items` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `list_id` INTEGER, `title` TEXT, `created_at` TEXT);";
    BOOL success = [_db executeStatements:sql];
    if (success) {
        NSLog(@"created table");
    }
    
//    for (int x = 0; x<100; x++) {
//        [_db executeUpdate:@"INSERT INTO lists VALUES (NULL, ?, ?);", [NSString stringWithFormat:@"Item %d", x ], [NSDate date].description];
//    }
}

@end
