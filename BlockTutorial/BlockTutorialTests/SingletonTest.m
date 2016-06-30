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
    XCTestExpectation *expectation = [self expectationWithDescription:@"testTwoThread"];
    
    testTimes = 0;
    [self manyTimesTest:^{
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:20000 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

- (void)manyTimesTest:(dispatch_block_t)complete
{
    [self onceTimeTest:^{
        if (testTimes < 100) {
            testTimes ++;
            NSLog(@"第 %d 次測試",testTimes);
            [self manyTimesTest:complete];
        }
        else {
            NSLog(@"完成");
            complete();
        }
    }];
}

- (void)onceTimeTest:(dispatch_block_t)complete
{
    dispatch_group_t group = dispatch_group_create();
    
    [HTTPBinManager resetSharedInstance];
    
    __block __unsafe_unretained id s1 = nil;
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        s1 = HTTPBinManager.sharedInstance;
        dispatch_group_leave(group);
    });
    
    __block __unsafe_unretained id s2 = HTTPBinManager.sharedInstance;
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        XCTAssertEqual(s1, s2);
        complete();
    });
}

@end
