//
//  DuducatObject.h
//  DuducatFramework
//
//  Created by dyun on 4/15/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    An Duducat object represent a record of 'key-vale' format of the data form the server.
    It contains a md5 property to check if there is any upate in future.
 */

extern NSString *const kDuducatSuccess;
extern NSString *const kDuducatInvalid;
extern NSString *const kDuducatNoupdate;

@interface DuducatObject : NSObject

@property (strong, nonatomic) NSString *K;
@property (strong, nonatomic) NSString *V;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) NSTimeInterval endDate;
@property (strong, nonatomic) NSString *md5;
@property (nonatomic) NSInteger type;
//This status is only maintained on client. Assign the init @see DuducatObjectStatus_Valid when insert or update
//Value should be 'success', 'noupdate', 'invalid'
@property (strong, nonatomic) NSString *status;

- (BOOL)isExpired;

- (BOOL)isValid;

- (BOOL)isSuccess;

- (BOOL)isNoupdate;

+ (instancetype)fromData:(id)data;

+ (NSMutableArray *)arrayFromData:(id)data;

@end
