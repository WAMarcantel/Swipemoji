//
//  KeyboardViewController.swift
//  Swipemoji
//
//  Created by Takashi Wickes on 2/8/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var keyboardView: UIView!
    @IBOutlet weak var drawingArea: UIView!

    var lastPoint = CGPoint.zero
    var drawingCanvas:PointDrawingCanvas?
    var _library = PointCloudLibrary.getDemoLibrary()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadInterface();
 
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        drawingCanvas = PointDrawingCanvas(frame: drawingArea!.bounds)
        drawingCanvas!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        drawingArea!.addSubview(drawingCanvas!)
        // Perform custom UI setup here
        
        keyboardView.backgroundColor = UIColor(red:0.82, green:0.84, blue:0.86, alpha:1.0)
    }
    
    func loadInterface() {
//        // load the nib file
        let keyboardNib = UINib(nibName: "Swipemoji", bundle: nil)
//        // instantiate the view
        keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        // add the interface to the main view
        view.addSubview(keyboardView)
        
        // copy the background color
        view.backgroundColor = keyboardView.backgroundColor
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        drawingCanvas?.clearCanvas()
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        if let canvas = drawingCanvas {
            if !canvas.isEmpty() {
                let pointCloud = PointCloud("input gesture", canvas.points)
                let matchResult = _library.recognizeFromLibrary(pointCloud)
//                let text = "\(matchResult.name), score: \(matchResult.score)"
                let text = "\(matchResult.name) "
                var proxy = textDocumentProxy as UITextDocumentProxy
                
                if let input = text as String? {
                    proxy.insertText(input)
                    drawingCanvas?.clearCanvas()
                }
            } else {
//                self.label!.text = "No match result."
            }
        }
    }
    
    @IBAction func backspacePressed(_ sender: Any) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.deleteBackward()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
