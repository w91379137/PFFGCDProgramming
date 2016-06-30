//
//  RecipetUploadOperation.m
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "HTTPBinManagerOperation.h"
#import "WebService.h"
#import "PDSSetting.h"

typedef NS_ENUM(NSUInteger, TaskState) {
    TaskStateGet,
    TaskStatePost,
    TaskStateImage,
    TaskStateFinish
};

@interface HTTPBinManagerOperation()

@end

@implementation HTTPBinManagerOperation

#pragma mark -
- (void)main
{
    @autoreleasepool {
        self.error = nil;
        [self loopAllTask:TaskStateGet];
    }
}

#pragma mark - Task
- (void)loopAllTask:(TaskState)state
{
    weakSelfMake(weakSelf);
    
    switch (state) {
        case TaskStateGet: {
            [self taskGet:^{ [weakSelf loopAllTask:TaskStatePost]; }];
        }   break;
            
        case TaskStatePost: {
            [self taskPost:^{ [weakSelf loopAllTask:TaskStateImage]; }];
        }   break;
            
        case TaskStateImage: {
            [self taskImage:^{ [weakSelf loopAllTask:TaskStateFinish]; }];
        }   break;
            
        default:
            break;
    }
    
    if (self.isCancelled) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate operationNotice:self];
    });
}

- (void)taskGet:(void(^)())callback
{
    [WebService fetchGetResponseWithCallback:^(NSDictionary *dict, NSError *err) {
        if (err) {
            self.error  = err;
            [self cancel];
        }
        else {
            self.getDict = dict;
        }
        
        if(callback) callback();
    }];
}

- (void)taskPost:(void(^)())callback
{
    [WebService postCustomerName:@"test"
                        callback:^(NSDictionary *dict, NSError *err) {
                            
                            if (err) {
                                self.error  = err;
                                [self cancel];
                            }
                            else {
                                self.postDict = dict;
                            }
                            
                            if(callback) callback();
                        }];
}

- (void)taskImage:(void(^)())callback
{
    [WebService fetchImageWithCallback:^(UIImage *image, NSError *err) {
        
        if (err) {
            self.error  = err;
            [self cancel];
        }
        else {
            self.image = image;
        }
        
        if(callback) callback();
    }];
}

#pragma mark -
- (void)cancel
{
    [super cancel];
    self.error =
    [NSError errorWithDomain:@"call cancel method"
                        code:-1
                    userInfo:@{@"Description":@"call cancel method"}];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate operationNotice:self];
    });
}

- (float)progress
{
    float progress = 0;
    if (self.getDict) progress += .33;
    if (self.postDict) progress += .33;
    if (self.image) progress += .34;
    return progress;
}

@end
