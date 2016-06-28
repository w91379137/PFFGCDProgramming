//
//  WebService.h
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebService : NSObject

+ (void)fetchGetResponseWithCallback:(void(^)(NSDictionary *dict, NSError *err))callback;

+ (void)postCustomerName:(NSString *)name
                callback:(void(^)(NSDictionary *dict, NSError *err))callback;

+ (void)fetchImageWithCallback:(void(^)(UIImage *image, NSError *err))callback;

@end
