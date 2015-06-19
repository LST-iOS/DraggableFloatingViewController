//
//  VideoViewController.swift
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/05/28.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

import Foundation
import UIKit

class VideoDetailViewController: DraggableFloatingViewController {

    var moviePlayer: MPMoviePlayerController!
    private let loadingSpinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviePlayer = MPMoviePlayerController()

        self.setupViewsWithVideoView(moviePlayer.view, videoViewHeight: 160)//, minimizeButton: minimizeButton)

        setupMoviePlayer()

        addObserver(selector: "onOrientationChanged", name: UIDeviceOrientationDidChangeNotification)
        
        // design controller view
        let minimizeButton = UIButton()
        minimizeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        minimizeButton.setImage(UIImage(named: "DownArrow"), forState: UIControlState.Normal)
        minimizeButton.addTarget(self, action: "onTapMinimizeButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.controllerView.addSubview(minimizeButton)
        let testControl = UILabel()
        testControl.frame = CGRect(x: 100, y: 5, width: 150, height: 40)
        testControl.text = "controller view"
        testControl.textColor = UIColor.whiteColor()
        self.controllerView.addSubview(testControl)
        
        // design body view
        self.bodyView.backgroundColor = UIColor.whiteColor()
        self.bodyView.layer.borderColor = UIColor.redColor().CGColor
        self.bodyView.layer.borderWidth = 10.0
        let testView = UILabel()
        testView.frame = CGRect(x: 20, y: 10, width: 100, height: 40)
        testView.text = "body view"
        testView.textColor = UIColor.redColor()
        self.bodyView.addSubview(testView)
        
        // design message view
        self.messageView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        loadingSpinner.frame = CGRectMake(0, 0, 50, 50)
        loadingSpinner.center = self.messageView.center
        loadingSpinner.hidesWhenStopped = false
        loadingSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        self.messageView.addSubview(loadingSpinner)
    }
    
    override func didDisappear() {
        moviePlayer.pause()
    }

    override func didReAppear() {
        setupMoviePlayer()
    }

    
    
    func onTapButton() {
        println("onTapButton")
    }
    
    override func showMessageView() {
        loadingSpinner.startAnimating()
        super.showMessageView()
    }
    override func hideMessageView() {
        super.hideMessageView()
        loadingSpinner.stopAnimating()
    }
    
    override func didFullExpandByGesture() {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        showVideoControl()
    }
    override func didExpand() {
        println("didExpand")
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        showVideoControl()
    }
    override func didMinimize() {
        println("didMinimized")
        hideVideoControl()
    }
    
    override func didStartMinimizeGesture() {
        println("didStartMinimizeGesture")
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    
    
    func onTapMinimizeButton() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        self.minimizeView()
    }
    
    
    
    // --------------------------------------------------------------------------------------------------
    
    func setupMoviePlayer() {
        // setupMovie
        var url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("test", ofType: "mp4")!)
        moviePlayer.contentURL = url
        moviePlayer.fullscreen = false
        moviePlayer.controlStyle = MPMovieControlStyle.None
        moviePlayer.repeatMode = MPMovieRepeatMode.None
        moviePlayer.prepareToPlay()
        
        // play
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)// nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.moviePlayer.play()
        })

        // for movie loop
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayBackDidFinish:",
            name: MPMoviePlayerPlaybackDidFinishNotification,
            object: moviePlayer)
    }

    // movie loop
    func moviePlayBackDidFinish(notification: NSNotification) {
        println("moviePlayBackDidFinish:")
        moviePlayer.play()
        removeObserver(MPMoviePlayerPlaybackDidFinishNotification)
    }
    
    
    
    
    // ----------------------------- events -----------------------------------------------
    
    // MARK: Orientation
    func onOrientationChanged() {
        let orientation: UIInterfaceOrientation = getOrientation()
        
        switch orientation {
        
        case .Portrait, .PortraitUpsideDown:
            println("portrait")
            exitFullScreen()

        case .LandscapeLeft, .LandscapeRight:
            println("landscape")
            goFullScreen()

        default:
            println("no action for this orientation:" + orientation.rawValue.description)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    // --------------------------------- util ------------------------------------------
    
    // MARK: FullScreen Method
    func isFullScreen() -> Bool {
//        println("isFullScreen: " + String(stringInterpolationSegment: moviePlayer.fullscreen))
        return moviePlayer.fullscreen
    }
    func goFullScreen() {
        if !isFullScreen() {
//            println("goFullScreen")
            moviePlayer.controlStyle = MPMovieControlStyle.Fullscreen
            moviePlayer.fullscreen = true
            addObserver(selector: "willExitFullScreen", name: MPMoviePlayerWillExitFullscreenNotification)
        }
    }
    func exitFullScreen() {
        if isFullScreen() {
//            println("exit fullscreen");
            moviePlayer.fullscreen = false
        }
    }
    func willExitFullScreen() {
//        println("willExitFullScreen")
        if isLandscape()
        {
            setOrientation(.Portrait)
        }

        removeObserver(MPMoviePlayerWillExitFullscreenNotification)
    }

    
    // FIXIT: Don't work
    func showVideoControl() {
//        println("showVideoControl");
        moviePlayer.controlStyle = MPMovieControlStyle.None
    }
    
    // FIXIT: Don't work
    func hideVideoControl() {
//        println("hideVideoControl")
        moviePlayer.controlStyle = MPMovieControlStyle.None
    }
    
    
    
    
    //-----------------------------------------------------------------------------------
    
    func getOrientation() -> UIInterfaceOrientation {
        return UIApplication.sharedApplication().statusBarOrientation
    }
    
    func setOrientation(orientation: UIInterfaceOrientation) {
        var orientationNum: NSNumber = NSNumber(integer: orientation.rawValue)
        UIDevice.currentDevice().setValue(orientationNum, forKey: "orientation")
    }
    
    func addObserver(selector aSelector: Selector, name aName: String? ) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: aSelector, name:aName, object: nil)

    }
    
    func removeObserver(aName: String?) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: aName, object: nil)
    }
    
    func isLandscape() -> Bool {
        if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)) {
            return true
        }
        else {
            return false
        }
    }
}
