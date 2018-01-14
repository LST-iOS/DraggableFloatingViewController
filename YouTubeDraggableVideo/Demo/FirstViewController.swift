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
        self.view.backgroundColor = .white

        let btn = UIButton()
        btn.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(onTapShowButton), for: .touchUpInside)
        self.view.addSubview(btn)
        
        let dismissBtn = UIButton()
        dismissBtn.frame = CGRect(x: 150, y: 150, width: 100, height: 100)
        dismissBtn.backgroundColor = .green
        dismissBtn.addTarget(self, action: #selector(onTapShowSecondVCButton), for: .touchUpInside)
        self.view.addSubview(dismissBtn)
        
    }

    @objc func onTapShowButton() {
        (UIApplication.shared.delegate as! AppDelegate).videoViewController.show() //👈
    }

    @objc func onTapShowSecondVCButton() {
        (UIApplication.shared.delegate as! AppDelegate).videoViewController.bringToFront()//👈
        let secondVC = SecondViewController()
        self.present(secondVC, animated: true, completion: nil)
    }
    
}
