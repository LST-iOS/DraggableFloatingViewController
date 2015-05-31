//
//  BSVideoDetailController.m
//  YouTubeDraggableVideo
//
//  Created by Sandeep Mukherjee on 02/02/15.
//  Copyright (c) 2015 Sandeep Mukherjee. All rights reserved.
//


#import "DraggableFloatingViewController.h"
#import "QuartzCore/CALayer.h"




typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
    UIPanGestureRecognizerDirectionUndefined,
    UIPanGestureRecognizerDirectionUp,
    UIPanGestureRecognizerDirectionDown,
    UIPanGestureRecognizerDirectionLeft,
    UIPanGestureRecognizerDirectionRight
};






@interface DraggableFloatingViewController ()
@end


@implementation DraggableFloatingViewController
{
    
    //local Frame storee
    CGRect videoWrapperFrame;
    CGRect minimizedVideoFrame;
    CGRect pageWrapperFrame;

    // animation Frame
    CGRect wFrame;
    CGRect vFrame;
    
    //local touch location
    CGFloat _touchPositionInHeaderY;
    CGFloat _touchPositionInHeaderX;
    
    //detecting Pan gesture Direction
    UIPanGestureRecognizerDirection direction;
    
    UITapGestureRecognizer *tapRecognizer;
    
    //Creating a transparent Black layer view
    UIView *transparentBlackSheet;
    
    //Just to Check wether view  is expanded or not
    BOOL isExpandedMode;
    
    
    UIView *pageWrapper;
    UIView *videoWrapper;
    UIButton *foldButton;

    UIView *videoView;
    // border of mini vieo view
    UIView *borderView;

    CGFloat maxH;
    CGFloat maxW;
    CGFloat videoHeightRatio;
    CGFloat finalViewOffsetY;
    CGFloat minimamVideoHeight;

    UIView *parentView;
}


const CGFloat finalMargin = 3.0;
const CGFloat minimamVideoWidth = 140;
const CGFloat flickVelocity = 1000;





// please override if you want
- (void) onExpand{}
- (void) onMinimized{}


//- (void)dealloc
//{
//    NSLog(@"dealloc DraggableFloatingViewController");
//}




- (id)init
{
    self = [super init];
    if (self) {
        self.bodyArea = [[UIView alloc] init];
    }
    return self;
}




# pragma mark - init

- (void) showVideoViewControllerOnParentVC: (UIViewController<DraggableFloatingViewControllerDelegate>*) parentVC {
    
    NSLog(@"showVideoViewControllerOnParentVC");
    
    if( ![parentVC conformsToProtocol:@protocol(DraggableFloatingViewControllerDelegate)] ) {
        NSAssert(NO, @"Parent view controller must confirm to protocol <DraggableFloatingViewControllerDelegate>.");
    }
    self.delegate = parentVC;

    
    // set portrait
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    parentView = parentVC.view;
    
    [parentView addSubview:self.view];// then, "viewDidLoad" called
    
    // wait to run "viewDidLoad" before "showThisView"
    [self performSelector:@selector(showThisView) withObject:nil afterDelay:0.0];
}
// ↓
// VIEW DID LOAD
- (void) setupViewsWithVideoView: (UIView *)vView
            videoViewHeight: (CGFloat) videoHeight
                 foldButton: (UIButton *)foldBtn
{
    NSLog(@"setupViewsWithVideoView");

    videoView = vView;
    foldButton = foldBtn;
    
    CGRect window = [[UIScreen mainScreen] bounds];
    maxH = window.size.height;
    maxW = window.size.width;
    CGFloat videoWidth = maxW;
    videoHeightRatio = videoHeight / videoWidth;
    minimamVideoHeight = minimamVideoWidth * videoHeightRatio;
    finalViewOffsetY = maxH - minimamVideoHeight - finalMargin;

    
    videoWrapper = [[UIView alloc] init];
    videoWrapper.frame = CGRectMake(0, 0, videoWidth, videoHeight);
    
    videoView.frame = videoWrapper.frame;

    pageWrapper = [[UIView alloc] init];
    pageWrapper.frame = CGRectMake(0, 0, maxW, maxH);
    
    videoWrapperFrame = videoWrapper.frame;
    pageWrapperFrame = pageWrapper.frame;
    
    
    borderView = [[UIView alloc] init];
    borderView.clipsToBounds = YES;
    borderView.layer.masksToBounds = NO;
    borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    borderView.layer.borderWidth = 0.5f;
    borderView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    borderView.layer.shadowColor = [UIColor blackColor].CGColor;
    borderView.layer.shadowRadius = 1.0;
    borderView.layer.shadowOpacity = 1.0;
    borderView.alpha = 0;
    borderView.frame = CGRectMake(videoView.frame.origin.y - 1,
                                  videoView.frame.origin.x - 1,
                                  videoView.frame.size.width + 1,
                                  videoView.frame.size.height + 1);

    self.bodyArea.frame = CGRectMake(0, videoHeight, maxW, maxH - videoHeight);
    //dev
    self.bodyArea.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:1.0f];
    self.bodyArea.layer.borderColor = [[[UIColor orangeColor] colorWithAlphaComponent:1.0f] CGColor];
    self.bodyArea.layer.borderWidth = 8.0f;
}
// ↓
- (void) showThisView {
    // only first time, SubViews add to "self.view".
    // After animation, they move to "parentView"
    videoView.backgroundColor = [UIColor blackColor];
    [pageWrapper addSubview:self.bodyArea];
    [videoWrapper addSubview:videoView];
    [self.view addSubview:pageWrapper];
    [self.view addSubview:videoWrapper];
    
    self.view.frame = CGRectMake(parentView.frame.size.width - 50,
                                 parentView.frame.size.height - 50,
                                 parentView.frame.size.width,
                                 parentView.frame.size.height);
    self.view.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.view.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^ {
        self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.view.alpha = 1;
        self.view.frame = CGRectMake(parentView.frame.origin.x,   parentView.frame.origin.y,
                                     parentView.frame.size.width, parentView.frame.size.height);
    }];
    
    // move subviews from "self.view" to "parentView"
    [self performSelector:@selector(afterAppearAnimation) withObject:nil afterDelay:0.25];

    transparentBlackSheet = [[UIView alloc] initWithFrame:parentView.frame];
    transparentBlackSheet.backgroundColor = [UIColor blackColor];
    transparentBlackSheet.alpha = 0.9;
}
// ↓
-(void) afterAppearAnimation {
    videoView.backgroundColor = videoWrapper.backgroundColor = [UIColor clearColor];
    [parentView addSubview:transparentBlackSheet];
    
    [parentView addSubview:pageWrapper];
    [parentView addSubview:videoWrapper];

    self.view.hidden = TRUE;

    [videoView addSubview:borderView];
    [videoView addSubview:foldButton];

    vFrame = videoWrapperFrame;
    wFrame = pageWrapperFrame;
    
    // adding Pan Gesture
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [videoWrapper addGestureRecognizer:pan];
    
    [foldButton addTarget:self action:@selector(onTapDownButton) forControlEvents:UIControlEventTouchUpInside];

    isExpandedMode = TRUE;
}






-(void)removeAllViews
{
    [videoWrapper removeFromSuperview];
    [pageWrapper removeFromSuperview];
    [transparentBlackSheet removeFromSuperview];
    [self.view removeFromSuperview];
}

















# pragma  mark - tap action
- (void) onTapDownButton {
    [self minimizeViewOnPan];
    NSLog(@"onTapButons");
}


- (void)expandViewOnTap:(UITapGestureRecognizer*)sender {
    NSLog(@"expandViewOnTap");
    [self expandViewOnPan];
    for (UIGestureRecognizer *recognizer in videoWrapper.gestureRecognizers) {
        
        if([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [videoWrapper removeGestureRecognizer:recognizer];
        }
    }
}



#pragma mark- Pan Gesture Selector Action

-(void)panAction:(UIPanGestureRecognizer *)recognizer
{
    CGFloat touchPosInViewY = [recognizer locationInView:self.view].y;
    
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        direction = UIPanGestureRecognizerDirectionUndefined;
        //storing direction
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        [self detectPanDirection:velocity];
        
        //Snag the Y position of the touch when panning begins
        _touchPositionInHeaderY = [recognizer locationInView:videoWrapper].y;
        _touchPositionInHeaderX = [recognizer locationInView:videoWrapper].x;
        if(direction==UIPanGestureRecognizerDirectionDown) {
            // player.controlStyle = MPMovieControlStyleNone;
//            [self hideVideoControl];
        }
    }

    
    else if(recognizer.state == UIGestureRecognizerStateChanged) {
        if(direction == UIPanGestureRecognizerDirectionDown || direction == UIPanGestureRecognizerDirectionUp) {

            CGFloat appendY;
            if (direction == UIPanGestureRecognizerDirectionDown) appendY = 80;
            else appendY = -80;
            
            CGFloat newOffsetY = touchPosInViewY - _touchPositionInHeaderY + appendY;

            // CGFloat newOffsetX = newOffsetY * 0.35;
            [self adjustViewOnVerticalPan:newOffsetY recognizer:recognizer];
        }
        else if (direction==UIPanGestureRecognizerDirectionRight || direction==UIPanGestureRecognizerDirectionLeft) {
            [self adjustViewOnHorizontalPan:recognizer];
        }
    }


    
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        
        if(direction == UIPanGestureRecognizerDirectionDown || direction == UIPanGestureRecognizerDirectionUp)
        {
            
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            
            if(velocity.y < -flickVelocity)
            {
                NSLog(@"flick up");
                [self expandViewOnPan];
                [recognizer setTranslation:CGPointZero inView:recognizer.view];
                return;
            }
            else if(velocity.y > flickVelocity)
            {
                NSLog(@"flick down");
                [self minimizeViewOnPan];
                [recognizer setTranslation:CGPointZero inView:recognizer.view];
                return;
            }
            else if(recognizer.view.frame.origin.y < 0)
            {
                [self expandViewOnPan];
                [recognizer setTranslation:CGPointZero inView:recognizer.view];
                return;
            }
            else if(recognizer.view.frame.origin.y>(parentView.frame.size.width/2))
            {
                [self minimizeViewOnPan];
                [recognizer setTranslation:CGPointZero inView:recognizer.view];
                return;
            }
            else if(recognizer.view.frame.origin.y < (parentView.frame.size.width/2))
            {
                [self expandViewOnPan];
                [recognizer setTranslation:CGPointZero inView:recognizer.view];
                return;
            }
        }
        
        else if (direction==UIPanGestureRecognizerDirectionLeft)
        {
            if(pageWrapper.alpha<=0)
            {
                
                if(recognizer.view.frame.origin.x<0)
                {
                    [self.view removeFromSuperview];
                    [self removeAllViews];
                    [self.delegate removeDraggableFloatingViewController];
                    
                }
                else
                {
                    [self animateViewToRight:recognizer];
                    
                }
            }
        }
        
        else if (direction==UIPanGestureRecognizerDirectionRight)
        {
            if(pageWrapper.alpha<=0)
            {
                if(recognizer.view.frame.origin.x>parentView.frame.size.width-50)
                {
                    [self.view removeFromSuperview];
                    [self removeAllViews];
                    [self.delegate removeDraggableFloatingViewController];
                    
                }
                else
                {
                    [self animateViewToLeft:recognizer];
                    
                }
            }
        }
    }
}


-(void)detectPanDirection:(CGPoint )velocity
{
    foldButton.hidden=TRUE;
    BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
    
    if (isVerticalGesture)
    {
        if (velocity.y > 0) {
            direction = UIPanGestureRecognizerDirectionDown;
            
        } else {
            direction = UIPanGestureRecognizerDirectionUp;
        }
    }
    else
    {
        if(velocity.x > 0)
        {
            direction = UIPanGestureRecognizerDirectionRight;
        }
        else
        {
            direction = UIPanGestureRecognizerDirectionLeft;
        }
    }
}



-(void)adjustViewOnVerticalPan:(CGFloat)newOffsetY recognizer:(UIPanGestureRecognizer *)recognizer
{
    CGFloat touchPosInViewY = [recognizer locationInView:self.view].y;

    CGFloat progressRate = newOffsetY / finalViewOffsetY;
    
    if(progressRate >= 0.99) {
        progressRate = 1;
        newOffsetY = finalViewOffsetY;
    }
    
    [self calcNewFrameWithParsentage:progressRate newOffsetY:newOffsetY];

//    if (pageWrapper.frame.origin.y < finalViewOffsetY && pageWrapper.frame.origin.y > 0) {
    if (progressRate <= 1 && pageWrapper.frame.origin.y > 0) {
        [UIView animateWithDuration:0.03
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             pageWrapper.frame = wFrame;
                             videoWrapper.frame = vFrame;
                             videoView.frame = CGRectMake(
                                                          videoView.frame.origin.x,  videoView.frame.origin.x,
                                                          vFrame.size.width, vFrame.size.height
                                                          );
                             self.bodyArea.frame = CGRectMake(
                                                         0,
                                                         videoView.frame.size.height,// keep stay on bottom of videoView
                                                         self.bodyArea.frame.size.width,
                                                         self.bodyArea.frame.size.height
                                                         );
                             
                             borderView.frame = CGRectMake(videoView.frame.origin.y - 1,
                                                           videoView.frame.origin.x - 1,
                                                           videoView.frame.size.width + 1,
                                                           videoView.frame.size.height + 1);
                             
                             
                             CGFloat percentage = touchPosInViewY / parentView.frame.size.height;
                             pageWrapper.alpha = transparentBlackSheet.alpha = 1.0 - (percentage * 1.5);
                             if (percentage > 0.2) borderView.alpha = percentage;
                             else borderView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             if(direction==UIPanGestureRecognizerDirectionDown)
                             {
                                 [parentView bringSubviewToFront:self.view];
                             }
                         }];
    }
    // what is this case...?
    else if (wFrame.origin.y < finalViewOffsetY && wFrame.origin.y > 0)
    {
        [UIView animateWithDuration:0.09
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             pageWrapper.frame = wFrame;
                             videoWrapper.frame = vFrame;
                             videoView.frame=CGRectMake( videoView.frame.origin.x,  videoView.frame.origin.x, vFrame.size.width, vFrame.size.height);
                             
                             self.bodyArea.frame = CGRectMake(
                                                         0,
                                                         videoView.frame.size.height,// keep stay on bottom of videoView
                                                         self.bodyArea.frame.size.width,
                                                         self.bodyArea.frame.size.height
                                                         );
                             borderView.frame = CGRectMake(videoView.frame.origin.y - 1,
                                                           videoView.frame.origin.x - 1,
                                                           videoView.frame.size.width + 1,
                                                           videoView.frame.size.height + 1);
                             
                             borderView.alpha = progressRate;
                         }completion:nil];
    }

    
    [recognizer setTranslation:CGPointZero inView:recognizer.view];

    //    }
}




-(void)adjustViewOnHorizontalPan:(UIPanGestureRecognizer *)recognizer {
    //    [self.txtViewGrowing resignFirstResponder];
    if(pageWrapper.alpha<=0) {
        
        CGFloat x = [recognizer locationInView:self.view].x;
        
        if (direction==UIPanGestureRecognizerDirectionLeft)
        {
//            NSLog(@"recognizer x=%f",recognizer.view.frame.origin.x);
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            
            BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
            
            
            CGPoint translation = [recognizer translationInView:recognizer.view];
            
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                                 recognizer.view.center.y );
            
            
            if (!isVerticalGesture) {
                
                CGFloat percentage = (x/parentView.frame.size.width);
                
                recognizer.view.alpha = percentage;
                
            }
            
            [recognizer setTranslation:CGPointZero inView:recognizer.view];
        }
        else if (direction==UIPanGestureRecognizerDirectionRight)
        {
//            NSLog(@"recognizer x=%f",recognizer.view.frame.origin.x);
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            
            BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
            
            CGPoint translation = [recognizer translationInView:recognizer.view];
            
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                                 recognizer.view.center.y );
            
            if (!isVerticalGesture) {
                
                if(velocity.x > 0)
                {
                    
                    CGFloat percentage = (x/parentView.frame.size.width);
                    recognizer.view.alpha =1.0- percentage;                }
                else
                {
                    CGFloat percentage = (x/parentView.frame.size.width);
                    recognizer.view.alpha =percentage;
                    
                    
                }
                
            }
            
            [recognizer setTranslation:CGPointZero inView:recognizer.view];
        }
    }
}


- (void) calcNewFrameWithParsentage:(CGFloat) persentage newOffsetY:(CGFloat) newOffsetY{
    CGFloat newWidth = minimamVideoWidth + ((maxW - minimamVideoWidth) * (1 - persentage));
    CGFloat newHeight = newWidth * videoHeightRatio;
    
    CGFloat newOffsetX = maxW - newWidth - (finalMargin * persentage);
    
    vFrame.size.width = newWidth;//self.view.bounds.size.width - xOffset;
    vFrame.size.height = newHeight;//(200 - xOffset * 0.5);
    
    vFrame.origin.y = newOffsetY;//trueOffset - finalMargin * 2;
    wFrame.origin.y = newOffsetY;
    
    vFrame.origin.x = newOffsetX;//maxW - vFrame.size.width - finalMargin;
    wFrame.origin.x = newOffsetX;
    //    vFrame.origin.y = realNewOffsetY;//trueOffset - finalMargin * 2;
    //    wFrame.origin.y = realNewOffsetY;
    
}

-(void) setFinalFrame {
    vFrame.size.width = minimamVideoWidth;//self.view.bounds.size.width - xOffset;
    // ↓
    vFrame.size.height = vFrame.size.width * videoHeightRatio;//(200 - xOffset * 0.5);
    vFrame.origin.y = maxH - vFrame.size.height - finalMargin;//trueOffset - finalMargin * 2;
    vFrame.origin.x = maxW - vFrame.size.width - finalMargin;
    wFrame.origin.y = vFrame.origin.y;
    wFrame.origin.x = vFrame.origin.x;
}









# pragma mark - animations

-(void)expandViewOnPan
{
    NSLog(@"expandViewOnPan");
    //        [self.txtViewGrowing resignFirstResponder];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         pageWrapper.frame = pageWrapperFrame;
                         videoWrapper.frame = videoWrapperFrame;
                         videoWrapper.alpha = 1;
                         videoView.frame = videoWrapperFrame;
                         pageWrapper.alpha = 1.0;
                         transparentBlackSheet.alpha = 1.0;
                         borderView.alpha = 0.0;

                         self.bodyArea.frame = CGRectMake(
                                                     0,
                                                     videoView.frame.size.height,// keep stay on bottom of videoView
                                                     self.bodyArea.frame.size.width,
                                                     self.bodyArea.frame.size.height
                                                     );

                         borderView.frame = CGRectMake(videoView.frame.origin.y - 1,
                                                       videoView.frame.origin.x - 1,
                                                       videoView.frame.size.width + 1,
                                                       videoView.frame.size.height + 1);
                         

                     }
                     completion:^(BOOL finished) {
                         //                         player.controlStyle = MPMovieControlStyleDefault;
//                         [self showVideoControl];
                         [self onExpand];
                         isExpandedMode = TRUE;
                         foldButton.hidden = FALSE;
                     }];
}



-(void)minimizeViewOnPan
{
    foldButton.hidden = TRUE;
    
    [self setFinalFrame];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         pageWrapper.frame = wFrame;
                         videoWrapper.frame = vFrame;
                         videoView.frame=CGRectMake( videoView.frame.origin.x,  videoView.frame.origin.x, vFrame.size.width, vFrame.size.height);
                         pageWrapper.alpha=0;
                         transparentBlackSheet.alpha=0.0;
                         borderView.alpha = 1.0;

                         borderView.frame = CGRectMake(videoView.frame.origin.y - 1,
                                                       videoView.frame.origin.x - 1,
                                                       videoView.frame.size.width + 1,
                                                       videoView.frame.size.height + 1);

                     }
                     completion:^(BOOL finished) {
//                         [self hideVideoControl];
                         [self onMinimized];
                         //add tap gesture
                         tapRecognizer=nil;
                         if(tapRecognizer==nil)
                         {
                             tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandViewOnTap:)];
                             tapRecognizer.numberOfTapsRequired = 1;
                             tapRecognizer.delegate = self;
//                             tapRecognizer.minimumPressDuration = 0.1;
                             [videoWrapper addGestureRecognizer:tapRecognizer];
                         }
                         
                         isExpandedMode=FALSE;
                         minimizedVideoFrame=videoWrapper.frame;
                         
                         if(direction==UIPanGestureRecognizerDirectionDown)
                         {
                             [parentView bringSubviewToFront:self.view];
                         }
                     }];
}


-(void)animateViewToRight:(UIPanGestureRecognizer *)recognizer{
//    [self.txtViewGrowing resignFirstResponder];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         pageWrapper.frame = wFrame;
                         videoWrapper.frame=vFrame;
                         videoView.frame=CGRectMake( videoView.frame.origin.x,  videoView.frame.origin.x, vFrame.size.width, vFrame.size.height);
                         pageWrapper.alpha=0;
                         videoWrapper.alpha=1;
                         borderView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
}

-(void)animateViewToLeft:(UIPanGestureRecognizer *)recognizer{
//    [self.txtViewGrowing resignFirstResponder];
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         pageWrapper.frame = wFrame;
                         videoWrapper.frame=vFrame;
                         videoView.frame=CGRectMake( videoView.frame.origin.x,  videoView.frame.origin.x, vFrame.size.width, vFrame.size.height);
                         pageWrapper.alpha=0;
                         videoWrapper.alpha=1;
                         borderView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}


#pragma mark- Pan Gesture Delagate

- (BOOL)gestureRecognizerShould:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.view.frame.origin.y < 0)
    {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



#pragma mark- Status Bar Hidden function

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
