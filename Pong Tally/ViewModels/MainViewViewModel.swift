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
    
    
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private let audioSession = AVAudioSession.sharedInstance()

    
    private var lastProcessedCommand: String = ""
    private var lastCommandTime: Date = Date.distantPast
    



    
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
    
    @Published var dictatedText: String = ""
    
    
    @Published var servingTeam: Int = 1
    @Published var servingIndicators: Bool = true
    @Published var servesPerServer: Int = 2
    @Published var currentNumberOfServes: Int = 0
    
    
    

    
    
    
    

    
    init() {
        requestSpeechAuthorization()
        changeScreenMode(screenMode: 1)

    }
    
    deinit {
        stopListening()
        

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
        print("Start Listening")
        guard !audioEngine.isRunning else { return }
        guard speechRecognitionStatus else { return }
        
        guard speechRecognitionAuthorized else { return }
        
        guard microphoneAuthorized else { return }
        
        
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
        


        
        
        
        
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if error != nil {
                if let error = error as NSError? {
                    print("ERROR: \(error)")
                    // Handle specific error codes
                    if error.code == 1110 || error.code == 301 {
                        
                    } else {
                        self.stopListening()
                        return
                    }
                    
                }
                
            }
            
            print("Recongition Task Active")
            var isFinal = false
            

            
            
            if let result = result {
                // Update the text view with the results.
                
                let command  = result.bestTranscription.formattedString.lowercased()
                isFinal = result.isFinal
                print("command: \(command)")
                
                self.processCommand(command)
                
                

                
                
                
                
            }
            
           
            if isFinal {
                self.stopListening()
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    
                    self.startListening()
                    
                }
                
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
        self.recognitionTask?.cancel()

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
    
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in


       // The authorization status results in changes to the
       // app’s interface, so process the results on the app’s
       // main queue.
          OperationQueue.main.addOperation {
             switch authStatus {
                case .authorized:
                 self.speechRecognitionAuthorized = true

             default:
                 self.speechRecognitionAuthorized = false
             }
          }
       }
        
        // Request permission to record.
        if #available(iOS 17.0, *) {
            Task { @MainActor in
                self.microphoneAuthorized = await AVAudioApplication.requestRecordPermission()
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                OperationQueue.main.addOperation {
                    self.microphoneAuthorized = granted
                }
            }
        }
        
    }
    
    func processCommand(_ text: String) {

        
        let newCommand = text.replacingOccurrences(of: lastProcessedCommand, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        guard !newCommand.isEmpty else { return }
        
        let lastWord = newCommand.split(separator: " ").last
        
        
        dictatedText.append(" " + (lastWord ?? "") + " ")
        
        
        
        
        print("Processing new command: \(newCommand)")
        
        
        
        let convertedTeam1 = convertDigitsToWords(team1Name).lowercased()
        let convertedTeam2 = convertDigitsToWords(team2Name).lowercased()
        
        print(convertedTeam1)
        print(convertedTeam2)
        

        


        switch newCommand.lowercased() {
        case let str where str.contains("\(convertedTeam1) score"):
            
            self.increaseTeam1()
            if (team1Score >= gamePoint){
                if winByTwo && ((team1Score - team2Score) >= 2){
                    
                    gameWinner = 1
                    gameOver = true
                    showTeam1BackButton = false
                    showTeam2BackButton = false
                } else if !winByTwo {
                    gameWinner = 1
                    gameOver = true
                }
            }
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


