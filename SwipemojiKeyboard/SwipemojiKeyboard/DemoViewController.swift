//
//  DemoViewController.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 4/13/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var emojiView: UIView!
    @IBOutlet weak var hypeAlert: UIView!
    @IBOutlet weak var hypeLabel: UILabel!
    
    var _library = PointCloudLibrary.getDemoLibrary()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hypeAlert.layer.cornerRadius = hypeAlert.frame.width / 2
        emojiView.layer.cornerRadius = emojiView.frame.width / 2
        resetMatchingGame()
        hypeLabel.text = emojiLabel.text
        hypeAlert.transform = CGAffineTransform(scaleX: 0, y: 0)
        hypeAlert.isUserInteractionEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func correctAlert(){
        UIView.animate(withDuration: 0.4, animations: {
            self.hypeAlert.center.y = 200
            self.hypeAlert.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (finished: Bool) in
            self.resetMatchingGame()
            UIView.animate(withDuration: 0.3, animations: {
                self.hypeAlert.alpha = 0
            }, completion: { (finished: Bool) in
                self.hypeAlert.transform = CGAffineTransform(scaleX: 0, y: 0)
                self.hypeAlert.alpha = 1
                self.hypeLabel.text = self.emojiLabel.text
            })

            
        })
//        hypeAlert.transform = CGAffineTransform(scaleX: 0, y: 0)
//        self.hypeAlert.alpha = 1
////        sleep(2)
        
    }
    
    func resetMatchingGame(){
        emojiLabel.text = getRandomEmoji()
        self.inputTextField.text = ""
    }
    
    func getRandomEmoji() -> String{
        let randomIndex = Int(arc4random_uniform(UInt32(_library.pointClouds.count)))
        return _library.pointClouds[randomIndex].name
    }
    
    @IBAction func inputEmojiChanged(_ sender: Any) {
        if(inputTextField.text! == emojiLabel.text!){
            correctAlert()
        }
    }

    
    @IBAction func dismissPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
