//
//  DuducatDBUtil.h
//  DuduLabFramework
//
//  Created by dyun on 4/15/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DuducatObject.h"

@interface DuducatDBUtil : NSObject

//Get all used keys
+ (NSMutableArray *)getAllKeys;

//Save a new Duducat record
+ (BOOL)saveDuducatObject:(DuducatObject *)object;

//Fetch a record according to the key
+ (DuducatObject *)getDuducatObject:(NSString *)K type:(NSInteger)type;

@end
