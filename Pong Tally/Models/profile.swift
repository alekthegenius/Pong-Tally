//
//  profile.swift
//  PongTally
//
//  Created by Alek Vasek on 4/20/25.
//

import Foundation
import SwiftData
import UIKit

@Model
class Profile {
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

@objc(UIColorValueTransformer)
final class UIColorValueTransformer: ValueTransformer {

    override class func transformedValueClass() -> AnyClass {
        return UIColor.self
    }

    // return data
    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }

    // return UIColor
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
    
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
            return color
        } catch {
            return nil
        }
    }
}
