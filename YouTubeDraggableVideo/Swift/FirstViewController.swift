//
//  FirstViewController.swift
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/05/28.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController , DraggableFloatingViewControllerDelegate {
    
    var secondViewController: VideoDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // dev
//        let seconds = 0.3
//        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
//        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
//            self.showSecondController()
//        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        // when go to fullscreen, this is also called
        if !self.secondViewController.isFullScreen() {
            removeDraggableFloatingViewController()
        }
    }
    
    @IBAction func onTapButton(sender: AnyObject) {
        self.showSecondController()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func showSecondController() {
        removeDraggableFloatingViewController()
        self.secondViewController = VideoDetailViewController()
        self.secondViewController.showVideoViewControllerFromDelegateVC(self)
    }

    
    
    
    
    
    
    // MARK: DraggableFloatingViewControllerDelegate
    func removeDraggableFloatingViewController() {
        println("🌠removeDraggableFloatingViewController")
        if self.secondViewController != nil {
            self.secondViewController.removeView()
            self.secondViewController = nil
        }

        //TODO: stop the player
    }
    
}