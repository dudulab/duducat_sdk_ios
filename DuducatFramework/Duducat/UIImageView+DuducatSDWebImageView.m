//
//  UIImageView+DuducatSDWebImageView.m
//  DuducatFramework
//
//  Created by dyun on 4/17/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

static char operationKey;
static char operationArrayKey;

#import "objc/runtime.h"
#import "UIImageView+DuducatSDWebImageView.h"
#import "DuducatDBUtil.h"
#import "DuducatNetUtil.h"
#import "DuducatConstant.h"

@implementation UIImageView (DuducatSDWebImageView)

- (void)setImageWithKey:(NSString *)key {
    [self setImageWithKey:key placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithKey:(NSString *)key placeholderImage:(UIImage *)placeholder {
    [self setImageWithKey:key placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithKey:(NSString *)key placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self setImageWithKey:key placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithKey:(NSString *)key completed:(SDWebImageCompletedBlock)completedBlock {
    [self setImageWithKey:key placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithKey:(NSString *)key placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock {
    [self setImageWithKey:key placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithKey:(NSString *)key placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
    [self setImageWithKey:key placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)setImageWithKey:(NSString *)key placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock {
    
    self.image = placeholder;
    DuducatObject *object = [DuducatDBUtil getDuducatObject:key type:DuduType_IMAGE];
    
    void (^async) (NSURL *url) =  ^ (NSURL *url) {
        if (url) {
            __weak UIImageView *wself = self;
            id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                if (!wself) return;
                dispatch_main_sync_safe(^{
                    if (!wself) return;
                    if (image) {
                        wself.image = image;
                        [wself setNeedsLayout];
                    }
                    if (completedBlock && finished) {
                        completedBlock(image, error, cacheType);
                    }
                });
            }];
            objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    };
    
    if (object && [object isValid]) {
        async ([NSURL URLWithString:object.V]);
    } else if (!object || (object.isValid && object.isExpired)) {
        [[NSOperationQueue new]addOperationWithBlock:^{
            DuducatObject *object = [DuducatNetUtil requestWithKey:key type:DuduType_IMAGE appid:g_appid appsecret:g_appsecret];
            if (object && [object isValid]) {
                [DuducatDBUtil saveDuducatObject:object];
                NSURL *url = [NSURL URLWithString:object.V];
                //remove the image for the url from the SDWebImaageCache;
                [[SDImageCache sharedImageCache]removeImageForKey:object.V];
                [self cancelCurrentImageLoad];
                async(url);
            }
        }];
    }
}

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self cancelCurrentArrayLoad];
    __weak UIImageView *wself = self;
    
    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];
    
    for (NSURL *logoImageURL in arrayOfURLs) {
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];
                    
                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }
    
    objc_setAssociatedObject(self, &operationArrayKey, [NSArray arrayWithArray:operationsArray], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cancelCurrentImageLoad {
    // Cancel in progress downloader from queue
    id <SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation) {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)cancelCurrentArrayLoad {
    // Cancel in progress downloader from queue
    NSArray *operations = objc_getAssociatedObject(self, &operationArrayKey);
    for (id <SDWebImageOperation> operation in operations) {
        if (operation) {
            [operation cancel];
        }
    }
    objc_setAssociatedObject(self, &operationArrayKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
