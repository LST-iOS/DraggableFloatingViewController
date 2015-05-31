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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let foldBtn = UIButton()
        foldBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        foldBtn.setImage(UIImage(named: "DownArrow"), forState: UIControlState.Normal)

        moviePlayer = MPMoviePlayerController()

        self.setupViewsWithVideoView(moviePlayer.view, videoViewHeight: 160, foldButton: foldBtn);

        // add sub views on body area
        let testView = UILabel()
        testView.frame = CGRect(x: 20, y: 10, width: 100, height: 40)
        testView.text = "body view"
        testView.textColor = UIColor.redColor()
        self.bodyView.addSubview(testView)

        //dev
        self.bodyView.backgroundColor = UIColor.whiteColor()
        self.bodyView.layer.borderColor = UIColor.redColor().CGColor
        self.bodyView.layer.borderWidth = 10.0

        
        setupMoviePlayer()
        addObserver(selector: "onOrientationChanged", name: UIDeviceOrientationDidChangeNotification)
    }
    
    override func onExpand() {
        showVideoControl()
    }
    override func onMinimized() {
        hideVideoControl()
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