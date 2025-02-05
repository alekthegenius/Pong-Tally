//
//  scoreboardviewmodel.swift
//  Pong Tally
//
//  Created by Alek Vasek on 1/12/25.
//

import Foundation
import SwiftUICore
import Speech

class ScoreboardViewModel: ObservableObject {
    
    
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private let audioSession = AVAudioSession.sharedInstance()

    
    private var lastProcessedCommand: String = ""
    private var lastCommandTime: Date = Date.distantPast
    
    private var inactivityTimer: Timer?
    private let timeoutInterval: TimeInterval = 2.0

    
    @Published var team1Score: Int = 0
    @Published var team2Score: Int = 0
    @Published var team1Name: String = "Team 1"
    @Published var team2Name: String = "Team 2"
    
    @Published var team1Color: Color = Color.red
    @Published var team2Color: Color = Color.blue
    
    
    @Published var gamePoint: Int = 11
    @Published var gameOver: Bool = false
    
    @Published var winByTwo: Bool = true
    
    @Published var speechRecognitionStatus: Bool = false
    @Published var speechRecognitionAuthorized: Bool = false
    
    

    
    init() {
        requestSpeechAuthorization()

    }
    
    deinit {
        stopListening()
    }

    
    func resetScore() {
        team1Score = 0
        team2Score = 0
    }
    
    
    func increaseTeam1() {
        team1Score += 1
    }
    
    func decreaseTeam1() {
        if team1Score > 0 {
            team1Score -= 1
        }
    }
    
    func increaseTeam2() {
        team2Score += 1
    }
    
    func decreaseTeam2() {
        if team2Score > 0 {
            team2Score -= 1
        }
    }
    
    
    func setTeamName (team: Int, name: String) {
        if team == 1 {
            team1Name = name
        } else {
            team2Name = name
        }
    }
    
    func startListening() {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        

        
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session error: \(error)")
            return
        }
        
        let inputNode = audioEngine.inputNode
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        //recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = false
        


        
        guard speechRecognitionAuthorized else {
            print("Speech recognition not authorized")
            return
        }
        

        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            print("Start Listening")
            if let result = result {
                // Update the text view with the results.
                
                let command  = result.bestTranscription.formattedString.lowercased()
                isFinal = result.isFinal
                print("command: \(command)")
                self.processCommand(command)

                
                
                
                
            }
            
            if error != nil {
                //self.stopListening()
                //self.speechRecognitionStatus = false
                
                print("ERROR")
                print(error ?? "error text")
                self.stopListening()
                
                return
                
            } else if isFinal {
                self.stopListening()
                
                self.startListening()
                
                
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }


        audioEngine.prepare()
        
        
        do {
            try audioEngine.start()
        } catch {
            print("Engine start failed: \(error)")
            return
        }
           
    }
    
    func stopListening() {
        print("Stop Listening")
        

        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionRequest?.endAudio()
        
        do {
           try audioSession.setActive(false)
        } catch {
           print("Deactivation error: \(error)")
        }
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
        

    }
    
    private func resetRecognition() {
        stopListening()
        startListening()
        lastProcessedCommand = ""
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in


           // The authorization status results in changes to the
           // app’s interface, so process the results on the app’s
           // main queue.
              OperationQueue.main.addOperation {
                 switch authStatus {
                    case .authorized:
                     self.speechRecognitionAuthorized = true


                    case .denied:
                     self.speechRecognitionAuthorized = false

                    case .restricted:
                       self.speechRecognitionAuthorized = false


                    case .notDetermined:
                     self.speechRecognitionAuthorized = false
                 default:
                     self.speechRecognitionAuthorized = false
                 }
              }
           }
    }
    
    func processCommand(_ text: String) {

        
        let newCommand = text.replacingOccurrences(of: lastProcessedCommand, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !newCommand.isEmpty else { return }
        
        
        print("Processing new command: \(newCommand)")
        
        
        
        let convertedTeam1 = convertDigitsToWords(team1Name).lowercased()
        let convertedTeam2 = convertDigitsToWords(team2Name).lowercased()
        
        print(convertedTeam1)
        print(convertedTeam2)
        

        


        switch newCommand.lowercased() {
        case let str where str.contains("\(convertedTeam1) score"):
            self.increaseTeam1()
            lastProcessedCommand = text
            
        case let str where str.contains("\(convertedTeam2) score"):
            self.increaseTeam2()
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
            
        case let str where str.contains("set game point to"):
            if let number = str.components(separatedBy: " ").last {
                self.gamePoint = Int(number) ?? 21
            }
            lastProcessedCommand = text
            
        case let str where str.contains("end game"):
            self.resetScore()
            gameOver = true
            lastProcessedCommand = text
            
        case let str where str.contains("stop voice commands"):
            self.speechRecognitionStatus = false
            self.stopListening()
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
