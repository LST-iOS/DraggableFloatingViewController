//
//  SecondViewController.swift
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/06/19.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

import Foundation

class SecondViewController: UIViewController {
    
    
    func onTapButton() {
        AppDelegate.videoController().show()//👈
    }

    func onTapDismissButton() {
        let parentVC = self.presentingViewController
        self.dismissViewControllerAnimated(true, completion: nil)
//        NSTimer.schedule(delay: 0.2) { timer in
//            AppDelegate.videoController().changeParentVC(parentVC)//👈
//        }
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()

        let btn = UIButton()
        btn.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        btn.backgroundColor = UIColor.blueColor()
        btn.addTarget(self, action: "onTapButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        
        let dismissBtn = UIButton()
        dismissBtn.frame = CGRect(x: 150, y: 150, width: 100, height: 100)
        dismissBtn.backgroundColor = UIColor.orangeColor()
        dismissBtn.addTarget(self, action: "onTapDismissButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(dismissBtn)

    }
    
}