import UIKit

struct MatchResult {
    let name:String
    let score:Double
    
    init(name:String, score:Double) {
        self.name = name
        self.score = score
    }
}