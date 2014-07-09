//
//  DuducatResponse.h
//  DuducatFramework
//
//  Created by dyun on 6/5/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DuducatResponse : NSObject
@property (nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) id data;

+ (instancetype)fromHttpResponse:(id)response;

- (BOOL)OK;

@end
