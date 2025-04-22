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
    @Published var team1WakeWord: String = "Team 1"
    @Published var team2WakeWord: String = "Team 2"
    
    @Published var team1Name: String = ""
    @Published var team2Name: String = ""
    
    @Published var screenActivityMode: Int = 1
    
    @Published var gamePoint: Int {
        didSet {
            UserDefaults.standard.set(gamePoint, forKey: "gamePoint")
        }
    }
    
    @Published var gameOver: Bool {
       didSet {
           UserDefaults.standard.set(gameOver, forKey: "gameOver")
       }
   }
    
    @Published var winByTwo: Bool {
        didSet {
            UserDefaults.standard.set(winByTwo, forKey: "winByTwo")
        }
    }
    
    @Published var gameWinner: String {
        didSet {
            UserDefaults.standard.set(gameWinner, forKey: "gameWinner")
        }
    }
    
    @Published var speechRecognitionStatus: Bool = false
    @Published var speechRecognitionAuthorized: Bool = false
    @Published var microphoneAuthorized: Bool = false
    
    
    @Published var servingTeam: Int {
       didSet {
           UserDefaults.standard.set(servingTeam, forKey: "servingTeam")
       }
   }
    
    @Published var servingIndicators: Bool {
        didSet {
            UserDefaults.standard.set(servingIndicators, forKey: "servingIndicators")
        }
    }
    
    @Published var servesPerServer: Int {
        didSet {
            UserDefaults.standard.set(servesPerServer, forKey: "servesPerServer")
        }
    }
    
    @Published var currentNumberOfServes: Int {
        didSet {
            UserDefaults.standard.set(currentNumberOfServes, forKey: "currentNumberOfServes")
        }
    }
    
    
    var lastProcessedCommand = ""
    
    
    
    init() {
        
        
        
        
        if UserDefaults.standard.object(forKey: "gamePoint") != nil {
            self.gamePoint = UserDefaults.standard.integer(forKey: "gamePoint")
        } else {
            self.gamePoint = 11
        }
        
        if UserDefaults.standard.object(forKey: "gameOver") != nil {
            self.gameOver = UserDefaults.standard.bool(forKey: "gameOver")
        } else {
            self.gameOver = false
        }
        
        if UserDefaults.standard.object(forKey: "winByTwo") != nil {
            self.winByTwo = UserDefaults.standard.bool(forKey: "winByTwo")
        } else {
            self.winByTwo = true
        }
        
        if UserDefaults.standard.object(forKey: "gameWinner") != nil {
            self.gameWinner = UserDefaults.standard.string(forKey: "gameWinner") ?? "Failed To Retrieve Name"
        } else {
            self.gameWinner = ""
        }
        
        
        
        if UserDefaults.standard.object(forKey: "servingTeam") != nil {
            self.servingTeam = UserDefaults.standard.integer(forKey: "servingTeam")
        } else {
            self.servingTeam = 1
        }
        
        if UserDefaults.standard.object(forKey: "servingIndicators") != nil {
            self.servingIndicators = UserDefaults.standard.bool(forKey: "servingIndicators")
        } else {
            self.servingIndicators = true
        }
        
        if UserDefaults.standard.object(forKey: "servesPerServer") != nil {
            self.servesPerServer = UserDefaults.standard.integer(forKey: "servesPerServer")
        } else {
            self.servesPerServer = 2
        }
        
        if UserDefaults.standard.object(forKey: "currentNumberOfServes") != nil {
            self.currentNumberOfServes = UserDefaults.standard.integer(forKey: "currentNumberOfServes")
        } else {
            self.currentNumberOfServes = 0
        }
        
        
        
        
        
        
        
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
        currentNumberOfServes = 0
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
        
        if (team1Score >= gamePoint){
            if winByTwo && ((team1Score - team2Score) >= 2){
                
                gameWinner = team1Name
                gameOver = true
                
                currentNumberOfServes = 0
            } else if !winByTwo {
                gameWinner = team1Name
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
        
        if (team2Score >= gamePoint){
            if winByTwo && ((team2Score - team1Score) >= 2){
                
                gameWinner = team2Name
                gameOver = true
                currentNumberOfServes = 0
            } else if !winByTwo {
                gameWinner = team2Name
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
        }
    }
    
    
    func setTeamName (team: Int, name: String) {
        if team == 1 {
            team1WakeWord = name
        } else {
            team2WakeWord = name
        }
    }
    
   
    func processCommand(_ text: String) {

        
        let newCommand = text.replacingOccurrences(of: lastProcessedCommand, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        guard !newCommand.isEmpty else { return }
        
        
        
        
        
        
        
        //print("Processing new command: \(newCommand)")
        
        
        
        let convertedTeam1 = convertDigitsToWords(team1WakeWord).lowercased()
        let convertedTeam2 = convertDigitsToWords(team2WakeWord).lowercased()
        
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
                    
                    gameWinner = team2Name
                    gameOver = true
                } else if !winByTwo {
                    gameWinner = team2Name
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


