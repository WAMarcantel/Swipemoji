//
//  SuggestionCollectionViewCell.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 4/15/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell {
    
    var label : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)

        label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.center = CGPoint(x: 28, y: 22)
        label.textAlignment = .center
        label.text = "👏"
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var nibName : String {
        return "suggestionCell"
    }

}
