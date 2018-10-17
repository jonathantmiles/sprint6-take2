//
//  LockControl.swift
//  sprint6-retake
//
//  Created by Jonathan T. Miles on 10/16/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation
import UIKit

class LockControl: UIControl {
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 250.0, height: 250.0)
    }
    
    func setup() {
        
        self.addSubview(grayBackgroundSubview)
        grayBackgroundSubview.backgroundColor = UIColor.gray
        grayBackgroundSubview.layer.cornerRadius = 30.0
        grayBackgroundSubview.clipsToBounds = true
        
        lockView.frame = CGRect(origin: CGPoint(x: 57.5, y: 10.0), size: CGSize(width: 135.0, height: 180.0))
        self.addSubview(lockView)
        lockView.image = UIImage(named: "Locked")
        
        sliderView.frame = CGRect(x: 10.0, y: 200.0, width: 230.0, height: 40.0)
        sliderView.backgroundColor = UIColor.darkGray
        sliderView.layer.cornerRadius = 20.0
        sliderView.clipsToBounds = true
        self.addSubview(sliderView)
        
        focusView.frame = CGRect(x: 12.0, y: 202.0, width: 36.0, height: 36.0)
        focusView.backgroundColor = UIColor.black
        focusView.layer.cornerRadius = 18.0
        focusView.clipsToBounds = true
        self.addSubview(focusView)
        
        let resetButton = self.viewWithTag(1)
        resetButton?.alpha = 0.0
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gestureRecognized(sender:)))
        gestureRecognizer.maximumNumberOfTouches = 1
        gestureRecognizer.minimumNumberOfTouches = 1
        focusView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @objc func gestureRecognized(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.sliderView)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y)
        sender.setTranslation(self.sliderView.center, in: self.sliderView)
        
        switch sender.state {
        case .began:
            let location = sender.location(in: sliderView)
            if location.x < sliderView.bounds.midX {
                interactionController = UIPercentDrivenInteractiveTransition()
            }
            
            
        case .changed:
            let translation = sender.translation(in: sliderView)
            let percentComplete = translation.x / sliderView.bounds.width
            interactionController?.update(percentComplete)
        case .ended:
            guard let interactionController = interactionController else { return }
            if interactionController.percentComplete > 0.8 {
                interactionController.finish()
                self.lockView.image = UIImage(named: "Unlocked")
            } else {
                interactionController.cancel()
            }
            self.interactionController = nil
        default:
            break
        }
    }
    
    func updateXValue(at touch: UITouch) {
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            UIView.animate(withDuration: 0.0) {
                var frame = self.focusView.frame
                frame.origin.x = touchPoint.x
                self.focusView.frame = frame
                // self.sendActions(for: [.valueChanged])
            }
        }
    }
    
    func unlock() {
        lockView.image = UIImage(named: "Unlocked")
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        updateXValue(at: touch)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            sendActions(for: [.touchDragInside, .valueChanged])
            updateXValue(at: touch)
        } else {
            sendActions(for: [.touchDragOutside])
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let touch = touch else { return }
        
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            sendActions(for: [.touchUpInside, .valueChanged])
            updateXValue(at: touch)
        } else {
            sendActions(for: [.touchDragOutside])
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: [.touchCancel])
    }
    
    // logic for the > .80 percentage and animated transition to the new image view
    
    // MARK: - SubViews
    
    let grayBackgroundSubview = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: 250.0, height: 250.0))
    let sliderView = UIView()
    let focusView = UIView()
    
    let lockView = UIImageView()
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
}

enum Appearance {
    static var crimson = UIColor(red: 84.0/255.0, green: 0.0/255.0, blue: 4.0/255.0, alpha: 1.0)
    static var wheat = UIColor(red: 255.0/255.0, green: 226.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    
    static func setUpCrimsonTheme() {
        UINavigationBar.appearance().barTintColor = crimson
        UIBarButtonItem.appearance().tintColor = wheat
    }
}
