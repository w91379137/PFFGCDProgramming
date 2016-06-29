//
//  HTTPBinManager.m
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "HTTPBinManager.h"
#import "HTTPBinManagerOperation.h"

#define testMode 1

@interface HTTPBinManager()
<HTTPBinManagerOperationDelegate>

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation HTTPBinManager

#pragma mark - Init
+ (instancetype)sharedInstance
{
    NSLog(@"%s instance: %@",__func__,_instance);
    
    if (!testMode) {
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    else {
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

+ (void)setSharedInstance:(HTTPBinManager *)instance
{
    onceToken = 0; // resets the once_token so dispatch_once will run again
    _instance = instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
        if(testMode) sleep(1);//delay for test
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
