//
//  BlockTutorialTests.m
//  WebServiceTests
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebService.h"

@interface WebServiceTests : XCTestCase

@end

@implementation WebServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//之前的測試方法
//http://stackoverflow.com/questions/7817605/pattern-for-unit-testing-async-queue-that-calls-main-queue-on-completion

//異步的測試方法 英文
//https://www.bignerdranch.com/blog/asynchronous-testing-with-xcode-6/

//異步的測試方法 中文
//http://www.cocoachina.com/industry/20140805/9314.html

- (void)testGet
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testGet"];
    [WebService fetchGetResponseWithCallback:^(NSDictionary *dict, NSError *err) {
        XCTAssertNotNil(dict, "dict should not be nil");
        XCTAssertNil(err, "err should be nil");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

- (void)testPost
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testPost"];
    [WebService postCustomerName:@"test"
                        callback:^(NSDictionary *dict, NSError *err) {
                            XCTAssertNotNil(dict, "dict should not be nil");
                            XCTAssertNil(err, "err should be nil");
                            
                            [expectation fulfill];
                        }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

- (void)testImage
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testImage"];
    [WebService fetchImageWithCallback:^(UIImage *image, NSError *err) {
        XCTAssertNotNil(image, "image should not be nil");
        XCTAssertNil(err, "err should be nil");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
