//
//  RecipetUploadOperation.m
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "HTTPBinManagerOperation.h"
#import "WebService.h"

@interface HTTPBinManagerOperation()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation HTTPBinManagerOperation

- (void)main
{
    @autoreleasepool {
        
        self.error = nil;
        self.semaphore = dispatch_semaphore_create(0);
        {
            [WebService fetchImageWithCallback:^(UIImage *image, NSError *err) {
                
                if (err) {
                    self.error  = err;
                    [self cancel];
                }
                else {
                    self.image = image;
                }
                
                dispatch_semaphore_signal(self.semaphore);
            }];
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            
            if (self.isCancelled) return;
            [self.delegate operationNotice:self];
        }
        
        {
            [WebService fetchGetResponseWithCallback:^(NSDictionary *dict, NSError *err) {
                
                if (err) {
                    self.error  = err;
                    [self cancel];
                }
                else {
                    self.getDict = dict;
                }
                
                dispatch_semaphore_signal(self.semaphore);
            }];
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            
            if (self.isCancelled) return;
            [self.delegate operationNotice:self];
        }
        
        {
            [WebService postCustomerName:@"kkbox"
                                callback:^(NSDictionary *dict, NSError *err) {
                                    
                                    if (err) {
                                        self.error  = err;
                                        [self cancel];
                                    }
                                    else {
                                        self.postDict = dict;
                                    }
                                    
                                    dispatch_semaphore_signal(self.semaphore);
                                }];
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            
            if (self.isCancelled) return;
            [self.delegate operationNotice:self];
        }
    }
}

- (void)cancel
{
    [super cancel];
    dispatch_semaphore_signal(self.semaphore);
    [self.delegate operationNotice:self];
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
