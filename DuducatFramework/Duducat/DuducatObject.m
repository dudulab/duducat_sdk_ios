//
//  DuducatObject.m
//  DuducatFramework
//
//  Created by dyun on 4/15/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import "DuducatObject.h"

NSString *const kDuducatSuccess = @"success";
NSString *const kDuducatInvalid = @"invalid";
NSString *const kDuducatNoupdate = @"noupdate";

@implementation DuducatObject

- (BOOL)isExpired
{
    return self.endDate < [NSDate date].timeIntervalSince1970;
}

- (BOOL)isSuccess
{
    return [self.status isEqualToString:kDuducatSuccess] || !self.status;
}

- (BOOL)isNoupdate
{
    return [self.status isEqualToString:kDuducatNoupdate];
}

- (BOOL)isValid
{
    return  ![self isExpired] && [self isSuccess];
}


+ (instancetype)fromData:(id)data
{
    DuducatObject *object;
    
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        NSString *K = [data objectForKey:@"key"];
        if (K) {
            object = [DuducatObject new];
            object.K = K;
            object.V = [data objectForKey:@"value"];
            object.status = [data objectForKey:@"status"];
            if ([object isSuccess]) {
                object.startDate = [[data objectForKey:@"starttime"]doubleValue];
                object.endDate = [[data objectForKey:@"endtime"]doubleValue];
                object.md5 = [data objectForKey:@"md5"];
                object.type = [[data objectForKey:@"type"]integerValue];
            }
        }
    }
    return object;
}

+  (NSMutableArray *)arrayFromData:(id)data
{
    NSMutableArray *objects = [NSMutableArray array];
    if (data && [data isKindOfClass:[NSArray class]]) {
        for (id d in data) {
            DuducatObject *o = [self fromData:d];
            if (o) {
                [objects addObject:o];
            }
        }
    }
    return objects;
}

@end
