//
//  serves.swift
//  PongTally
//
//  Created by Alek Vasek on 4/21/25.
//

import Foundation
import SwiftData
import UIKit

@Model
class serves {
    var name: String
    @Attribute(.transformable(by: UIColorValueTransformer.self)) var textColor: UIColor
    @Attribute(.transformable(by: UIColorValueTransformer.self)) var backgroundColor: UIColor
    var id: String
    var win: Int
    var loss: Int
    var currentScore: Int
    
    
    init(name: String = "Team", textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.white, id: String = UUID().uuidString, win: Int = 0, loss: Int = 0, currentScore: Int = 0) {
        self.name = name
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.id = id
        self.win = win
        self.loss = loss
        self.currentScore = currentScore
    }
}
