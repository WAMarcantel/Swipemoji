//
//  GestureMatchController.swift
//  SwipemojiKeyboard
//
//  Created by Shakeeb Majid on 2/17/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class GestureMatchController: UIViewController {

    @IBOutlet weak var emojiText: UITextField!
    
    @IBOutlet weak var canvas: UIView!
    
    
    var lastPoint = CGPoint.zero
    
    var drawingCanvas:PointDrawingCanvas?
    
    var _library = PointCloudLibrary.getDemoLibrary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawingCanvas = PointDrawingCanvas(frame: canvas.bounds)
        drawingCanvas!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        canvas.addSubview(drawingCanvas!)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitGesture(_ sender: Any) {
        if let canvas = drawingCanvas {
            if !canvas.isEmpty() {
                //let pointCloud = PointCloud("input gesture", canvas.points)
                
                //let matchResult = _library.recognizeFromLibrary(pointCloud)
                //                let text = "\(matchResult.name), score: \(matchResult.score)"
                
                //print(canvas.points) //array of Point objects
                if let dicArray = UserDefaults.standard.array(forKey: "gestures") as? [NSMutableDictionary] {
                    var dicArrayStore = dicArray
                    dicArrayStore.append([emojiText.text!:pointsToArray(points: canvas.points)])
                    //_library.pointClouds.append(PointCloud(emojiText.text!, canvas.points))
                    UserDefaults.standard.set(dicArrayStore, forKey: "gestures")
                    
                } else {
                    var dicArray: [NSMutableDictionary] = []
                    
                    dicArray.append([emojiText.text!:pointsToArray(points: canvas.points)])
                    //_library.pointClouds.append(PointCloud(emojiText.text!, canvas.points))
                    
                    UserDefaults.standard.set(dicArray, forKey: "gestures")
                }
                
                
                
                
                
                
                //let text = "\(matchResult.name) "
                //var proxy = textDocumentProxy as UITextDocumentProxy
                
                /*if let input = text as String? {
                    proxy.insertText(input)
                    drawingCanvas?.clearCanvas()
                }*/
            } else {
                //self.emojiText.text = "No match result."
            }
        }
        
        
        
    }
    func pointsToArray(points:[Point]) -> [NSArray] {
        var pointArray = [] as [NSArray]
        
        for point in points {
            var array = [point.x, point.y, point.id] as NSArray
            pointArray.append(array)
            
            
            
            
            
            
        }
        //print(pointArray)
        return pointArray
        
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
