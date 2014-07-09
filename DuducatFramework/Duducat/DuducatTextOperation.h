//
//  DuducatTextOperation.h
//  DuducatFramework
//
//  Created by dyun on 4/16/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuducatOperation.h"

@interface DuducatTextOperation : DuducatOperation

- (instancetype)initWithKey:(NSString *)key completeBlock:(DuducatOperationCompleteBlock)completeBlock;

@end
