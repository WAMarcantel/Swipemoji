//
//  EmptyDrawOverlayView.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 10/25/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class EmptyDrawOverlayView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        let swipeOverlay = UIImage(named: "logo-gray.png")
        let swipeOverlayView = UIImageView(image: swipeOverlay)
        swipeOverlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        swipeOverlayView.center = self.center
        let overlayLabel = UILabel(frame: .zero)
        overlayLabel.frame.size = CGSize(width: 300, height: 44)
        overlayLabel.frame.origin.x -= overlayLabel.frame.width / 2 - swipeOverlayView.frame.width / 2
        overlayLabel.frame.origin.y += swipeOverlayView.frame.height
        overlayLabel.text = "swipe away!"
        overlayLabel.textAlignment = .center
        overlayLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 32)
        overlayLabel.textColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
        swipeOverlayView.frame.origin.y -= overlayLabel.frame.height / 2
        self.addSubview(swipeOverlayView)
        swipeOverlayView.addSubview(overlayLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleOpacity(opacity: Int){
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = CGFloat(opacity)
        }, completion: nil)
    }
    
    func hide(){
        self.toggleOpacity(opacity: 0)
    }
    
    func show(){
        self.toggleOpacity(opacity: 1)
    }
}
