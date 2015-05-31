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


@property (nonatomic, assign) id <DraggableFloatingViewControllerDelegate> delegate;


// please add subview on this
@property(nonatomic, strong) UIView *bodyArea;

// please call from "viewDidLoad" from sub class
- (void) setupViewsWithVideoView: (UIView *)vView
                 videoViewHeight: (CGFloat) videoHeight
                      foldButton: (UIButton *)ibFoldBtn;

- (void) onDealloc;// MUST OVERRIDE

// please call from parent view controller
- (void) showVideoViewControllerOnParentVC: (UIViewController<DraggableFloatingViewControllerDelegate>*) parentVC;
- (void) removeAllViews;

// please override if you want
- (void) onExpand;
- (void) onMinimized;
@end
