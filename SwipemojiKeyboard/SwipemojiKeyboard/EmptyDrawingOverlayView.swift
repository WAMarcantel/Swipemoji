//
//  DrawingEmptyState.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 10/24/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

public class EmptyDrawingOverlayView: UIView {

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
        swipeOverlayView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        swipeOverlayView.center = self.center
        self.addSubview(swipeOverlayView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
