//
//  FirstViewController.swift
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/05/28.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController , RemoveViewDelegate {
    
    var secondViewController: BSVideoDetailController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // dev
        let seconds = 0.3
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.showSecondController()
        })
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.secondViewController != nil && !self.secondViewController.isFullScreen() {
            removeVideoViewController()
        }
    }
    
    @IBAction func onTapButton(sender: AnyObject) {
        self.showSecondController()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func showSecondController() {

        removeVideoViewController()
        self.secondViewController = VideoDetailViewController()
        self.secondViewController.showVideoViewControllerFromDelegateVC(self)
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: DraggableFloatingViewController delegate
    // TODO: rename
    func removeVideoViewController() {
        println("🌠removeController")
//        self.secondViewController = nil
        if self.secondViewController != nil {
            self.secondViewController.removeView()
            self.secondViewController.view.removeFromSuperview()
            self.secondViewController = nil
        }
    }
    func onExpanded() {
        println("🌠onExpanded")
        //MPMoviewControlStyleDeafult
    }
    
    func onRemoveView(){
        println("🌠onRemoveView")
        //stop the player
    }
    func onDownGesture(){
        println("🌠onDownGesture")
        //MPMoviewControlStyleNone
    }
}