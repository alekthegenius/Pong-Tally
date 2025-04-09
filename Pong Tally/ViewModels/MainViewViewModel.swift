//
//  MainViewViewModel.swift.swift
//  Pong Tally
//
//  Created by Alek Vasek on 1/12/25.
//

import Foundation
import SwiftUICore
import Speech
import SwiftUI

class MainViewViewModel: ObservableObject {
    
    
    @Published var team1Score: Int = 0
    @Published var team2Score: Int = 0
    @Published var team1Name: String = "Team 1"
    @Published var team2Name: String = "Team 2"
    
    @Published var screenActivityMode: Int = 1
    
    @Published var team1Color: Color = Color(UIColor(red: 209/255, green: 253/255, blue: 255/255, alpha: 1.0))
    @Published var team2Color: Color = Color(UIColor(red: 255/255, green: 31/255, blue: 86/255, alpha: 1.0))
    
    
    @Published var gamePoint: Int = 11
    @Published var gameOver: Bool = false
    
    @Published var winByTwo: Bool = true
    
    @Published var speechRecognitionStatus: Bool = false
    @Published var speechRecognitionAuthorized: Bool = false
    @Published var microphoneAuthorized: Bool = false
    
    
    @Published var gameWinner: Int = 0
    
    @Published var showTeam1BackButton = false
    @Published var showTeam2BackButton = false
    
    @Published var text1Color: Color = Color(UIColor(red: 27/255, green: 93/255, blue: 215/255, alpha: 1.0))
    @Published var text2Color: Color = Color(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0))
    
    
    
    @Published var servingTeam: Int = 1
    @Published var servingIndicators: Bool = true
    @Published var servesPerServer: Int = 2
    @Published var currentNumberOfServes: Int = 0
    
    var lastProcessedCommand = ""
    
    
    
    init() {
        changeScreenMode(screenMode: 1)
        
        
        
    }
    
    
    
        
    func changeScreenMode(screenMode: Int) {
        screenActivityMode = screenMode
        if screenMode == 1 {
            UIApplication.shared.isIdleTimerDisabled = true
            
        } else {
            UIApplication.shared.isIdleTimerDisabled = false
            
        }
        
    }

    
    func resetScore() {
        team1Score = 0
        team2Score = 0
    }
    
    
    func increaseTeam1() {
        team1Score += 1
        
        if (team1Score >= gamePoint - 1) && (team2Score >= gamePoint - 1){  // Check for Duce
            
            if team1Score > team2Score {
                
                servingTeam = 2
            } else if team2Score > team1Score {
                
                servingTeam = 1
            } else {
                servingTeam = servingTeam == 1 ? 2 : 1
            }
            
        } else if (team1Score == gamePoint - 1) && !(team2Score == gamePoint - 1) {
            servingTeam = 2
        } else if (team2Score == gamePoint - 1) && !(team1Score == gamePoint - 1) {
            servingTeam = 1
        } else {
            if currentNumberOfServes < servesPerServer {
                currentNumberOfServes += 1
            }
            
            if currentNumberOfServes == servesPerServer {
                currentNumberOfServes = 0
                servingTeam = servingTeam == 1 ? 2 : 1
            }
        }
        
        if team1Score > 0 {
            showTeam1BackButton = true
        }
        
        if (team1Score >= gamePoint){
            if winByTwo && ((team1Score - team2Score) >= 2){
                
                gameWinner = 1
                showTeam1BackButton = false
                showTeam2BackButton = false
                gameOver = true
                
                currentNumberOfServes = 0
            } else if !winByTwo {
                gameWinner = 1
                showTeam1BackButton = false
                showTeam2BackButton = false
                gameOver = true
                currentNumberOfServes = 0
            }
        }
    }
    
    func decreaseTeam1() {
        
        
        if team1Score > 0 {
            team1Score -= 1
            
            //print(currentNumberOfServes)
            
            if currentNumberOfServes > 0 {
                currentNumberOfServes -= 1
            } else if currentNumberOfServes == 0 {
                servingTeam = servingTeam == 1 ? 2 : 1
                currentNumberOfServes = servesPerServer - 1
            }
        } else {
            showTeam1BackButton = false
        }
        
        if team1Score == 0 {
            showTeam1BackButton = false
        }
    }
    
    func increaseTeam2() {
        team2Score += 1
        
        if (team1Score >= gamePoint - 1) && (team2Score >= gamePoint - 1){ // Check for Duce
            
            if team1Score > team2Score {
                
                servingTeam = 2
            } else if team2Score > team1Score {
                
                servingTeam = 1
            } else {
                servingTeam = servingTeam == 1 ? 2 : 1
            }
            
        } else if (team1Score == gamePoint - 1) && !(team2Score == gamePoint - 1) {
            servingTeam = 2
        } else if (team2Score == gamePoint - 1) && !(team1Score == gamePoint - 1) {
            servingTeam = 1
        } else {
            if currentNumberOfServes < servesPerServer {
                currentNumberOfServes += 1
            }
            
            if currentNumberOfServes == servesPerServer {
                currentNumberOfServes = 0
                servingTeam = servingTeam == 1 ? 2 : 1
            }
        }
        
        if team2Score > 0 {
            showTeam2BackButton = true
        }
        
        if (team2Score >= gamePoint){
            if winByTwo && ((team2Score - team1Score) >= 2){
                
                gameWinner = 2
                showTeam1BackButton = false
                showTeam2BackButton = false
                gameOver = true
                currentNumberOfServes = 0
            } else if !winByTwo {
                gameWinner = 2
                showTeam1BackButton = false
                showTeam2BackButton = false
                gameOver = true
                currentNumberOfServes = 0
            }
        }
        
    }
    
    func decreaseTeam2() {

        
        if team2Score > 0 {
            team2Score -= 1
            
            //print(currentNumberOfServes)
            
            if currentNumberOfServes > 0 {
                currentNumberOfServes -= 1
            } else if currentNumberOfServes == 0 {
                servingTeam = servingTeam == 1 ? 2 : 1
                currentNumberOfServes = servesPerServer - 1
            }
        } else {
            showTeam2BackButton = false
        }
        
        if team2Score == 0 {
            showTeam2BackButton = false
        }
    }
    
    
    func setTeamName (team: Int, name: String) {
        if team == 1 {
            team1Name = name
        } else {
            team2Name = name
        }
    }
    
   
    func processCommand(_ text: String) {

        
        let newCommand = text.replacingOccurrences(of: lastProcessedCommand, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        guard !newCommand.isEmpty else { return }
        
        
        
        
        
        
        
        //print("Processing new command: \(newCommand)")
        
        
        
        let convertedTeam1 = convertDigitsToWords(team1Name).lowercased()
        let convertedTeam2 = convertDigitsToWords(team2Name).lowercased()
        
        //print(convertedTeam1)
        //print(convertedTeam2)
        

        


        switch newCommand.lowercased() {
        case let str where str.contains("\(convertedTeam1) score"):
            
            self.increaseTeam1()
            
            lastProcessedCommand = text
            
            
        case let str where str.contains("\(convertedTeam2) score"):
            self.increaseTeam2()
            if (team2Score >= gamePoint){
                if winByTwo && ((team2Score - team1Score) >= 2){
                    
                    gameWinner = 2
                    gameOver = true
                    showTeam1BackButton = false
                    showTeam2BackButton = false
                } else if !winByTwo {
                    gameWinner = 2
                    gameOver = true
                }
            }
            lastProcessedCommand = text
            
            
        case let str where str.contains("\(convertedTeam1) loss"):
            self.decreaseTeam1()
            lastProcessedCommand = text
            
            
        case let str where str.contains("\(convertedTeam2) loss"):
            self.decreaseTeam2()
            lastProcessedCommand = text
            
            
        case let str where str.contains("restart game"):
            self.resetScore()
            lastProcessedCommand = text

            
        default:
            break

        }
        
    }
    
    
    func convertDigitsToWords(_ text: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        let words = text.components(separatedBy: " ").map { word in
            if let number = Int(word) {
                return formatter.string(from: NSNumber(value: number)) ?? word
            }
            return word
        }
        
        
        return words.joined(separator: " ")
    }
    
}


