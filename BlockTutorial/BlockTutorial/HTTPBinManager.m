//
//  HTTPBinManager.m
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "HTTPBinManager.h"
#import "HTTPBinManagerOperation.h"

@interface HTTPBinManager()
<HTTPBinManagerOperationDelegate>

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation HTTPBinManager

#pragma mark - Init
+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
    }
    return self;
}

#pragma mark -
- (void)executeOperation
{
    [self.queue cancelAllOperations];
    self.progress = 0;
    self.isCancelled = NO;
    
    HTTPBinManagerOperation *op = [HTTPBinManagerOperation new];
    op.delegate = self;
    [self.queue addOperation:op];
}

- (void)cancelOperation
{
    [self.queue cancelAllOperations];
}

#pragma mark - HTTPBinManagerOperationDelegate
- (void)operationNotice:(HTTPBinManagerOperation *)operation
{
    self.isCancelled = operation.isCancelled;
    self.progress = operation.progress;
    self.error = operation.error;
    //要不要把資料 存回來？
    [self.delegate operationManagerNotice:self];
}

@end
