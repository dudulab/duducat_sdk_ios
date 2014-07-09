//
//  DuducatNetUtil.h
//  DuducatFramework
//
//  Created by dyun on 4/17/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuducatObject.h"
#import "DuducatResponse.h"

#define TEST

@interface DuducatNetUtil : NSObject

+ (DuducatResponse *)registerWithKey:(NSString *)key secret:(NSString *)secret info:(NSString *)info;

+ (DuducatObject *)requestWithKey:(NSString *)key type:(NSInteger)type appid:(NSString *)appid appsecret:(NSString *)appsecret;

+ (NSArray *)updateWithKeyAndHashStr:(NSString *)keyAndHash appid:(NSString *)appid appsecret:(NSString *)appsecret;

@end
