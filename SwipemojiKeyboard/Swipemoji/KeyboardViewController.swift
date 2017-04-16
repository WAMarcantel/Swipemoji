//
//  KeyboardViewController.swift
//  Swipemoji
//
//  Created by Takashi Wickes on 2/8/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var keyboardView: UIView!
    @IBOutlet weak var drawingArea: UIView!

    @IBOutlet weak var suggestionView: UIView!
    var lastPoint = CGPoint.zero
    var drawingCanvas:PointDrawingCanvas?
    var _library = PointCloudLibrary.getDemoLibrary()
    var suggestions : [String]?
    var newCharacter : Bool = true
    var lastInput : String = ""

    let cellId = "suggestionCell"

    override func updateViewConstraints() {
        super.updateViewConstraints()

        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: "strokeEnded", name: NSNotification.Name(rawValue: "reload"), object: nil)

        loadInterface();

        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)

        self.view.addSubview(self.nextKeyboardButton)

        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true


        drawingCanvas = PointDrawingCanvas(frame: drawingArea!.bounds)
        drawingCanvas!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        drawingCanvas?.backgroundColor = UIColor.white
        drawingArea!.addSubview(drawingCanvas!)
        drawingArea.backgroundColor = UIColor.white
        // Perform custom UI setup here

        keyboardView.backgroundColor = UIColor(red:0.82, green:0.84, blue:0.86, alpha:1.0)
        self.populateSuggestions(pointCloud: nil)
        createSuggestionView()
    }

    func createSuggestionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SuggestionCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _library.pointClouds.count > 10 ? 10 : _library.pointClouds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! SuggestionCollectionViewCell
        if let canvas = drawingCanvas {
            cell.label.text = suggestions?[indexPath.item]
        }
        return cell
    }

    func populateSuggestions(pointCloud : PointCloud?){
        if(pointCloud == nil){
            self.suggestions = Array(_library.pointClouds.prefix(10)).map({$0.name})
            return
        }
        self.suggestions = _library.recognizeoptionsFromLibrary(pointCloud!)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
        var proxy = textDocumentProxy as UITextDocumentProxy
        var input = suggestions?[indexPath.item]
        if let canvas = drawingCanvas {
            if canvas.isEmpty(){
                proxy.insertText(input!)
            }
            else{
                
                if(newCharacter){
                    proxy.insertText(input!)
                    newCharacter = false
                    //                        proxy.adjustTextPosition(byCharacterOffset: -(input.characters.count+1))
                    self.lastInput = input!
                } else {
                    proxy.documentInputMode.customMirror
                    for i in 1...self.lastInput.characters.count {
                        //                            proxy.adjustTextPosition(byCharacterOffset: (1))
                        proxy.deleteBackward()
                    }
                    proxy.insertText(input!)
                    //                        proxy.adjustTextPosition(byCharacterOffset: -(input.characters.count+1))
                    self.lastInput = input!
                }
            }
            self.reset()
        }
    }

    func strokeEnded() {
        print("Stroke End Detected")
        if let canvas = drawingCanvas {

            if !canvas.isEmpty() {
                DispatchQueue.global(qos: .userInitiated).async { // 1
                    //let overlayImage = self.faceOverlayImageFromImage(self.image)
                    print("JUST ANOTHER BRICK IN THE QUEUE")
                    var optionals: [String] = []
                    let pointCloud = PointCloud("input gesture", canvas.points)
                    let matchResult = self._library.recognizeFromLibrary(pointCloud)
                    //                let text = "\(matchResult.name), score: \(matchResult.score)"
                    optionals = self._library.recognizeoptionsFromLibrary(pointCloud)
                    self.populateSuggestions(pointCloud: pointCloud)


                    DispatchQueue.main.async { // 2
                        self.collectionView.reloadData()
                    }


                    let text = "\(matchResult.name)"
                    let proxy = self.textDocumentProxy as UITextDocumentProxy

                    if let input = text as String? {
                        if(self.newCharacter){
                            proxy.insertText(input)
                            self.newCharacter = false
                            //                        proxy.adjustTextPosition(byCharacterOffset: -(input.characters.count+1))
                            self.lastInput = input
                        } else {
                            proxy.documentInputMode.customMirror
                            for i in 1...self.lastInput.characters.count {
                                //                            proxy.adjustTextPosition(byCharacterOffset: (1))
                                proxy.deleteBackward()
                            }
                            proxy.insertText(input)
                            //                        proxy.adjustTextPosition(byCharacterOffset: -(input.characters.count+1))
                            self.lastInput = input
                        }

                        //                    drawingCanvas?.clearCanvas()
                    }


                }
                            } else {
                //                self.label!.text = "No match result."
            }
        }

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

    func reset(){
        drawingCanvas?.clearCanvas()
        self.populateSuggestions(pointCloud: nil)
        collectionView.reloadData()
    }

    @IBAction func clearButtonPressed(_ sender: Any) {
        self.reset()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    @IBAction func submitPressed(_ sender: Any) {
        if let canvas = drawingCanvas {
            if !canvas.isEmpty() {
                var proxy = textDocumentProxy as UITextDocumentProxy
//                proxy.adjustTextPosition(byCharacterOffset: 1)
                drawingCanvas?.clearCanvas()
                newCharacter = true
            } else {
//                self.label!.text = "No match result."
            }
        }
    }

    @IBAction func backspacePressed(_ sender: Any) {
        var proxy = textDocumentProxy as UITextDocumentProxy
        proxy.deleteBackward()
        self.reset()
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
