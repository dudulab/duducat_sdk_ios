//
//  DuducatTextOperation.m
//  DuducatFramework
//
//  Created by dyun on 4/16/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import "DuducatTextOperation.h"
#import "DuducatObject.h"
#import "DuducatNetUtil.h"
#import "DuducatConstant.h"

@implementation DuducatTextOperation
{
    DuducatOperationCompleteBlock _completeBlock;
}

- (instancetype)initWithKey:(NSString *)key completeBlock:(DuducatOperationCompleteBlock)completeBlock
{
    self = [super initWithKey:key];
    if (self) {
        _completeBlock = completeBlock;
    }
    return self;
}

- (void)start
{
    [super start];
    DuducatObject *object = [DuducatNetUtil requestWithKey:_key type:DuduType_TEXT appid:g_appid appsecret: g_appsecret];
    if (_completeBlock) {
        _completeBlock (_key, object);
    }
}

- (BOOL)isConcurrent
{
    //All the operation is done in the shared queue in @see DuducatSharedDownloader
    return NO;
}

@end
