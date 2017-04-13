//
//  emojiCollectionViewCell.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 4/12/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class emojiCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var gestureView: UIView!
    var emojiDrawingCanvas:PointDisplayCanvas?

}
