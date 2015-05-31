


# DraggableFloatingViewController

DraggableFloatingViewController allows you to play videos on a floating mini window at the bottom of your screen from sites like YouTube, Vimeo & Facebook or custom video , yes you have to prepare your video view for that.



Usage
-----
```swift:FirstViewController.swift

import UIKit

class FirstViewController: UIViewController , DraggableFloatingViewControllerDelegate {

    var videoViewController: VideoDetailViewController!

    @IBAction func onTapButton(sender: AnyObject) {
        self.showSecondController()
    }

    override func viewWillDisappear(animated: Bool) {
        // when go to fullscreen, this is also called
        if !self.videoViewController.isFullScreen() {
            removeDraggableFloatingViewController()
        }
    }

    func showSecondController() {
        removeDraggableFloatingViewController()
        self.videoViewController = VideoDetailViewController()
        self.videoViewController.delegate = self
        self.videoViewController.showVideoViewControllerOnParentVC(self)
    }

    // DraggableFloatingViewControllerDelegate
    func removeDraggableFloatingViewController() {
        println("🌠removeDraggableFloatingViewController")
        if self.videoViewController != nil {
            self.videoViewController.removeAllViews()
            self.videoViewController = nil
        }
    }

}

```

How it works
------------
This demo app will animate the view just like Youtube mobile app, while tapping on video a UIView pops up from right corner of the screen and the view can be dragged to  right corner through Pan Gesture and more features are there as Youtube iOS app

Screenshot
------------

 ![Output sample](https://github.com/vizllx/DraggableYoutubeFloatingVideo/raw/master/Screenshot.gif)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/vizllx/draggableyoutubefloatingvideo/trend.png)](https://bitdeli.com/free "Bitdeli Badge")




# Please edit "info.plist"
* Please edit "info.plist" to hide status bar to disable Swipe Down Gesture of Notification Center.
http://stackoverflow.com/questions/18059703/cannot-hide-status-bar-in-ios7
![editInfoPlist](http://i.stack.imgur.com/dM32P.png "editInfoPlist")
