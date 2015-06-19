//
//  FirstViewController.swift
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/05/28.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController , DraggableFloatingViewControllerDelegate {
    
    var videoViewController: VideoDetailViewController?
    
    @IBAction func onTapButton(sender: AnyObject) {
        self.showVideoViewController()
    }

    override func viewWillDisappear(animated: Bool) {
        // when go to fullscreen, this is also called
        if (self.videoViewController != nil) {
            if (!self.videoViewController!.isFullScreen()) {
                removeDraggableFloatingViewController()
            }
        }
    }

    func showVideoViewController() {
        removeDraggableFloatingViewController()
        self.videoViewController = VideoDetailViewController()
        self.videoViewController!.delegate = self
        self.videoViewController!.showVideoViewControllerOnParentVC(self)
    }

    // DraggableFloatingViewControllerDelegate
    func removeDraggableFloatingViewController() {
        println("removeDraggableFloatingViewController")
        if self.videoViewController != nil {
            self.videoViewController!.removeAllViews()
            self.videoViewController = nil
        }
    }
    
}