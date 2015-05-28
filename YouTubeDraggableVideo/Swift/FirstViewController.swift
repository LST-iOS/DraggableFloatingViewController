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


//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        // FIX: rewrite after
        //    if(self.secondViewController!=nil && !self.secondViewController.player.isFullscreen)
        //    {
        //        [self.secondViewController removeView];
        //        [self.secondViewController.view removeFromSuperview];
        //        self.secondViewController=nil;
        //    }
    }
    
    @IBAction func onTapButton(sender: AnyObject) {
        self.showSecondController()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func showSecondController() {

        
        var portrait = UIInterfaceOrientation.Portrait.rawValue as NSNumber
        if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)) {
            UIDevice.currentDevice().setValue(portrait, forKey: "orientation")
        }
        

        if self.secondViewController != nil {
            self.secondViewController.removeView()
            self.secondViewController.view.removeFromSuperview()
            self.secondViewController = nil
        }
        
        
        self.secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VideoDetailController") as! BSVideoDetailController
        
        self.secondViewController.delegate = self
        
        // initial frame
        self.secondViewController.view.frame = CGRectMake(
            self.view.frame.size.width - 50, self.view.frame.size.height - 50,
            self.view.frame.size.width, self.view.frame.size.height
        )
        self.secondViewController.initialFirstViewFrame = self.view.frame

        self.secondViewController.view.alpha = 0
        self.secondViewController.view.transform = CGAffineTransformMakeScale(0.2, 0.2)
        
        self.view.addSubview(self.secondViewController.view)
        self.secondViewController.onView = self.view;
        
        UIView.animateWithDuration(0.9, animations: { ()-> Void in
            self.secondViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.secondViewController.view.alpha = 1
            self.secondViewController.view.frame = CGRectMake(
                self.view.frame.origin.x, self.view.frame.origin.y,
                self.view.frame.size.width, self.view.frame.size.height
            )
        });
    }

    func removeController() {
        println("🌠removeController")
        self.secondViewController = nil
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