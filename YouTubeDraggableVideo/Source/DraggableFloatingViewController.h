//
//  BSVideoDetailController.h
//  YouTubeDraggableVideo
//
//  Created by Sandeep Mukherjee on 02/02/15.
//  Copyright (c) 2015 Sandeep Mukherjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>



@protocol DraggableFloatingViewControllerDelegate
@required
- (void)removeDraggableFloatingViewController;
@end





// please extend
@interface DraggableFloatingViewController : UIViewController<UIGestureRecognizerDelegate>

// please add subview on this
@property(nonatomic, strong) UIView *bodyView;
//please add controller on this
@property(nonatomic, strong) UIView *controllerView;

// please call from "viewDidLoad" from sub class
- (void) setupViewsWithVideoView: (UIView *)vView
                 videoViewHeight: (CGFloat) videoHeight
                      minimizeButton: (UIButton *)ibFoldBtn;

// please call from parent view controller
- (void) showVideoViewControllerOnParentVC: (UIViewController<DraggableFloatingViewControllerDelegate>*) parentVC;
- (void) removeAllViews;
@property (nonatomic, assign) id <DraggableFloatingViewControllerDelegate> delegate;

// please override if you want
- (void) didExpand;
- (void) didMinimize;

- (void) didStartMinimizeGesture;

// please call if you want
- (void) minimizeView;
- (void) expandView;

@end
