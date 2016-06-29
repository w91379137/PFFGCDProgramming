//
//  HTTPBinManager.h
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>

static id _instance;
static dispatch_once_t onceToken;

@class HTTPBinManager;
@protocol HTTPBinManagerDelegate <NSObject>

- (void)operationManagerNotice:(HTTPBinManager *)binManager;

@end

@interface HTTPBinManager : NSObject

+ (instancetype)sharedInstance;
+ (void)setSharedInstance:(HTTPBinManager *)instance;

@property(nonatomic, weak) id<HTTPBinManagerDelegate>delegate;

//Status
@property(nonatomic) float progress;
@property(nonatomic) BOOL isCancelled;
@property(nonatomic, strong) NSError *error;

//Action
- (void)executeOperation;
- (void)cancelOperation;

@end
