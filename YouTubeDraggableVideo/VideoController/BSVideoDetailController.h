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
- (void)removeController;
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






@interface BSVideoDetailController : UIViewController<UIGestureRecognizerDelegate>//,UITextViewDelegate>

- (BOOL) isFullScreen;// please override
- (void) goFullScreen;// please override



@property (nonatomic, assign) id  <RemoveViewDelegate> delegate;

- (void) beforeApperAnimation;

- (void) setupWithVideoView: (UIView *)vView
           videoWrapperView: (UIView *)ibVideoWrapperView
            pageWrapperView: (UIView *)ibWrapperView
                 foldButton: (UIButton *)ibFoldBtn;
- (void) removeView;


@property(nonatomic)CGRect parentViewFrame;
@property(nonatomic,strong) UIPanGestureRecognizer *panRecognizer;
@property(nonatomic,strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic,strong) UIView *onView;

//@property (strong, nonatomic) MPMoviePlayerController *player;
//@property (weak, nonatomic) IBOutlet UITableView *tblView;
//@property (weak, nonatomic) IBOutlet UIView *viewGrowingTextView;
//@property (weak, nonatomic) IBOutlet UITextView *txtViewGrowing;
//@property (weak, nonatomic) IBOutlet UIView *viewShare;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnDownBottomLayout;
//- (IBAction)btnDownTapAction:(id)sender;
//- (IBAction)btnSendAction:(id)sender;
@end
