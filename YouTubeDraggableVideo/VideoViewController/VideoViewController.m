//
//  VideoViewController.m
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/05/28.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoViewController.h"


@interface VideoViewController ()
@end



@implementation VideoViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *vView = [[UIView alloc] init];
    vView.backgroundColor = [UIColor redColor];

    [self setupWithVideoView: vView
            videoWrapperView: self.ibVideoWrapperView
             pageWrapperView: self.ibPageWrapperView
                  foldButton: self.ibFoldBtn];
}



@end