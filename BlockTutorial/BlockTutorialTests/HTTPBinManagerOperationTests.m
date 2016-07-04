//
//  HTTPBinManagerOperationTests.m
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/30.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "PDSSetting.h"
#import <XCTest/XCTest.h>
#import "HTTPBinManagerOperation.h"

@interface HTTPBinManagerOperationTests : XCTestCase<HTTPBinManagerOperationDelegate>

@property(nonatomic, copy) void (^delegateBlock)(HTTPBinManagerOperation *operation);

@end

@implementation HTTPBinManagerOperationTests

//https://zonble.gitbooks.io/kkbox-ios-dev/content/threading/practice.html
//寫一個叫做 HTTPBinManagerOperation 的 NSOperation subclass， HTTPBinManagerOperation 使用 delegate 向外部傳遞自己的狀態。

- (void)testFailAtStep1
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testFailAtStep1"];
    
    HTTPBinManagerOperation *op = [[HTTPBinManagerOperation alloc] init];
    op.delegate = self;
    weakSelfMake(weakSelf);
    
    [self setDelegateBlock:^(HTTPBinManagerOperation *operation) {
        id self = weakSelf;
        
        XCTAssertTrue([self isCorrectOperationProgress:operation]);
        
        if (operation.isCancelled ||
            operation.progress == 1) {
            
            XCTAssertTrue(operation.isCancelled);
            NSLog(@"stop progress : %f",operation.progress);
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

- (void)testFailAtStep2
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testFailAtStep2"];
    
    HTTPBinManagerOperation *op = [[HTTPBinManagerOperation alloc] init];
    op.delegate = self;
    weakSelfMake(weakSelf);
    
    [self setDelegateBlock:^(HTTPBinManagerOperation *operation) {
        id self = weakSelf;
        
        XCTAssertTrue([self isCorrectOperationProgress:operation]);
        
        if (operation.isCancelled ||
            operation.progress == 1) {
            
            XCTAssertTrue(operation.isCancelled);
            NSLog(@"stop progress : %f",operation.progress);
            [expectation fulfill];
            weakSelf.delegateBlock = nil;
        }
        
        if(!op.isCancelled && operation.progress > 0.3) [op cancel];
    }];
    
    [op main];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

- (void)testFailAtStep3
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testFailAtStep3"];
    
    HTTPBinManagerOperation *op = [[HTTPBinManagerOperation alloc] init];
    op.delegate = self;
    weakSelfMake(weakSelf);
    
    [self setDelegateBlock:^(HTTPBinManagerOperation *operation) {
        id self = weakSelf;
        
        XCTAssertTrue([self isCorrectOperationProgress:operation]);
        
        if (operation.isCancelled ||
            operation.progress == 1) {
            
            XCTAssertTrue(operation.isCancelled);
            NSLog(@"stop progress : %f",operation.progress);
            [expectation fulfill];
            weakSelf.delegateBlock = nil;
        }
        
        if(!op.isCancelled && operation.progress > 0.6) [op cancel];
    }];
    
    [op main];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

- (void)testPassAllStep
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testPassAllStep"];
    
    HTTPBinManagerOperation *op = [[HTTPBinManagerOperation alloc] init];
    op.delegate = self;
    weakSelfMake(weakSelf);
    
    [self setDelegateBlock:^(HTTPBinManagerOperation *operation) {
        id self = weakSelf;
        
        XCTAssertTrue([self isCorrectOperationProgress:operation]);
        
        if (operation.isCancelled ||
            operation.progress == 1) {
            
            XCTAssertNil(operation.error);
            NSLog(@"stop progress : %f",operation.progress);
            [expectation fulfill];
            weakSelf.delegateBlock = nil;
        }
    }];
    
    [op main];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

- (BOOL)isCorrectOperationProgress:(HTTPBinManagerOperation *)operation
{
    float progress = 0;
    if(operation.getDict) progress += 0.33;
    if(operation.postDict) progress += 0.33;
    if(operation.image) progress += 0.34;
    return operation.progress == progress;
}

#pragma mark - HTTPBinManagerOperationDelegate
- (void)operationNotice:(HTTPBinManagerOperation *)operation
{
    if (self.delegateBlock) self.delegateBlock(operation);
}

@end
