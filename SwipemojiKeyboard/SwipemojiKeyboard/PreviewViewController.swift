//
//  PreviewViewController.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 2/21/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var _library = PointCloudLibrary.getDemoLibrary()
    var isEmojiCollection = true
    
    @IBOutlet weak var viewOptionSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewOptionChanged(_ sender: Any) {
        switch viewOptionSegmentedControl.selectedSegmentIndex
        {
            case 0:
                isEmojiCollection = false
            case 1:
                isEmojiCollection = true
            default:
                break
        }
        self.collectionView.reloadData()
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _library.pointClouds.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! emojiCollectionViewCell
        
        if(viewOptionSegmentedControl.selectedSegmentIndex == 0){
            cell.emojiLabel.text = _library.pointClouds[indexPath.row].name
            cell.gestureView.isHidden = true
            cell.emojiLabel.isHidden = false
        } else {
            cell.drawingCanvas = PointDisplayCanvas(frame: cell.gestureView.bounds)
            cell.drawingCanvas?.drawPointCloud(drawingPoints: _library.pointClouds[indexPath.row]._points)
            cell.drawingCanvas!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.gestureView.addSubview(cell.drawingCanvas!)
            cell.gestureView.isHidden = false
            cell.emojiLabel.isHidden = true
        }

        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
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
