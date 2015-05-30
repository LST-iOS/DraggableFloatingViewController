//
//  BSVideoDetailController.h
//  YouTubeDraggableVideo
//
//  Created by Sandeep Mukherjee on 02/02/15.
//  Copyright (c) 2015 Sandeep Mukherjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>



@protocol RemoveViewDelegate
@required
- (void)removeVideoViewController;
@optional
- (void)onExpanded;//MPMoviewControlStyleDeafult
- (void)onRemoveView;//stop the player
- (void)onDownGesture;//MPMoviewControlStyleNone
@end



typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
    UIPanGestureRecognizerDirectionUndefined,
    UIPanGestureRecognizerDirectionUp,
    UIPanGestureRecognizerDirectionDown,
    UIPanGestureRecognizerDirectionLeft,
    UIPanGestureRecognizerDirectionRight
};





// PLEASE EXTEND
@interface BSVideoDetailController : UIViewController<UIGestureRecognizerDelegate>


- (void) showVideoViewControllerFromDelegateVC: (UIViewController<RemoveViewDelegate>*) parentVC;


@property(nonatomic,strong) UIView *bodyArea;// please add subview on this
- (BOOL) isFullScreen;// please override
- (void) goFullScreen;// please override



- (void) setupViewsWithVideoView: (UIView *)vView
                 videoViewHeight: (CGFloat) videoHeight
                      foldButton: (UIButton *)ibFoldBtn;
- (void) removeView;


// TODO make them private variable
@property(nonatomic,strong) UIPanGestureRecognizer *panRecognizer;
@property(nonatomic,strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, assign) id  <RemoveViewDelegate> delegate;
@end
