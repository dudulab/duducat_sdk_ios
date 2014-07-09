//
//  DuducatSharedDownloader.m
//  DuducatFramework
//
//  Created by dyun on 4/16/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import "DuducatSharedDownloader.h"
#import "DuducatDBUtil.h"
#import "Duducat.h"

static NSOperationQueue *queue;

@implementation DuducatSharedDownloader

+ (instancetype)sharedDownloader
{
    static DuducatSharedDownloader *downloader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [DuducatSharedDownloader new];
    });
    return downloader;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        queue = [NSOperationQueue new];
        queue.maxConcurrentOperationCount = 5;
    }
    return self;
}

- (void)textWithKey:(NSString *)key completeBlock:(DuducatOperationCompleteBlock)completeBlock
{
    DuducatObject *object = [DuducatDBUtil getDuducatObject:key type:DuduType_TEXT];
    //If the object is invalid from the database,
    //it means the key is deleted or expired from the server.
    if (object && [object isValid]) {
        completeBlock(key, object);
    } else if (!object || (object.isValid && object.isExpired)) {
        DuducatTextOperation *textOperation = [[DuducatTextOperation alloc]initWithKey:key completeBlock:^(NSString *key, DuducatObject *object) {
            if (object && [object isValid]) {
                [DuducatDBUtil saveDuducatObject:object];
                completeBlock(key, object);
            }
        }];
        [queue addOperation:textOperation];
    }
}

@end
