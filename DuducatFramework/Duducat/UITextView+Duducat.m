//
//  UITextView+Duducat.m
//  DuducatFramework
//
//  Created by dyun on 6/17/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import "UITextView+Duducat.h"
#import "DuducatObject.h"
#import "DuducatSharedDownloader.h"

@implementation UITextView (Duducat)

- (void)setTextWithKey:(NSString *)key placeholderText:(NSString *)placeholderText
{
    [self setText:placeholderText];
    __weak UITextView *sself = self;
    [[DuducatSharedDownloader sharedDownloader]textWithKey:key completeBlock:^(NSString *key, DuducatObject *object) {
        if (sself) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [sself setText:object.V];
            }];
        }
    }];
}

@end
