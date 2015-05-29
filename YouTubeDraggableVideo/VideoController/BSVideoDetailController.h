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
- (void)removeController;
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

@property(nonatomic,strong) UIView *bodyArea;// please add subview on this
- (BOOL) isFullScreen;// please override
- (void) goFullScreen;// please override
@property (nonatomic, assign) id  <RemoveViewDelegate> delegate;// please use
- (void) beforeAppearAnimation;// please call



- (void) setupWithVideoView: (UIView *)vView
           videoWrapperView: (UIView *)ibVideoWrapperView
            pageWrapperView: (UIView *)ibWrapperView
                 foldButton: (UIButton *)ibFoldBtn;
- (void) removeView;


@property(nonatomic)CGRect parentViewFrame;
@property(nonatomic,strong) UIPanGestureRecognizer *panRecognizer;
@property(nonatomic,strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic,strong) UIView *parentView;

@end
