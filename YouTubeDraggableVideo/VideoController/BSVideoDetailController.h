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
@end

typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
    UIPanGestureRecognizerDirectionUndefined,
    UIPanGestureRecognizerDirectionUp,
    UIPanGestureRecognizerDirectionDown,
    UIPanGestureRecognizerDirectionLeft,
    UIPanGestureRecognizerDirectionRight
};

@interface BSVideoDetailController : UIViewController<UIGestureRecognizerDelegate>//,UITextViewDelegate>



@property (weak, nonatomic) IBOutlet UIView *wrapperView;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
- (IBAction)btnDownTapAction:(id)sender;




@property (nonatomic, assign) id  <RemoveViewDelegate> delegate;
@property (strong, nonatomic) MPMoviePlayerController *player;





//@property (weak, nonatomic) IBOutlet UITableView *tblView;
//@property (weak, nonatomic) IBOutlet UIView *viewGrowingTextView;
//@property (weak, nonatomic) IBOutlet UITextView *txtViewGrowing;
//@property (weak, nonatomic) IBOutlet UIView *viewShare;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnDownBottomLayout;
//- (IBAction)btnSendAction:(id)sender;

-(void)showDonwButton;

@property(nonatomic)CGRect initialFirstViewFrame;
@property(nonatomic,strong) UIPanGestureRecognizer *panRecognizer;
@property(nonatomic,strong) UITapGestureRecognizer *tapRecognizer;
-(void)removeView;
@property(nonatomic,strong) UIView *onView;
@end
