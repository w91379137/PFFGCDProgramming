//
//  SingletonTest.m
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/29.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTTPBinManager.h"

@interface SingletonTest : XCTestCase
{
    BOOL finished;
    int testTimes;
}

@end

@implementation SingletonTest
//http://iosunittesting.com/testing-singletons/

#pragma mark - helper methods
- (id)createUniqueInstance {
    return [[HTTPBinManager alloc] init];
}

- (id)getSharedInstance {
    return [HTTPBinManager sharedInstance];
}

#pragma mark - tests
- (void)testSingletonSharedInstanceCreated {
    XCTAssertNotNil([self getSharedInstance]);
}

- (void)testSingletonUniqueInstanceCreated {
    XCTAssertNotNil([self createUniqueInstance]);
}

- (void)testSingletonReturnsSameSharedInstanceTwice {
    id s1 = [self getSharedInstance];
    XCTAssertEqual(s1, [self getSharedInstance]);
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    id s1 = [self getSharedInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    id s1 = [self createUniqueInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testTwoThread {
    XCTestExpectation *expectation = [self expectationWithDescription:@"threadTest"];
    
    dispatch_group_t totalGroup = dispatch_group_create();
    
    testTimes = 0;
    
    dispatch_group_enter(totalGroup);
    [self manyTest:^{
        dispatch_group_leave(totalGroup);
    }];
    
    dispatch_group_notify(totalGroup, dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:20000 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

- (void)manyTest:(dispatch_block_t)complete
{
    [self onceTest:^{
        if (testTimes < 100) {
            testTimes ++;
            NSLog(@"第 %d 次測試",testTimes);
            [self manyTest:complete];
        }
        else {
            NSLog(@"完成");
            complete();
        }
    }];
}

- (void)onceTest:(dispatch_block_t)complete
{
    dispatch_group_t group = dispatch_group_create();
    HTTPBinManager.sharedInstance = nil; //正常
    //_instance = nil; //並無法 正確設定成nil
    
    __block id s1 = nil;
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        s1 = HTTPBinManager.sharedInstance;
        dispatch_group_leave(group);
    });
    
    __block id s2 = nil;
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        s2 = HTTPBinManager.sharedInstance;
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        XCTAssertEqual(s1, s2);
        complete();
    });
}

@end
