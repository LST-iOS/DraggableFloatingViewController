//
//  FirstViewController.swift
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/05/28.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController  {
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()

        let btn = UIButton()
        btn.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        btn.backgroundColor = UIColor.redColor()
        btn.addTarget(self, action: "onTapShowButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        
        let dismissBtn = UIButton()
        dismissBtn.frame = CGRect(x: 150, y: 150, width: 100, height: 100)
        dismissBtn.backgroundColor = UIColor.greenColor()
        dismissBtn.addTarget(self, action: "onTapShowSecondVCButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(dismissBtn)
        
    }

    func onTapShowButton() {
        AppDelegate.videoController().show(self)//👈
    }

    func onTapShowSecondVCButton() {
        let secondVC = SecondViewController()
        AppDelegate.videoController().changeParentVC(secondVC)//👈
        self.presentViewController(secondVC, animated: true, completion: nil)
    }
    
}