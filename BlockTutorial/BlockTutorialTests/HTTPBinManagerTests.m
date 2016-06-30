//
//  HTTPBinManagerTests.m
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/30.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSSetting.h"
#import <XCTest/XCTest.h>
#import "HTTPBinManager.h"
#import "HTTPBinManagerOperation.h"

@interface HTTPBinManager (ex)<HTTPBinManagerOperationDelegate>

- (NSOperationQueue *)queue;
//@property (nonatomic, strong) NSOperationQueue *queue;

@end

@interface HTTPBinManagerTests : XCTestCase<HTTPBinManagerDelegate>

@property(nonatomic, copy) void (^delegateBlock)(HTTPBinManager *binManager);

@end

@implementation HTTPBinManagerTests

//https://zonble.gitbooks.io/kkbox-ios-dev/content/threading/practice.html

- (void)testSingleton
{
    //寫一個叫做 HTTPBinManager 的 singleton 物件。
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDifferentThread"];
    
    dispatch_group_t group = dispatch_group_create();
    
    __block __unsafe_unretained id s1 = nil;
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        s1 = HTTPBinManager.sharedInstance;
        dispatch_group_leave(group);
    });
    
    int testTimes = 0;
    do {
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (s1 != nil) XCTAssertEqual(s1, HTTPBinManager.sharedInstance);
            dispatch_group_leave(group);
        });
        
        testTimes++;
    } while (testTimes < 100);
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:20000 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

//HTTPBinManager 要加入一個叫做 executeOperation 的 method，這個 method 首先會清除 operation queue 裡頭所有的 operation，然後加入新的 HTTPBinManagerOperation。
- (void)testExecuteOperation
{
    HTTPBinManager *manager = [HTTPBinManager sharedInstance];
    [manager executeOperation];
    XCTAssertEqual(manager.queue.operationCount, 1);
    [manager cancelOperation];
}

//HTTPBinManagerOperation 的 delegate 是 HTTPBinManager。 HTTPBinManager 也有自己的 delegate，在 HTTPBinManagerOperation 成功抓取資料、發生錯誤的時候，HTTPBinManager 也會將這些事情告訴自己的 delegate。
- (void)testManagerDelegateFail
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testManagerDelegateFail"];
    
    HTTPBinManager *manager = [HTTPBinManager sharedInstance];
    manager.delegate = self;
    
    HTTPBinManagerOperation *op = [[HTTPBinManagerOperation alloc] init];
    op.delegate = manager;
    
    weakSelfMake(weakSelf);
    [self setDelegateBlock:^(HTTPBinManager *binManager) {
        id self = weakSelf;
        
        if (binManager.isCancelled ||
            binManager.progress == 1) {
            
            XCTAssertTrue(binManager.isCancelled == (binManager.error != nil));
            NSLog(@"stop progress : %f",binManager.progress);
            [expectation fulfill];
            weakSelf.delegateBlock = nil;
        }
    }];
    
    [op main];
    if(!op.isCancelled) [op cancel];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

- (void)testManagerDelegateSuccess
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testManagerDelegateFail"];
    
    HTTPBinManager *manager = [HTTPBinManager sharedInstance];
    manager.delegate = self;
    
    HTTPBinManagerOperation *op = [[HTTPBinManagerOperation alloc] init];
    op.delegate = manager;
    
    weakSelfMake(weakSelf);
    [self setDelegateBlock:^(HTTPBinManager *binManager) {
        id self = weakSelf;
        
        if (binManager.isCancelled ||
            binManager.progress == 1) {
            
            XCTAssertTrue(binManager.isCancelled == (binManager.error != nil));
            NSLog(@"stop progress : %f",binManager.progress);
            [expectation fulfill];
            weakSelf.delegateBlock = nil;
        }
    }];
    
    [op main];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

#pragma mark - HTTPBinManagerDelegate
- (void)operationManagerNotice:(HTTPBinManager *)binManager
{
    if(self.delegateBlock) self.delegateBlock(binManager);
}

@end
