//
//  HTTPBinManager.h
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPBinManager;
@protocol HTTPBinManagerDelegate <NSObject>

- (void)operationManagerNotice:(HTTPBinManager *)binManager;

@end

@interface HTTPBinManager : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, weak) id<HTTPBinManagerDelegate>delegate;

//Status
@property(nonatomic) float progress;
@property(nonatomic) BOOL isCancelled;
@property(nonatomic, strong) NSError *error;

//Action
- (void)executeOperation;
- (void)cancelOperation;

@end
