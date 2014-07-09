//
//  DuducatResponse.m
//  DuducatFramework
//
//  Created by dyun on 6/5/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import "DuducatResponse.h"

@implementation DuducatResponse

+ (instancetype)fromHttpResponse:(id)response
{
    DuducatResponse *r = nil;
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        r = [DuducatResponse new];
        r.code = [[response objectForKey:@"code"]integerValue];
        r.msg = [response objectForKey:@"msg"];
        r.data = [response objectForKey:@"data"];
    }
    return r;
}

- (BOOL)OK
{
    return self.code == 0;
}

@end
