//
//  RecipetUploadOperation.h
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HTTPBinManagerOperation;
@protocol HTTPBinManagerOperationDelegate <NSObject>

- (void)operationNotice:(HTTPBinManagerOperation *)operation;

@end

@interface HTTPBinManagerOperation : NSOperation

@property (nonatomic, weak) id<HTTPBinManagerOperationDelegate> delegate;

//Status
- (float)progress;
@property (nonatomic, strong) NSError *error;

//Data
@property (nonatomic, strong) NSDictionary *getDict;
@property (nonatomic, strong) NSDictionary *postDict;
@property (nonatomic, strong) UIImage *image;

@end
