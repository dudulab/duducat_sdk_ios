//
//  DuducatNetUtil.m
//  DuducatFramework
//
//  Created by dyun on 4/17/14.
//  Copyright (c) 2014 danyun.liu@gmail.com. All rights reserved.
//

#import "DuducatNetUtil.h"
#import "DuducatResponse.h"

static NSString *host = @"http://api.duducat.com";

@implementation DuducatNetUtil

+ (DuducatResponse *)registerWithKey:(NSString *)key secret:(NSString *)secret info:(NSString *)info
{
    NSString *url = [NSString stringWithFormat:@"%@/ActiveConfig/v1/Register/", host];
    NSString *body = [NSString stringWithFormat:@"appid=%@&secretkey=%@&info=%@",key,secret,info];
    return [self postRequestWithURL:[NSURL URLWithString:url] body:body];
}

+ (DuducatObject *)requestWithKey:(NSString *)key type:(NSInteger)type appid:(NSString *)appid appsecret:(NSString *)appsecret
{
    NSString *k = [NSString stringWithFormat:@"%@:%ld", key, (long)type];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/ActiveConfig/v1/GetKey/?key=%@&appid=%@&secretkey=%@", host, k, appid, appsecret]];
    DuducatResponse *r = [self getRequestWithURL:URL];
    return [DuducatObject fromData:[r.data firstObject]];
}

+ (NSArray *)updateWithKeyAndHashStr:(NSString *)keyAndHash appid:(NSString *)appid appsecret:(NSString *)appsecret
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/ActiveConfig/v1/CheckUpdate/?key=%@&appid=%@&secretkey=%@", host,keyAndHash, appid, appsecret]];
    DuducatResponse *r = [self getRequestWithURL:URL];
    return [DuducatObject arrayFromData:r.data];
}

+ (DuducatResponse *)getRequestWithURL:(NSURL *)URL
{
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    return [self response:request];
}

+ (DuducatResponse *)postRequestWithURL:(NSURL *)URL body:(NSString *)body
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    NSString *encodedBody = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *bodyData = [encodedBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    return [self response:request];
}

+ (DuducatResponse *)response:(NSURLRequest *)request
{
    id jsonObject;
    NSHTTPURLResponse *response; NSError *erro;
    NSData *textData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&erro];
    if (response.statusCode != 200) {
        NSLog(@"Request error, status code = %ld, err = %@", (long)response.statusCode, erro.description);
    } else {
        NSString * text = [[NSString alloc]initWithData:textData encoding:NSUTF8StringEncoding];
#ifdef TEST
        NSLog(@"URL=%@, body = %@, response = %@", request.URL.absoluteString,[[NSString alloc]initWithData:request.HTTPBody encoding:NSUTF8StringEncoding],text);
#endif
        jsonObject = [NSJSONSerialization JSONObjectWithData:textData options:NSJSONReadingMutableContainers error:&erro];
        if (!jsonObject) {
            NSLog(@"deserialized to json error, %@", [erro description]);
        }
    }
    return [DuducatResponse fromHttpResponse:jsonObject];
}

@end
