//
//  EmojiPickerView.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 10/19/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

public protocol EmojiPickerDelegate: class {
    
    /// did press a emoji button
    ///
    /// - Parameters:
    ///   - emojiView: the emoji view
    ///   - emoji: a emoji
    func emojiViewDidSelectEmoji(emojiView: EmojiPickerView, emoji: String)

    
}

public class EmojiPickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public weak var delegate: EmojiPickerDelegate?

    public var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cv.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        cv.layer.cornerRadius = 8
        cv.contentInset = UIEdgeInsetsMake(30.0, 30.0, 2.0, 30.0)
        cv.register(EmojiPickerCollectionViewCell.self, forCellWithReuseIdentifier: "emojiPickerCell")
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height-560, width: UIScreen.main.bounds.width, height: 560)
        self.backgroundColor = UIColor.green
        self.layer.cornerRadius = 8
        self.dropShadow(color: UIColor.black, offSet: -4)
        //CollectionView
        collectionView.frame = self.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        collectionView.reloadData()
    }

    //MARK: CollectioView
    public var emojis = EmojiPickerView.defaultEmojis()
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojis.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis[section].count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiPickerCell", for: indexPath) as! EmojiPickerCollectionViewCell
        cell.setEmoji(emoji: emojis[indexPath.section][indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.emojiViewDidSelectEmoji(emojiView: self, emoji: emojis[indexPath.section][indexPath.row])
    }
    
    
    //MARK: Population
    static func defaultEmojis() -> [[String]] {
        if let path = Bundle.main.path(forResource: "EmojiList", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let emojiDic = dic["Emojis"] as? [String: [String]] {
                    var emojiList: [[String]] = []
                    for sectionName in ["People","Nature","Objects","Places","Symbols"] {
                        emojiList.append(emojiDic[sectionName]!)
                    }
                    return emojiList
                }
            }
        }
        return []
    }
}
