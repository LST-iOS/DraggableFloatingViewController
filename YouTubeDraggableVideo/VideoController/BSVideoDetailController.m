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
    CGRect wrapperFrame;
    CGRect wFrame;
    CGRect vFrame;
//    CGRect growingTextViewFrame;;
    
    //local touch location
    CGFloat _touchPositionInHeaderY;
    CGFloat _touchPositionInHeaderX;
    
    //local restriction Offset--- for checking out of bound
    float restrictOffset,restrictTrueOffset,restictYaxis;
    
    //detecting Pan gesture Direction
    UIPanGestureRecognizerDirection direction;
    
    
    //Creating a transparent Black layer view
    UIView *transaparentVw;
    
    //Just to Check wether view  is expanded or not
    BOOL isExpandedMode;
    
    UIView *videoView;
    
    UIView *wrapperView;
    UIView *videoWrapperView;
    UIButton *foldButton;
}

//@synthesize player;





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
    videoWrapperView = ibVideoWrapperView;
    wrapperView = ibWrapperView;
    foldButton = ibFoldBtn;
    
    // [[BSUtils sharedInstance] showLoadingMode:self];
    
    //adding demo Video -- giving a little delay to store correct frame size
    [self performSelector:@selector(addVideoView) withObject:nil afterDelay:0.8];
    
    //adding Pan Gesture
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    pan.delegate=self;
    [videoWrapperView addGestureRecognizer:pan];

    //setting view to Expanded state
    isExpandedMode=TRUE;
    
    foldButton.hidden=TRUE;
    [foldButton addTarget:self action:@selector(onTapDownButton) forControlEvents:UIControlEventTouchUpInside];
    
    // orientation behaver
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
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





#pragma mark- Add Video on View

-(void)addVideoView
{
//    NSURL *urlString = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp4"]];
//    MPMoviePlayerController *player  = [[MPMoviePlayerController alloc] initWithContentURL:urlString];
//    player.controlStyle =  MPMovieControlStyleNone;
//    player.shouldAutoplay=YES;
//    player.repeatMode = NO;
//    player.scalingMode = MPMovieScalingModeAspectFit;
//    videoView = player.view;

//    videoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test"]];

    
    [videoView setFrame:videoWrapperView.frame];
    [videoWrapperView addSubview:videoView];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];

//    [player prepareToPlay];
    [self calculateFrames];
    
    [NSTimer scheduledTimerWithTimeInterval:0.4f
                                     target:self
                                   selector:@selector(showFoldButton)
                                   userInfo:nil
                                    repeats:NO];
}



//
//#pragma mark- MPMoviePlayerLoadStateDidChange Notification
//
//- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification {
//    if ((player.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK) {
//        //add your code
//        NSLog(@"Playing OK");
//        [self showFoldButton];
//        //[self.btnDown bringSubviewToFront:self.videoView];
//    }
//    NSLog(@"loadState=%lu",player.loadState);
//    //[self.btnDown bringSubviewToFront:self.videoView];
//}



- (void) showFoldButton {
    NSLog(@"show downButton");
//    [videoWrapperView bringSubviewToFront:foldButton];
    foldButton.hidden = FALSE;
}




#pragma mark- Calculate Frames and Store Frame Size

-(void)calculateFrames
{
    videoWrapperFrame = videoWrapperView.frame;
    wrapperFrame = wrapperView.frame;

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    // disable AutoLayout
    videoWrapperView.translatesAutoresizingMaskIntoConstraints = YES;
    wrapperView.translatesAutoresizingMaskIntoConstraints = YES;

    videoWrapperView.frame = videoWrapperFrame;
    wrapperView.frame = wrapperFrame;

    wFrame = wrapperView.frame;
    vFrame = videoWrapperView.frame;
    
    
    videoView.backgroundColor = videoWrapperView.backgroundColor = [UIColor clearColor];
    //self.videoView.layer.shouldRasterize=YES;
    // self.viewYouTube.layer.shouldRasterize=YES;
    //self.viewTable.layer.shouldRasterize=YES;
    
    restrictOffset = self.parentViewFrame.size.width - 200;
    restrictTrueOffset = self.parentViewFrame.size.height - 180;
    restictYaxis = self.parentViewFrame.size.height - videoWrapperView.frame.size.height;
    
    //[[BSUtils sharedInstance] hideLoadingMode:self];
    self.view.hidden = TRUE;
    transaparentVw = [[UIView alloc] initWithFrame:self.parentViewFrame];
    transaparentVw.backgroundColor = [UIColor blackColor];
    transaparentVw.alpha = 0.9;
    [self.onView addSubview:transaparentVw];
    [self.onView addSubview:wrapperView];
    [self.onView addSubview:videoWrapperView];
    [videoView addSubview:foldButton];
    //    [self stGrowingTextViewProperty];

    
    //animate Button Down
//    foldButton.translatesAutoresizingMaskIntoConstraints = YES;
//    foldButton.frame=CGRectMake( foldButton.frame.origin.x,  foldButton.frame.origin.y-22,  foldButton.frame.size.width,  foldButton.frame.size.width);
//    CGRect frameBtnDown=foldButton.frame;
    
    
//    [UIView animateKeyframesWithDuration:2.0 delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction animations:^{
//        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
//            foldButton.transform=CGAffineTransformMakeScale(1.5, 1.5);
//            [self addShadow];
//            foldButton.frame=CGRectMake(frameBtnDown.origin.x, frameBtnDown.origin.y+17, frameBtnDown.size.width, frameBtnDown.size.width);
//        }];
//        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
//            foldButton.frame=CGRectMake(frameBtnDown.origin.x, frameBtnDown.origin.y, frameBtnDown.size.width, frameBtnDown.size.width);
//            foldButton.transform=CGAffineTransformIdentity;
//            [self addShadow];
//        }];
//    } completion:nil];
}

//
//-(void)addShadow
//{
//    foldButton.imageView.layer.shadowColor = [UIColor whiteColor].CGColor;
//    foldButton.imageView.layer.shadowOffset = CGSizeMake(0, 1);
//    foldButton.imageView.layer.shadowOpacity = 1;
//    foldButton.imageView.layer.shadowRadius = 4.0;
//    foldButton.imageView.clipsToBounds = NO;
//}












#pragma mark- Pan Animation

- (void)expandViewOnTap:(UITapGestureRecognizer*)sender {
    NSLog(@"expandViewOnTap");
    [self expandViewOnPan];
    for (UIGestureRecognizer *recognizer in videoWrapperView.gestureRecognizers) {
        
        if([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [videoWrapperView removeGestureRecognizer:recognizer];
        }
    }
}


-(void)expandViewOnPan
{
    //        [self.txtViewGrowing resignFirstResponder];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         wrapperView.frame = wrapperFrame;
                         videoWrapperView.frame=videoWrapperFrame;
                         videoWrapperView.alpha=1;
                         videoView.frame=videoWrapperFrame;
                         wrapperView.alpha=1.0;
                         transaparentVw.alpha=1.0;
                     }
                     completion:^(BOOL finished) {
                         //                         player.controlStyle = MPMovieControlStyleDefault;
                         [self.delegate onExpanded];
                         isExpandedMode=TRUE;
                         foldButton.hidden=FALSE;
                     }];
}



-(void)minimizeViewOnPan
{
    foldButton.hidden = TRUE;
    //    [self.txtViewGrowing resignFirstResponder];
    CGFloat trueOffset = self.parentViewFrame.size.height - 100;
    CGFloat xOffset = self.parentViewFrame.size.width - 160;
    
    //Use this offset to adjust the position of your view accordingly
    wFrame.origin.y = trueOffset;
    wFrame.origin.x = xOffset;
    wFrame.size.width=self.parentViewFrame.size.width - xOffset;
    //menuFrame.size.height=200-xOffset*0.5;
    
    // viewFrame.origin.y = trueOffset;
    //viewFrame.origin.x = xOffset;
    vFrame.size.width = self.view.bounds.size.width - xOffset;
    vFrame.size.height = 200 - xOffset * 0.5;
    vFrame.origin.y = trueOffset;
    vFrame.origin.x = xOffset;
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         wrapperView.frame = wFrame;
                         videoWrapperView.frame=vFrame;
                         videoView.frame=CGRectMake( videoView.frame.origin.x,  videoView.frame.origin.x, vFrame.size.width, vFrame.size.height);
                         wrapperView.alpha=0;
                         transaparentVw.alpha=0.0;
                     }
                     completion:^(BOOL finished) {
                         //add tap gesture
                         self.tapRecognizer=nil;
                         if(self.tapRecognizer==nil)
                         {
                             self.tapRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandViewOnTap:)];
                             self.tapRecognizer.numberOfTapsRequired=1;
                             self.tapRecognizer.delegate=self;
                             [videoWrapperView addGestureRecognizer:self.tapRecognizer];
                         }
                         
                         isExpandedMode=FALSE;
                         minimizedVideoFrame=videoWrapperView.frame;
                         
                         if(direction==UIPanGestureRecognizerDirectionDown)
                         {
                             [self.onView bringSubviewToFront:self.view];
                         }
                     }];
}




-(void)removeView
{
    [self.delegate onRemoveView];
//    [self.player stop];
    [videoWrapperView removeFromSuperview];
    [wrapperView removeFromSuperview];
    [transaparentVw removeFromSuperview];
}








#pragma mark- Pan Gesture Delagate

- (BOOL)gestureRecognizerShould:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.view.frame.origin.y<0)
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
    CGFloat y = [recognizer locationInView:self.view].y;
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        
        direction = UIPanGestureRecognizerDirectionUndefined;
        //storing direction
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        [self detectPanDirection:velocity];
        
        //Snag the Y position of the touch when panning begins
        _touchPositionInHeaderY = [recognizer locationInView:videoWrapperView].y;
        _touchPositionInHeaderX = [recognizer locationInView:videoWrapperView].x;
        if(direction==UIPanGestureRecognizerDirectionDown)
        {
//            player.controlStyle = MPMovieControlStyleNone;
            [self.delegate onDownGesture];
        }
        
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged){
        if(direction==UIPanGestureRecognizerDirectionDown || direction==UIPanGestureRecognizerDirectionUp)
        {
            CGFloat trueOffset = y - _touchPositionInHeaderY;
            CGFloat xOffset = (y - _touchPositionInHeaderY)*0.35;
            [self adjustViewOnVerticalPan:trueOffset :xOffset recognizer:recognizer];
        }
        else if (direction==UIPanGestureRecognizerDirectionRight || direction==UIPanGestureRecognizerDirectionLeft)
        {
            [self adjustViewOnHorizontalPan:recognizer];
        }
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        
        if(direction==UIPanGestureRecognizerDirectionDown || direction==UIPanGestureRecognizerDirectionUp)
        {
            
            if(recognizer.view.frame.origin.y<0)
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
            else if(recognizer.view.frame.origin.y<(self.parentViewFrame.size.width/2))
            {
                [self expandViewOnPan];
                [recognizer setTranslation:CGPointZero inView:recognizer.view];
                return;
                
            }
        }
        
        else if (direction==UIPanGestureRecognizerDirectionLeft)
        {
            if(wrapperView.alpha<=0)
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
            if(wrapperView.alpha<=0)
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





-(void)animateViewToRight:(UIPanGestureRecognizer *)recognizer{
//    [self.txtViewGrowing resignFirstResponder];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         wrapperView.frame = wFrame;
                         videoWrapperView.frame=vFrame;
                         videoView.frame=CGRectMake( videoView.frame.origin.x,  videoView.frame.origin.x, vFrame.size.width, vFrame.size.height);
                         wrapperView.alpha=0;
                         videoWrapperView.alpha=1;
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
                         wrapperView.frame = wFrame;
                         videoWrapperView.frame=vFrame;
                         videoView.frame=CGRectMake( videoView.frame.origin.x,  videoView.frame.origin.x, vFrame.size.width, vFrame.size.height);
                         wrapperView.alpha=0;
                         videoWrapperView.alpha=1;
                         
                         
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
}


-(void)adjustViewOnHorizontalPan:(UIPanGestureRecognizer *)recognizer {
//    [self.txtViewGrowing resignFirstResponder];
    CGFloat x = [recognizer locationInView:self.view].x;
    
    if (direction==UIPanGestureRecognizerDirectionLeft)
    {
        if(wrapperView.alpha<=0)
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
    }
    else if (direction==UIPanGestureRecognizerDirectionRight)
    {
        if(wrapperView.alpha<=0)
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





-(void)adjustViewOnVerticalPan:(CGFloat)trueOffset :(CGFloat)xOffset recognizer:(UIPanGestureRecognizer *)recognizer
{
//    [self.txtViewGrowing resignFirstResponder];
    CGFloat y = [recognizer locationInView:self.view].y;
    
    if(trueOffset>=restrictTrueOffset+60||xOffset>=restrictOffset+60)
    {
        CGFloat trueOffset = self.parentViewFrame.size.height - 100;
        CGFloat xOffset = self.parentViewFrame.size.width-160;
        //Use this offset to adjust the position of your view accordingly
        wFrame.origin.y = trueOffset;
        wFrame.origin.x = xOffset;
        wFrame.size.width=self.parentViewFrame.size.width-xOffset;
        
        vFrame.size.width=self.view.bounds.size.width-xOffset;
        vFrame.size.height=200-xOffset*0.5;
        vFrame.origin.y=trueOffset;
        vFrame.origin.x=xOffset;
        
        
        
        
        [UIView animateWithDuration:0.05
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             wrapperView.frame = wFrame;
                             videoWrapperView.frame=vFrame;
                             videoView.frame=CGRectMake( videoView.frame.origin.x,  videoView.frame.origin.x, vFrame.size.width, vFrame.size.height);
                             wrapperView.alpha=0;
                             
                             
                             
                         }
                         completion:^(BOOL finished) {
                             minimizedVideoFrame=videoWrapperView.frame;
                             
                             isExpandedMode=FALSE;
                         }];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    }
    else
    {
        
        //Use this offset to adjust the position of your view accordingly
        wFrame.origin.y = trueOffset;
        wFrame.origin.x = xOffset;
        wFrame.size.width=self.parentViewFrame.size.width-xOffset;
        vFrame.size.width=self.view.bounds.size.width-xOffset;
        vFrame.size.height=200-xOffset*0.5;
        vFrame.origin.y=trueOffset;
        vFrame.origin.x=xOffset;
        float restrictY=self.parentViewFrame.size.height-videoWrapperView.frame.size.height-10;
        
        
        if (wrapperView.frame.origin.y<restrictY && wrapperView.frame.origin.y>0) {
            [UIView animateWithDuration:0.09
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ {
                                 wrapperView.frame = wFrame;
                                 videoWrapperView.frame=vFrame;
                                 videoView.frame=CGRectMake( videoView.frame.origin.x,  videoView.frame.origin.x, vFrame.size.width, vFrame.size.height);
                                 
                                 CGFloat percentage = y/self.parentViewFrame.size.height;
                                 wrapperView.alpha= transaparentVw.alpha = 1.0 - percentage;
                                 
                                 
                                 
                                 
                             }
                             completion:^(BOOL finished) {
                                 if(direction==UIPanGestureRecognizerDirectionDown)
                                 {
                                     [self.onView bringSubviewToFront:self.view];
                                 }
                             }];
        }
        else if (wFrame.origin.y<restrictY&& wFrame.origin.y>0)
        {
            [UIView animateWithDuration:0.09
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ {
                                 wrapperView.frame = wFrame;
                                 videoWrapperView.frame=vFrame;
                                 videoView.frame=CGRectMake( videoView.frame.origin.x,  videoView.frame.origin.x, vFrame.size.width, vFrame.size.height);
                             }completion:nil];
            
            
        }
        
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
}



-(void)detectPanDirection:(CGPoint )velocity
{
    foldButton.hidden=TRUE;
    BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
    
    if (isVerticalGesture) {
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








//#pragma mark - UITableViewDataSource
//
//// number of section(s), now I assume there is only 1 section
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
//{
//    return 1;
//}
//
//// number of row in the section, I assume there is only 1 row
//- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
//{
//    return 10;
//}
//
//// the cell will be returned to the tableView
//- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"videoCommentCell";
//    UITableViewCell *cell;
//    cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    cell.backgroundColor = [UIColor clearColor];
//    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 88.0;
//}
//
//
//
//#pragma mark - UITableViewDelegate
//
//// when user tap the row, what action you want to perform
//- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"selected %ld row", (long)indexPath.row);
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}





//- (IBAction)btnSendAction:(id)sender {
//    [self.txtViewGrowing resignFirstResponder];
//    self.txtViewGrowing.text=@"";
//    [UIView animateWithDuration:0.2f
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         
//                         self.viewGrowingTextView.frame=growingTextViewFrame;
//                     }completion:^(BOOL finished) {
//                         
//                     }];
//}



//
//#pragma mark - Keyboard events
//
////Handling the keyboard appear and disappering events
//- (void)keyboardWasShown:(NSNotification*)aNotification
//{
//    //__weak typeof(self) weakSelf = self;
//    NSDictionary* info = [aNotification userInfo];
////    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    [UIView animateWithDuration:0.3f
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
////                         float yPosition=self.view.frame.size.height- kbSize.height- self.viewGrowingTextView.frame.size.height;
////                         self.viewGrowingTextView.frame=CGRectMake(0, yPosition, self.viewGrowingTextView.frame.size.width, self.viewGrowingTextView.frame.size.height);
//
//                         //                         [weakSelf.registerScrView setContentOffset:CGPointMake(0, (weakSelf.userNameTxtfld.frame.origin.y+weakSelf.userNameTxtfld.frame.size.height)-kbSize.height) animated:YES];
//
//                     }
//                     completion:^(BOOL finished) {
//                     }];
//}
//
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    // __weak typeof(self) weakSelf = self;
//    //NSDictionary* info = [aNotification userInfo];
//    [UIView animateWithDuration:0.3f
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         float yPosition=self.view.frame.size.height-self.viewGrowingTextView.frame.size.height;
//                         self.viewGrowingTextView.frame=CGRectMake(0, yPosition, self.viewGrowingTextView.frame.size.width, self.viewGrowingTextView.frame.size.height);
//                     }
//                     completion:^(BOOL finished) {
//                     }];
//}
//
//



//#pragma mark - Text View delegate -
//
//#pragma mark- View Function Methods
//
//-(void)stGrowingTextViewProperty
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIContentSizeCategoryDidChangeNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//
//
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
//
//}
//

@end
