//
//  NSTimerHelper.swift
//  YouTubeDraggableVideo
//
//  Created by Takuya Okamoto on 2015/06/19.
//  Copyright (c) 2015年 Sandeep Mukherjee. All rights reserved.
//

import Foundation

extension NSTimer {
    class func schedule(#delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}


// Usage:

//var count = 0
//NSTimer.schedule(repeatInterval: 1) { timer in
//    println(++count)
//    if count >= 10 {
//        timer.invalidate()
//    }
//}
//
//NSTimer.schedule(delay: 5) { timer in
//    println("5 seconds")
//}