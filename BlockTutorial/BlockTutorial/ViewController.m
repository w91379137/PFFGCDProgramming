//
//  ViewController.m
//  BlockTutorial
//
//  Created by w91379137 on 2016/6/27.
//  Copyright © 2016年 w91379137. All rights reserved.
//

#import "ViewController.h"
#import "HTTPBinManager.h"

@interface ViewController ()
<HTTPBinManagerDelegate>
{
    IBOutlet UIImageView *imageView;
    IBOutlet UIProgressView *progressViewr;
    HTTPBinManager *manager;
}

@end

@implementation ViewController

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - IBAction
- (IBAction)startAction:(id)sender
{
    manager = [HTTPBinManager sharedInstance];
    manager.delegate = self;
    [manager executeOperation];
}

#pragma mark - HTTPBinManagerDelegate
- (void)operationManagerNotice:(HTTPBinManager *)binManager
{
    if (binManager.isCancelled) {
        NSLog(@"取消 取消前進度%f",binManager.progress);
    }
    else {
        NSLog(@"繼續進行 目前進度%f",binManager.progress);
    }
    
    imageView.image = binManager.image;
    progressViewr.progress = binManager.progress;
}

@end
