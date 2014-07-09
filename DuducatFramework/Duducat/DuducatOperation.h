//
//  DuducatOperation.h
//  DuducatFramework
//
//  Created by dyun on 4/16/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuducatObject.h"

typedef void (^DuducatOperationCompleteBlock)(NSString *key, DuducatObject *object);

@interface DuducatOperation : NSOperation
{
    @protected
    NSString *_key;
}

- (instancetype)initWithKey:(NSString *)key;

@end
