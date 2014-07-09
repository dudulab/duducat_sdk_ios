//
//  DDCat.m
//  DuducatFramework
//
//  Created by dyun on 4/24/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import "DuduCat.h"
#import "DuducatDBUtil.h"
#import "DuducatNetUtil.h"
#import "DuducatResponse.h"
#import "UIDevice+Enhanced.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "DuducatSharedDownloader.h"
#import <SDWebImage/SDWebImageManager.h>

NSString *g_appid;

NSString *g_appsecret;


@interface Duducat()

@property (strong, nonatomic) NSTimer *updateTimer;

- (void)updateAll;

@end

@implementation Duducat

+ (instancetype)sharedInstance
{
    static Duducat *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [Duducat new];
    });
    return instance;
}

- (void)registerWithAppid:(NSString *)appid appsecret:(NSString *)appsecret;
{
    //register
    NSString *info = [self getSystemInformation];
    g_appid = appid;
    g_appsecret = appsecret;
    [[NSOperationQueue new]addOperationWithBlock:^{
        DuducatResponse *response = [DuducatNetUtil registerWithKey:appid secret:appsecret info:info];
        if (response && response.OK) {
            NSLog(@"Duducat register success with appid = %@, appsecret = %@", appid, appsecret);
        } else {
            NSLog(@"register failed, error = %@", response.msg);
        }
    }];
    //start to update all the keys intervally
    if (self.updateInterval == 0) {
        self.updateInterval = 1800.0f;
    }
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval
                                                        target:self
                                                      selector:@selector(updateAll)
                                                      userInfo:nil
                                                       repeats:YES];
}


- (void)textWithKey:(NSString *)key completeBlock:(DuducatTextCompleteBlock)completeBlock
{
    DuducatOperationCompleteBlock block = ^ (NSString *key, DuducatObject *object) {
        if (object && object.isValid) {
            completeBlock(key, object.V);
        }
    };
    [[DuducatSharedDownloader sharedDownloader] textWithKey:key completeBlock:block];
}

- (void)imageWithKey:(NSString *)key completeBlock:(DuducatImageCompleteBlock)completeBlock
{
    void (^async) (NSURL *url) =  ^ (NSURL *url) {
        if (url) {
            [SDWebImageManager.sharedManager downloadWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (completeBlock && finished) {
                    completeBlock(key, image);
                }
            }];
        }
    };
    
    DuducatObject *object = [DuducatDBUtil getDuducatObject:key type:DuduType_IMAGE];
    if (object && [object isValid]) {
        async ([NSURL URLWithString:object.V]);
    } else if (!object || (object.isValid && object.isExpired)) {
        [[NSOperationQueue new]addOperationWithBlock:^{
            DuducatObject *object = [DuducatNetUtil requestWithKey:key type:DuduType_IMAGE appid:g_appid appsecret:g_appsecret];
            if (object && [object isValid]) {
                [DuducatDBUtil saveDuducatObject:object];
                NSURL *url = [NSURL URLWithString:object.V];
                //remove the image for the url from the SDWebImaageCache;
                async(url);
            }
        }];
    }
}


- (void)updateAll
{
    [[NSOperationQueue new]addOperationWithBlock:^{
        NSArray *keyAndHash = [DuducatDBUtil getAllKeys];
        if (keyAndHash.count > 0) {
            NSString *queryStr = [keyAndHash componentsJoinedByString:@""];
            NSArray *objects = [DuducatNetUtil updateWithKeyAndHashStr:queryStr appid:g_appid appsecret:g_appsecret];
            if (objects.count > 0) {
                [[NSNotificationCenter defaultCenter]postNotificationName:DuduCatUpdateNotification object:self userInfo:nil];
                for (DuducatObject *o in objects) {
                    if (![o isNoupdate]) {
                        [DuducatDBUtil saveDuducatObject:o];
                    }
                }
            }
        }
    }];
}

- (NSString *)getSystemInformation
{
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *sys = currentDevice.systemName;
    NSString *version = currentDevice.systemVersion;
    NSString *carrier = [self getCarrier];
    NSString *resolution = [self getResolution];
    NSString *lang = [[NSLocale preferredLanguages]objectAtIndex:0];
    NSString *platform = [[UIDevice currentDevice] platformCode];
    NSDictionary *information = @{@"sys":sys,@"version":version,@"device":platform,@"carrier":carrier,@"resolution":resolution,@"lang":lang};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:information options:0 error:nil];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)getCarrier
{
    NSString *carrier = [[[CTTelephonyNetworkInfo alloc]init]subscriberCellularProvider].carrierName;
    return carrier ? carrier : @"nosim";
}

- (NSString *)getResolution
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%.0f*%.0f",size.width * scale, size.height * scale];
}

@end
