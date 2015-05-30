//
//  VideoViewController.swift
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/05/28.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

import Foundation
import UIKit

class VideoDetailViewController: BSVideoDetailController {

    var moviePlayer: MPMoviePlayerController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let foldBtn = UIButton()
        foldBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        foldBtn.setImage(UIImage(named: "DownArrow"), forState: UIControlState.Normal)
        
        setupMoviePlayer()
        self.setupWithVideoView(moviePlayer.view, videoViewHeight: 160, foldButton: foldBtn);

        // play
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)// nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.moviePlayer.play()
        })
        
    }
    
    
    
    func setupMoviePlayer() {
        // setupMovie
        // var url = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
        var url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("test", ofType: "mp4")!)
        moviePlayer = MPMoviePlayerController(contentURL: url)
        moviePlayer.fullscreen = false
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer.repeatMode = MPMovieRepeatMode.None
        moviePlayer.prepareToPlay()
        
        // for movie loop
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayBackDidFinish:",
            name: MPMoviePlayerPlaybackDidFinishNotification,
            object: moviePlayer)
    }
    // movie loop
    func moviePlayBackDidFinish(notification: NSNotification) {
        println("moviePlayBackDidFinish:")
        moviePlayer.play()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
    }
    
    
    
    
    // MARK: FullScreen Method
    override func isFullScreen() -> Bool {
        println("isFullScreen: " + String(stringInterpolationSegment: moviePlayer.fullscreen))
        return moviePlayer.fullscreen
    }
    override func goFullScreen() {
        println("goFullScreen")
        moviePlayer.controlStyle = MPMovieControlStyle.Fullscreen
        moviePlayer.fullscreen = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willExitFullScreen", name:MPMoviePlayerWillExitFullscreenNotification, object: nil)
    }
    func willExitFullScreen() {
        println("willExitFullScreen")
        if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation))
        {
            var portrait = UIInterfaceOrientation.Portrait.rawValue as NSNumber
            UIDevice.currentDevice().setValue(portrait, forKey: "orientation")
            NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerWillExitFullscreenNotification, object: nil)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}