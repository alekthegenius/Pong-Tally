//
//  SpeechRecognizer.swift
//  PongTally
//
//  Created by Alek Vasek on 3/25/25.
//

import Foundation
import SwiftUICore
import Speech
import AVFoundation


class SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        public var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    @MainActor @Published public var transcript: String = ""
    
    @Published public var speechRecognitionAuthorized: Bool = true
    @Published public var microphoneAuthorized: Bool = true
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    
    /**
     Initializes a new speech recognizer. If this is the first time you've used the class, it
     requests access to the speech recognizer and the microphone.
     */
    init()  {
        //print("Initalizing SpeechRecognizer")
        
        recognizer = SFSpeechRecognizer()
        guard recognizer != nil else {
            transcribe(RecognizerError.nilRecognizer)
            return
        }
        
            
        Task() {
            do {
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
                
                
            } catch {
                transcribe(error)
            }
        }
        
    }
        
    @MainActor public func startTranscribing() {
        //print("Starting Transciption")
        transcribe()
        
    }
    
    @MainActor public func resetTranscript() {
        //print("Resetting Transcription")
        reset()
        
    }
    
    @MainActor public func stopTranscribing() {
        //print("Stopping Transciption")
        reset()
        
    }
    
    
    
    func transcribe() {
        guard let recognizer, recognizer.isAvailable else {
            self.transcribe(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        do {
            let (audioEngine, request) = try Self.prepareEngine()
            self.audioEngine = audioEngine
            self.request = request
            self.task = recognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                self?.recognitionHandler(audioEngine: audioEngine, result: result, error: error)
            })
        } catch {
            self.reset()
            self.transcribe(error)
        }
    }
    
    /// Reset the speech recognizer.
    private func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    private func recognitionHandler(audioEngine: AVAudioEngine, result: SFSpeechRecognitionResult?, error: Error?) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        
        if receivedFinalResult || receivedError {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        if let result {
            transcribe(result.bestTranscription.formattedString)
        }
    }
    
    
    private func transcribe(_ message: String) {
        Task { @MainActor in
            transcript = message
            //print(transcript)
        }
        
    }
    
    private func transcribe(_ error: Error) {
        var errorType = ""
        //print(error.localizedDescription)
        if let error = error as? RecognizerError {
            if error.message == "Not authorized to recognize speech" {
                errorType = "speech_permission"
            } else if error.message == "Not permitted to record audio" {
                errorType = "mic_permission"
            } else {
                errorType = "other"
            }
        } else {
            if error.localizedDescription == "Not authorized to recognize speech" {
                errorType = "speech_permission"
            } else if error.localizedDescription == "Not permitted to record audio" {
                errorType = "mic_permission"
            } else {
                errorType = "other"
            }
        }
        Task { @MainActor [errorType] in
            switch errorType {
                case "speech_permission":
                self.speechRecognitionAuthorized = false
                case "mic_permission":
                self.microphoneAuthorized = false
            default:
                break
            }
        }
    }
    
}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
