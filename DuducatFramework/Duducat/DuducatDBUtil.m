//
//  DuducatDBUtil.m
//  DuduLabFramework
//
//  Created by dyun on 4/15/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import "DuducatDBUtil.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "DuducatObject.h"

@interface DuducatDBUtil()
+ (FMDatabase *)getDatabase;
@end

@implementation DuducatDBUtil

static FMDatabase *database;

+ (FMDatabase *)getDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *directory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [directory stringByAppendingPathComponent:@"duducat.sqlite"];
        database = [FMDatabase databaseWithPath:path];
        if ([database open] && ![database tableExists:@"duducat"]) {
            NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS duducat (_id INTEGER PRIMARY KEY AUTOINCREMENT, K TEXT NOT NULL, V TEXT, md5 TEXT, status TEXT, type INTEGER, startDate REAL, endDate REAL, updateDate REAL, unique(K, type));";
            BOOL r = [database executeUpdate:createTableSQL];
            if (!r) {
                NSLog(@"Create  table duducat error, %@", [database lastError].description);
            }
        }
    });
    return database;
}

+ (NSMutableArray *)getAllKeys
{
    NSMutableArray *keys = [NSMutableArray array];
    NSString *sql = @"SELECT K,md5,type FROM duducat";
    FMResultSet *rs = [[self getDatabase]executeQuery:sql];
    while ([rs next]) {
        NSString *kv = [rs stringForColumn:@"K"];
        if (kv) {
            [keys addObject:kv];
            [keys addObject:@","];
            NSString *md5 = [rs stringForColumn:@"md5"];
            if (!md5) {
                md5 = @"";
            }
            [keys addObject:md5];
            [keys addObject:@","];
            [keys addObject:[NSString stringWithFormat:@"%d", [rs intForColumn:@"type"]]];
            //The semicolon for the update format.
            //When you need update all the keys, pass query str like key,md5;key,md5;
            [keys addObject:@";"];
        }
    }
    if (keys.count > 0) {
        //remove the last semicolon;
        [keys removeLastObject];
    }
    return keys;
}

+ (BOOL)saveDuducatObject:(DuducatObject *)object
{
    NSString *sql = @"REPLACE INTO duducat (K, V, md5, status, type, startDate, endDate, updateDate) VALUES (?,?,?,?,?,?,?,?);";
    FMDatabase *db = [self getDatabase];
    BOOL r = [db executeUpdate:sql, object.K, object.V, object.md5, object.status, [NSNumber numberWithInteger:object.type], [NSNumber numberWithDouble:object.startDate], [NSNumber numberWithDouble:object.endDate], [NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970]];
    if (!r) {
        NSLog(@"%@", [db lastError].description);
    }
    return r;
}

+ (DuducatObject *)getDuducatObject:(NSString *)K type:(NSInteger)type
{
    NSString *sql = @"SELECT * FROM duducat WHERE K = ? AND type = ?";
    FMDatabase *db = [self getDatabase];
    FMResultSet *rs = [db executeQuery:sql, K, [NSNumber numberWithInteger:type]];
    DuducatObject *o;
    if (rs) {
        while ([rs next]) {
            o = [DuducatObject new];
            o.K = [rs stringForColumn:@"K"];
            o.V = [rs stringForColumn:@"V"];
            o.startDate = [rs doubleForColumn:@"startDate"];
            o.endDate = [rs doubleForColumn:@"endDate"];
            o.md5 = [rs stringForColumn:@"md5"];
            o.status = [rs stringForColumn:@"status"];
            o.type = [rs intForColumn:@"type"];
        }
    } else {
        NSLog(@"%@", [db lastError].description);
    }
    return o;
}

@end
