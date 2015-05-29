//
//  BSVideoDetailController.m
//  YouTubeDraggableVideo
//
//  Created by Sandeep Mukherjee on 02/02/15.
//  Copyright (c) 2015 Sandeep Mukherjee. All rights reserved.
//


#import "BSVideoDetailController.h"
#import "QuartzCore/CALayer.h"


@interface BSVideoDetailController ()
@end



@implementation BSVideoDetailController
{
    //local Frame store
    CGRect videoWrapperFrame;
    CGRect minimizedVideoFrame;
    CGRect pageWrapperFrame;

    CGRect wFrame;
    CGRect vFrame;
    
    //local touch location
    CGFloat _touchPositionInHeaderY;
    CGFloat _touchPositionInHeaderX;
    
    //local restriction Offset--- for checking out of bound
    float minimizedOffsetX,minimizedOffsetY;//,restictYaxis;
    
    //detecting Pan gesture Direction
    UIPanGestureRecognizerDirection direction;
    
    
    //Creating a transparent Black layer view
    UIView *transparentBlackSheet;
    
    //Just to Check wether view  is expanded or not
    BOOL isExpandedMode;
    
    
    
    UIView *pageWrapper;
    UIView *videoWrapper;
    UIButton *foldButton;

    UIView *videoView;
    
    UIView *bodyArea;
    
    UIView *borderView;

    CGFloat maxH;
    CGFloat maxW;
    CGFloat videoHeightRatio;
    CGFloat finalViewOffsetY;
    CGFloat minimamVideoHeight;

}

//@synthesize player;

const CGFloat finalMargin = 3.0;
const CGFloat minimamVideoWidth = 140;
const CGFloat flickVelocity = 1000;



//PLEASE OVERRIDE
//- (void)viewDidLoad {
//    [super viewDidLoad];

//    UIView *vView = [[UIView alloc] init];
//    vView.backgroundColor = [UIColor redColor];
//    
//    [self setupWithVideoView: vView
//            videoWrapperView: self.ibVideoWrapperView
//             pageWrapperView: self.ibWrapperView
//                  foldButton: self.ibFoldBtn];
//}


//PLEASE OVERRIDE
- (BOOL) isFullScreen {
    NSLog(@"isFullScreen");
    NSAssert(NO, @"This is an abstract method and should be overridden!!!!!!!!!");
    return false;
}

//PLEASE OVERRIDE
- (void) goFullScreen {
    NSLog(@"goFullScreen");
    NSAssert(NO, @"This is an abstract method and should be overridden!!!!!!!!!!!");
    //                    self.secondViewController.player.controlStyle =  MPMovieControlStyleDefault;
    //                    self.secondViewController.player.fullscreen = YES;
    //                      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
}
//    - (void)willExitFullscreen:(NSNotification*)notification {
//    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
//    }





- (void) setupWithVideoView: (UIView *)vView
           videoWrapperView: (UIView *)ibVideoWrapperView
            pageWrapperView: (UIView *)ibWrapperView
                 foldButton: (UIButton *)ibFoldBtn
{
    videoView = vView;
    videoWrapper = ibVideoWrapperView;
    pageWrapper = ibWrapperView;
    foldButton = ibFoldBtn;
    
    // [[BSUtils sharedInstance] showLoadingMode:self];

    //adding Pan Gesture
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    pan.delegate=self;
    [videoWrapper addGestureRecognizer:pan];

    //setting view to Expanded state
    isExpandedMode=TRUE;
    
    foldButton.hidden=TRUE;
    [foldButton addTarget:self action:@selector(onTapDownButton) forControlEvents:UIControlEventTouchUpInside];
    
    // orientation behaver
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    //adding demo Video -- giving a little delay to store correct frame size
    [self performSelector:@selector(afterAppearAnimation) withObject:nil afterDelay:0.25];
    
    
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
}

- (void) beforeAppearAnimation {
    maxH = self.parentViewFrame.size.height;
    maxW = self.parentViewFrame.size.width;
    CGFloat videoHeight = videoWrapper.frame.size.height;
    CGFloat videoWidth = videoWrapper.frame.size.width;
    videoHeightRatio = videoHeight / videoWidth;
    finalViewOffsetY = maxH - (minimamVideoWidth * videoHeightRatio) - finalMargin;
    minimamVideoHeight = minimamVideoWidth * videoHeightRatio;
    
    bodyArea = [[UIView alloc] init];
    bodyArea.frame = CGRectMake(0, videoHeight, maxW, maxH - videoHeight);
    [pageWrapper addSubview:bodyArea];

    bodyArea.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.1f];
    bodyArea.layer.borderColor = [[[UIColor cyanColor] colorWithAlphaComponent:0.2f] CGColor];
    bodyArea.layer.borderWidth = 1.0f;
    
}



#pragma mark- Calculate Frames and Store Frame Size

-(void) afterAppearAnimation {
    [videoView setFrame:videoWrapper.frame];
    [videoWrapper addSubview:videoView];
    
    videoWrapperFrame = videoWrapper.frame;
    pageWrapperFrame = pageWrapper.frame;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    [UIApplication sharedApplication].statusBarHidden = YES;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // disable AutoLayout
    videoWrapper.translatesAutoresizingMaskIntoConstraints = YES;
    pageWrapper.translatesAutoresizingMaskIntoConstraints = YES;
    
    videoWrapper.frame = videoWrapperFrame;
    pageWrapper.frame = pageWrapperFrame;
    
    wFrame = pageWrapper.frame;
    vFrame = videoWrapper.frame;
    
    minimizedOffsetX = self.parentViewFrame.size.width - 200;
    minimizedOffsetY = self.parentViewFrame.size.height - 180;
    
    
    //self.videoView.layer.shouldRasterize=YES;
    //self.viewYouTube.layer.shouldRasterize=YES;
    //self.viewTable.layer.shouldRasterize=YES;
    
    
    videoView.backgroundColor = videoWrapper.backgroundColor = [UIColor clearColor];

    //[[BSUtils sharedInstance] hideLoadingMode:self];
    self.view.hidden = TRUE;
    
    
    
    transparentBlackSheet = [[UIView alloc] initWithFrame:self.parentViewFrame];
    transparentBlackSheet.backgroundColor = [UIColor blackColor];
    transparentBlackSheet.alpha = 0.9;
    
    

    borderView.frame = CGRectMake(videoView.frame.origin.y - 1,
                                  videoView.frame.origin.x - 1,
                                  videoView.frame.size.width + 1,
                                  videoView.frame.size.height + 1);
    [videoView addSubview:borderView];
    
    
    [self.onView addSubview:transparentBlackSheet];
    [self.onView addSubview:pageWrapper];
    [self.onView addSubview:videoWrapper];
    
    
    [videoView addSubview:foldButton];
    [NSTimer scheduledTimerWithTimeInterval:0.4f
                                     target:self
                                   selector:@selector(showFoldButton)
                                   userInfo:nil
                                    repeats:NO];
    
    
    
    
    
}






#pragma mark - Button Action

- (void) onTapDownButton {
    [self minimizeViewOnPan];
    NSLog(@"onTapButons");
}

//- (IBAction)btnDownTapAction:(id)sender {
//    NSLog(@"btnDownTapAction");
//    [self minimizeViewOnPan];
//}



#pragma mark - Orientation

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}



- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    NSLog(@"adjust for orientation:%ld", (long)orientation);
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            NSLog(@"portrait called;");
            //load the portrait view
                // FIX: rewrite after
            if([self isFullScreen])
            {
                if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
                {
                    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
                }
            }
            
        }
        break;

        //　横だったら、フルスクリーンにする
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            NSLog(@"landscape called;");
            
//            if(self.secondViewController!=nil)
//            {
            
            
                 if(![self isFullScreen])// && wrapperView.alpha >= 1)
                {
                
                    // FIX: rewrite after
                    [self goFullScreen];
                }
                /* else if( self.secondViewController.viewTable.alpha<=0)
                 {
                 if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
                 [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
                 } */
//            }
        }
        break;
        
        case UIInterfaceOrientationUnknown:break;
    }
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





- (void) showFoldButton {
    NSLog(@"show downButton");
//    [videoWrapperView bringSubviewToFront:foldButton];
    foldButton.hidden = FALSE;
}













#pragma mark- Pan Animation

- (void)expandViewOnTap:(UITapGestureRecognizer*)sender {
    NSLog(@"expandViewOnTap");
    [self expandViewOnPan];
    for (UIGestureRecognizer *recognizer in videoWrapper.gestureRecognizers) {
        
        if([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [videoWrapper removeGestureRecognizer:recognizer];
        }
    }
}



-(void)removeView
{
    [self.delegate onRemoveView];
//    [self.player stop];
    [videoWrapper removeFromSuperview];
    [pageWrapper removeFromSuperview];
    [transparentBlackSheet removeFromSuperview];
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
            [self.delegate onDownGesture];
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
            else if(recognizer.view.frame.origin.y>(self.parentViewFrame.size.width/2))
            {
                [self minimizeViewOnPan];
                [recognizer setTranslation:CGPointZero inView:recognizer.view];
                return;
            }
            else if(recognizer.view.frame.origin.y < (self.parentViewFrame.size.width/2))
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
                    [self removeView];
                    [self.delegate removeController];
                    
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
                if(recognizer.view.frame.origin.x>self.parentViewFrame.size.width-50)
                {
                    [self.view removeFromSuperview];
                    [self removeView];
                    [self.delegate removeController];
                    
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
    
    if(progressRate >= 0.97) {
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
                             bodyArea.frame = CGRectMake(
                                                         0,
                                                         videoView.frame.size.height,// keep stay on bottom of videoView
                                                         bodyArea.frame.size.width,
                                                         bodyArea.frame.size.height
                                                         );
                             
                             borderView.frame = CGRectMake(videoView.frame.origin.y - 1,
                                                           videoView.frame.origin.x - 1,
                                                           videoView.frame.size.width + 1,
                                                           videoView.frame.size.height + 1);
                             
                             
                             CGFloat percentage = touchPosInViewY / self.parentViewFrame.size.height;
                             pageWrapper.alpha = transparentBlackSheet.alpha = 1.0 - (percentage * 1.5);
                             if (percentage > 0.2) borderView.alpha = percentage;
                             else borderView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             if(direction==UIPanGestureRecognizerDirectionDown)
                             {
                                 [self.onView bringSubviewToFront:self.view];
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
                             
                             bodyArea.frame = CGRectMake(
                                                         0,
                                                         videoView.frame.size.height,// keep stay on bottom of videoView
                                                         bodyArea.frame.size.width,
                                                         bodyArea.frame.size.height
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


-(void)adjustViewOnHorizontalPan:(UIPanGestureRecognizer *)recognizer {
    //    [self.txtViewGrowing resignFirstResponder];
    if(pageWrapper.alpha<=0) {
        
        CGFloat x = [recognizer locationInView:self.view].x;
        
        if (direction==UIPanGestureRecognizerDirectionLeft)
        {
            NSLog(@"recognizer x=%f",recognizer.view.frame.origin.x);
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            
            BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
            
            
            CGPoint translation = [recognizer translationInView:recognizer.view];
            
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                                 recognizer.view.center.y );
            
            
            if (!isVerticalGesture) {
                
                CGFloat percentage = (x/self.parentViewFrame.size.width);
                
                recognizer.view.alpha = percentage;
                
            }
            
            [recognizer setTranslation:CGPointZero inView:recognizer.view];
        }
        else if (direction==UIPanGestureRecognizerDirectionRight)
        {
            NSLog(@"recognizer x=%f",recognizer.view.frame.origin.x);
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            
            BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
            
            CGPoint translation = [recognizer translationInView:recognizer.view];
            
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                                 recognizer.view.center.y );
            
            if (!isVerticalGesture) {
                
                if(velocity.x > 0)
                {
                    
                    CGFloat percentage = (x/self.parentViewFrame.size.width);
                    recognizer.view.alpha =1.0- percentage;                }
                else
                {
                    CGFloat percentage = (x/self.parentViewFrame.size.width);
                    recognizer.view.alpha =percentage;
                    
                    
                }
                
            }
            
            [recognizer setTranslation:CGPointZero inView:recognizer.view];
        }
    }
}





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

                         bodyArea.frame = CGRectMake(
                                                     0,
                                                     videoView.frame.size.height,// keep stay on bottom of videoView
                                                     bodyArea.frame.size.width,
                                                     bodyArea.frame.size.height
                                                     );

                         borderView.frame = CGRectMake(videoView.frame.origin.y - 1,
                                                       videoView.frame.origin.x - 1,
                                                       videoView.frame.size.width + 1,
                                                       videoView.frame.size.height + 1);
                         

                     }
                     completion:^(BOOL finished) {
                         //                         player.controlStyle = MPMovieControlStyleDefault;
                         [self.delegate onExpanded];
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
                         //add tap gesture
                         self.tapRecognizer=nil;
                         if(self.tapRecognizer==nil)
                         {
                             self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandViewOnTap:)];
                             self.tapRecognizer.numberOfTapsRequired = 1;
                             self.tapRecognizer.delegate = self;
//                             self.tapRecognizer.minimumPressDuration = 0.1;
                             [videoWrapper addGestureRecognizer:self.tapRecognizer];
                         }
                         
                         isExpandedMode=FALSE;
                         minimizedVideoFrame=videoWrapper.frame;
                         
                         if(direction==UIPanGestureRecognizerDirectionDown)
                         {
                             [self.onView bringSubviewToFront:self.view];
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


@end
