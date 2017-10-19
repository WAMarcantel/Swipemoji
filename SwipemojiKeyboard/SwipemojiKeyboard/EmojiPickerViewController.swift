//
//  EmojiPickerViewController.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 10/18/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class EmojiPickerViewController: UIViewController {
    
    var emojiList: [[String]] = []
    let sectionTitle: [String] = ["Emoticons", "Dingbats", "Transport and map symbols", "Enclosed Characters"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let emojiView = EmojiPickerView()
        self.view.addSubview(emojiView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
