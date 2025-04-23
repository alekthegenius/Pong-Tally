//
//  game.swift
//  PongTally
//
//  Created by Alek Vasek on 4/21/25.
//

import Foundation
import SwiftData
import UIKit

@Model
class Game {
    var winningTeamName: String
    var losingTeamName: String
    
    var winningTeamScore: Int
    var losingTeamScore: Int
    
    var gameDate: Date
    
    
    init(winningTeamName: String = "", losingTeamName: String = "", winningTeamScore: Int = 0, losingTeamScore: Int = 0, gameDate: Date = .now) {
        self.winningTeamName = winningTeamName
        self.losingTeamName = losingTeamName
        self.winningTeamScore = winningTeamScore
        self.losingTeamScore = losingTeamScore
        self.gameDate = gameDate
    }
}
