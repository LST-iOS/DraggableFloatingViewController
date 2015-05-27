//
//  VideoViewController.h
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/05/28.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

#ifndef YouTubeDraggableVideo_VideoViewController_h
#define YouTubeDraggableVideo_VideoViewController_
#endif

#import "BSVideoDetailController.h"

@interface VideoViewController : BSVideoDetailController

@property (weak, nonatomic) IBOutlet UIView *ibPageWrapperView;
@property (weak, nonatomic) IBOutlet UIView *ibVideoWrapperView;
@property (weak, nonatomic) IBOutlet UIButton *ibFoldBtn;

@end