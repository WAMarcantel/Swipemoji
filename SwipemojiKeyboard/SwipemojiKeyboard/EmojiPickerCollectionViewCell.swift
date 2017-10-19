//
//  EmojiPickerCollectionViewCell.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 10/19/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class EmojiPickerCollectionViewCell: UICollectionViewCell {
    
    var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple color emoji", size: 30)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupUI()
    }
    
    func setupUI(){
        emojiLabel.frame = self.bounds
        self.addSubview(emojiLabel)
    }
    
    func setEmoji(emoji: String){
        self.emojiLabel.text = emoji
    }
}
