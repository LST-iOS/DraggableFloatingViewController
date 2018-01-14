//
//  SecondViewController.swift
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/06/19.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

import Foundation

class SecondViewController: UIViewController {
    
    
    @objc func onTapButton() {
        (UIApplication.shared.delegate as! AppDelegate).videoViewController.show()//👈
    }

    @objc func onTapDismissButton() {
        let parentVC = self.presentingViewController
        self.dismiss(animated: true, completion: nil)
//        NSTimer.schedule(delay: 0.2) { timer in
//            AppDelegate.videoController().changeParentVC(parentVC)//👈
//        }
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white

        let btn = UIButton()
        btn.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
        self.view.addSubview(btn)
        
        let dismissBtn = UIButton()
        dismissBtn.frame = CGRect(x: 150, y: 150, width: 100, height: 100)
        dismissBtn.backgroundColor = .orange
        dismissBtn.addTarget(self, action: #selector(onTapDismissButton), for: .touchUpInside)
        self.view.addSubview(dismissBtn)

    }
    
}
