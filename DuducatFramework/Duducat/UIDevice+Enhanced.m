//
//  UIDevice+Enhanced.m
//  HuXiu
//
//  Created by Huxiu on 8/22/13.
//  Copyright (c) 2013 HuXiu. All rights reserved.
//

#import "UIDevice+Enhanced.h"

#include <sys/utsname.h>

@implementation UIDevice (Enhanced)
// Utility method (private)
- (NSString*) platformCode {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* platform =  [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"platform = %@", platform);
    return platform;
}

// Public method to use
- (NSString*) platformName {
    return [self platformCode];
}

// Public method to use
- (PlatformType) platform {
    NSString *platform = [self platformCode];
    if ([platform isEqualToString:@"iPhone1,1"])    return kiPhone1G;
    if ([platform isEqualToString:@"iPhone1,2"])    return kiPhone3G;
    if ([platform isEqualToString:@"iPhone2,1"])    return kiPhone3GS;
    if ([platform isEqualToString:@"iPhone3,1"])    return kiPhone4;
    if ([platform isEqualToString:@"iPhone3,2"])    return kiPhone4Verizon;
    if ([platform isEqualToString:@"iPhone4,1"])    return kiPhone4S;
    if ([platform isEqualToString:@"iPod1,1"])      return kiPodTouch1G;
    if ([platform isEqualToString:@"iPod2,1"])      return kiPodTouch2G;
    if ([platform isEqualToString:@"iPod3,1"])      return kiPodTouch3G;
    if ([platform isEqualToString:@"iPod4,1"])      return kiPodTouch4G;
    if ([platform isEqualToString:@"iPad1,1"])      return kiPad;
    if ([platform isEqualToString:@"iPad2,1"])      return kiPad2Wifi;
    if ([platform isEqualToString:@"iPad2,2"])      return kiPad2GSM;
    if ([platform isEqualToString:@"iPad2,3"])      return kiPad2CMDA;
    if ([platform isEqualToString:@"i386"])         return kSimulator;
    
    return kUnknownPlatform;
}
@end
