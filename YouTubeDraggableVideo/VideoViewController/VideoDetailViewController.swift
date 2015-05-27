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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testVideoView = UIView()
        testVideoView.backgroundColor = UIColor.brownColor()
        
        self.setupWithVideoView(testVideoView, videoWrapperView: ibVideoWrapperView, pageWrapperView: ibPageWrapperView, foldButton: ibFoldButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}