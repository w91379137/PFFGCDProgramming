//
//  WebService.m
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "WebService.h"

@implementation WebService

+ (void)fetchGetResponseWithCallback:(void(^)(NSDictionary *dict, NSError *err))callback
{
    if (!callback) return;
    
    NSURL *URL = [NSURL URLWithString:@"http://httpbin.org/get"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *task =
    [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (error) {
                                                callback(nil, error);
                                            }
                                            else {
                                                NSError *jsonError = nil;
                                                id json =
                                                [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&jsonError];
                                                
                                                if ([json isKindOfClass:[NSDictionary class]]) {
                                                    callback(json, error);
                                                }
                                                else {
                                                    callback(nil, error);
                                                }
                                            }
                                        });
                                    }];
    [task resume];
}

+ (void)postCustomerName:(NSString *)name
                callback:(void(^)(NSDictionary *dict, NSError *err))callback
{
    if (!callback) return;
    if (!name) {
        callback(nil, nil);
        return;
    }
    
    //http://stackoverflow.com/questions/19099448/send-post-request-using-nsurlsession
    //http://stackoverflow.com/questions/6148900/append-data-to-a-post-nsurlrequest
    
    NSURL *url = [NSURL URLWithString:@"http://httpbin.org/post"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSError *jsonError;
    NSData *postData =
    [NSJSONSerialization dataWithJSONObject:@{@"custname": name}
                                    options:0
                                      error:&jsonError];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask =
    [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (error) {
                                                callback(nil, error);
                                            }
                                            else {
                                                NSError *jsonError = nil;
                                                id json =
                                                [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&jsonError];
                                                
                                                if ([json isKindOfClass:[NSDictionary class]]) {
                                                    callback(json, error);
                                                }
                                                else {
                                                    callback(nil, error);
                                                }
                                            }
                                        });
                                    }];
    
    [postDataTask resume];
}

+ (void)fetchImageWithCallback:(void(^)(UIImage *image, NSError *err))callback
{
    if (!callback) return;
    
    NSURL *URL = [NSURL URLWithString:@"http://httpbin.org/image/png"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *task =
    [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (error) {
                                                callback(nil, error);
                                            }
                                            else {
                                                UIImage *image = [UIImage imageWithData:data];
                                                
                                                if ([image isKindOfClass:[UIImage class]]) {
                                                    callback(image, error);
                                                }
                                                else {
                                                    callback(nil, error);
                                                }
                                            }
                                        });
                                        
                                    }];
    [task resume];
}

@end
