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


    @IBOutlet weak var ibVideoWrapperView: UIView!
    @IBOutlet weak var ibPageWrapperView: UIView!
    @IBOutlet weak var ibFoldButton: UIButton!

    var moviePlayer: MPMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // 動画のパス.
        var url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("test", ofType: "mp4")!)
//        var url = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
        moviePlayer = MPMoviePlayerController(contentURL: url)
//        moviePlayer.fullscreen = false
        moviePlayer.controlStyle = MPMovieControlStyle.None
        moviePlayer.repeatMode = MPMovieRepeatMode.One
        moviePlayer.prepareToPlay()

        
        // 動画の再生が終了した時のNotification.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayBackDidFinish:",
            name: MPMoviePlayerPlaybackDidFinishNotification,
            object: moviePlayer)
        
        
//        let testVideoView = UIView()
//        testVideoView.backgroundColor = UIColor.brownColor()
        
        self.setupWithVideoView(moviePlayer.view, videoWrapperView: ibVideoWrapperView, pageWrapperView: ibPageWrapperView, foldButton: ibFoldButton)
        
        let seconds = 4.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.moviePlayer.play()

        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 動画の再生が終了した時に呼ばれるメソッド.
    func moviePlayBackDidFinish(notification: NSNotification) {
        println("moviePlayBackDidFinish:")
        moviePlayer.play()
        // 通知があったらnotificationを削除.
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
    }

}