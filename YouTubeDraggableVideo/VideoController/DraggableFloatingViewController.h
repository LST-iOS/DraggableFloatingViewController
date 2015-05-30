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
- (BOOL) isFullScreen;// please override
- (void) goFullScreen;// please override


- (void) hideVideoControl;// optional override
- (void) showVideoControl;// optional override


// please add subview on this
@property(nonatomic, strong) UIView *bodyArea;

// please call from "viewDidLoad" from sub class
- (void) setupViewsWithVideoView: (UIView *)vView
                 videoViewHeight: (CGFloat) videoHeight
                      foldButton: (UIButton *)ibFoldBtn;

// please call from parent view controller
- (void) showVideoViewControllerFromDelegateVC: (UIViewController<DraggableFloatingViewControllerDelegate>*) parentVC;
- (void) removeView;
@end
