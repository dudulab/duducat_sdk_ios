//
//  UILabel+Duducat.m
//  DuducatFramework
//
//  Created by dyun on 4/16/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import "UILabel+Duducat.h"
#import "DuducatSharedDownloader.h"

@implementation UILabel (Duducat)

- (void)setTextWithKey:(NSString *)key placeholderText:(NSString *)placeholderText
{
    [self setText:placeholderText];
    __weak UILabel *sself = self;
    [[DuducatSharedDownloader sharedDownloader]textWithKey:key completeBlock:^(NSString *key, DuducatObject *object) {
        if (sself) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [sself setText:object.V];
            }];
        }
    }];
}

@end
