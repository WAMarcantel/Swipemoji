//
//  PDollarRecognizer.swift
//  
//
//  Created by William Marcantel on 2/8/17.
//
//

import Foundation
import Darwin


//point class for building points
class Point {
    var X: double
    var Y: double
    var ID: int
    
}


//main recognizer used to actually recognize the input
class PDollarRecognizer{
    
    var numPoints = 32
    var pointOrig = Point(X:0, Y:0, ID:0)
    var PntClouds: Array<PointCloud> = Array()
    
    class PointCloud{
        var Points: Array<Point> = Array()
        var name: String
        init(buildPointCloud PointCloudName: String, PointArray: Array<Point>){
            name = PointCloudName;
            Points = PointArray;
            
            Points = PDollarRecognizer.Resample(Points, numPoints);
            Points = PDollarRecognizer.Scale(Points);
            Points = PDollarRecognizer.TranslateTo(Points, pointOrig);
        }
    }
    
    func Recognize(points: Array<Point>){
        var foundPointCloud: PointCloud = nil
        points = Resample(points:points, n:mNumPoints)
        points = Scale(points:points)
        points = TranslateTo(points:points, origin:pointOrig)
        
        var score = Double.infinity
        for i in [0..PntClouds.size]{
            var distScore = GreedyCloudMatch(points, PntClouds[i])
            if(distScore < score){
                score = distScore
                foundPointCloud = PntClouds[i]
            }
        }
        if(foundPointCloud == nil){
            var res = RecognizerResults("No Match.", 0.0)
        }
        else{
            var res = RecognizerResults(foundPointCloud.name, max((score - 2.0)/ (-2.0), 0.0),"score: "+score+"\n")
            
        }
        
    }
    
    func initializePointCloudTable(n: int){
        //come back here later
        //consider replacing with averaged, weighted approach
    }
    
    func addGesture(name: String, points: Array<Point>){
        var newPointCloud = PointCloud(name:name, Points:points)
        PntClouds.append(newPointCloud)
        var num = 0
        for i in [0..PntClouds.count]{
            if(PntClouds[i].name == name){
                num++
            }
        }
        return num
    }
    
    func GreedyCloudMatch(points: Array<Point>, pntCloud: PointCloud){
        var e = 0.50
        var step = floor(pow(points.count, 1-e))
        var min = Double.infinity
        for i in 0.stride(to: points.count, by: step){
            var d1 = CloudDistance(points, pntCloud.Points, i)
            var d2 = CloudDistance(pntCloud.Points, points, i)
            min = min(min, min(d1,d2))
        }
        return min
    }
    
    func CloudDistance(pts1: Array<Point>, pts2: Array<Point>, start: int){
        var matched: Array<bool>
        for i in [0..pts1.count]{
            matched[k] = false
        }
        var sum = 0
        var i = start
        repeat{
            var index = -1
            var min = Double.infinity
            for j in [0..matched.count]{
                if(!matched[j]){
                    var d = EuclideanDistance(pts1.get(i), pts2.get(j))
                    if(d < min){
                        min = d
                        index = j
                    }
                }
            }
            matched[index] = true
            var weight = 1 - ((i-start + pts1.count) % pts1.count) / pts1.count
            sum += weight * min
            i = (i + 1) % pts1.count
        }while(i != start)
        
        return sum
    }
    
    func Resample(points: Array<Points>, n: int){
        var I = PathLength(points) / (n-1)
        var D = 0.0
        
        var newPoints: Array<Point>
        newPoints.append(points[0])
        
        for i in 1..(points.count - 1) {
            if(points[i].ID == points[i-1].ID){
                var d = EuclideanDistance(points[i-1], points[i])
                if((D + d) >= I){
                    var qx = points[i-1].X + ((I-D) / d) * (points.get(i).X - points.get(i-1).X)
                    var qy = points[i-1].Y + ((I-D) / d) * (points.get(i).Y - points.get(i-1).Y)
                    var q = Point(X:qx, Y:qy, ID:points[i].ID)
                    newPoints.append(q)
                    points.append(i,q) // may be wrong with i being a point not index
                                       // refer to java code
                    D = 0.0
                }
                else{
                    D += d
                }
            }
        }
        
        if(newPoints.count == n-1){
            var roundOffPoint = Point(points[points.count-1].X, points[points.count-1].Y, points[points.count-1].ID)
            newPoints.append(roundOffPoint)
        }
        
        return newPoints
        
    }
    
    func Scale(points: Array<Point>){
        var minX = -Double.infinity
        var maxX = Double.infinity
        var minY = -Double.infinity
        var maxY = Double.infinity
        for i in [0..(points.count)]{
            minX = min(minX, points[i].X)
            maxX = max(maxX, points[i].X)
            minY = min(minY, points[i].Y)
            minX = max(maxY, points[i].Y)
        }
        
        var size = max(maxX - minX, maxY - minY)
        var newPoints: Array<Point>
        
        for i in [0..(points.count)]{
            var qx = (points[i].X - minX) / size
            var qy = (points[i].Y - minY) / size
            var p = Point(X:qx, Y:qy, points[i].ID)
            newPoints.append(p)
        }
        
    }
    
    func TranslateTo(points: Array<Point>, origin: Point){
        var c = Centroid(points)
    }
    
    func Centroid(points: Array<Point>){
        var x = 0.0
        var y = 0.0
        
        for i in [0..points.count]{
            x += points[i].X
            y += points[i].Y
        }
        
        x /= points.count
        y /= points.count
        var p = Point(X:x, Y:y, ID:0)
        return p
        
    }
    
    func PathDistance(pts1: Array<Point>, pts2: Array<Point>){
        var d = 0.0
        for i in [0..pts.count]{
           d += EuclideanDistance(pts1[i], pts2[i])
        }
        return d / pts.count
    }
    
    func PathLength(points: Array<Point>){
        var d = 0.0
        for i in [1..points.count]{
            if(points[i].ID == points[i-1].ID){
                d += EuclideanDistance(points[i-1], points[i])
            }
        }
        return d
    }
    
    func EuclideanDistance(p1: Point, p2: Point){
        var dx = p2.X - p1.X;
        var dy = p2.Y - p1.Y;
        return pow((dx*dx + dy*dy),0.5);
    }
    
}


//results class, this is the output of the recognizer
class RecognizerResults{
    var name = ""
    var score = 0
    var otherInfo: String?
    init(){
        
    }
    
}
