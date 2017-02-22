//
//  PreviewViewController.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 2/21/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
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
