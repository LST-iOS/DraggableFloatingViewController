//
//  FirstViewController.swift
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/05/28.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController  {
    
    
    @IBAction func onTapShowSecondVCButton(sender: AnyObject) {
        let secondVC = SecondViewController()
        AppDelegate.videoController().changeParentVC(secondVC)
        self.presentViewController(secondVC, animated: true, completion: nil)
    }
    @IBAction func onTapButton(sender: AnyObject) {
        AppDelegate.videoController().showVideoViewControllerOnParentVC(self)
    }
    
}