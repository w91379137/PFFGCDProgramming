//
//  HTTPBinManagerTests.m
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/30.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTTPBinManager.h"

@interface HTTPBinManagerTests : XCTestCase

@end

@implementation HTTPBinManagerTests

- (void)testSingleton
{
    //https://zonble.gitbooks.io/kkbox-ios-dev/content/threading/practice.html
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

@end
