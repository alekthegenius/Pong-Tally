//
//  MiddleBarView.swift
//  PongTally
//
//  Created by Alek Vasek on 4/20/25.
//

import SwiftUI

struct MiddleBarView: View {
    @EnvironmentObject var viewModel: MainViewViewModel
    
    @ObservedObject var speechRecognizer: SpeechRecognizer
    
    @Binding var isSettingsMenuShown: Bool
    
    @Binding var showDictationText: Bool
    
    @Binding var isHelpMenuShown: Bool
    
    @Binding var isServerNumberEditing: Bool
    @Binding var newServerNumber: String
    
    @Binding var showingMicPrivacyAlert: Bool
    
    @State private var isShowingHistoryView: Bool = false
    
    @Binding var isRecording: Bool
    
    @Binding var isGamePointEditing: Bool
    
    @Binding var newGamePoint: String
    
    var body: some View {
        ZStack {
            
            Color.white
            
            HStack() { // Align Menu Bar Items
                
                Spacer()
                
                Button { // Help Menu Buttons
                    isHelpMenuShown = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.clear)
                            .strokeBorder(.black, lineWidth: 2)
                            
                        
                        Text("Help")
                            .font(.system(size: 15))
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            
                    }
                    
                }
                .frame(width: 60, height: 35)
                .sheet(isPresented: $isHelpMenuShown) {
                    HelpMenuView()
                }
                
                Spacer()
                
                Button { // Settings Button
                    isSettingsMenuShown = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 25))
                        .foregroundColor(Color.black)

                }
                .sheet(isPresented: $isSettingsMenuShown) {
                    SettingsView(isGamePointEditing: $isGamePointEditing, newGamePoint: $newGamePoint, isServerNumberEditing: $isServerNumberEditing, newServerNumber: $newServerNumber, showDictationText: $showDictationText)
                        .environmentObject(viewModel)
                }
                
                Spacer()
                
                Button { // Settings Button
                    isShowingHistoryView = true
                } label: {
                    Image(systemName: "list.bullet.clipboard")
                        .font(.system(size: 25))
                        .foregroundColor(Color.black)

                }
                .sheet(isPresented: $isShowingHistoryView) {
                    HistoryView()
                        .environmentObject(viewModel)
                }
                
                Spacer()
                
                Button { // Speech Recognition Toggle Button
                    
                    if !speechRecognizer.speechRecognitionAuthorized || !speechRecognizer.microphoneAuthorized {
                        showingMicPrivacyAlert = true
                    } else {
                        if isRecording {
                            speechRecognizer.stopTranscribing()
                            isRecording.toggle()
                        } else {
                            speechRecognizer.startTranscribing()
                            isRecording.toggle()
                            
                        }
                    }
                    
                    
                    

                    
                    //print("Speech Status: \(isRecording)")
                    //print("Speech Authorization Status: \(speechRecognizer.speechRecognitionAuthorized)")
                    //print("Mic Authorization Status: \(speechRecognizer.microphoneAuthorized)")
                    
                } label: {
                    Image(systemName: (isRecording && speechRecognizer.speechRecognitionAuthorized && speechRecognizer.microphoneAuthorized) ? "microphone.fill" : "microphone.slash")
                        .font(.system(size: 25))
                        .foregroundColor((isRecording && speechRecognizer.speechRecognitionAuthorized && speechRecognizer.microphoneAuthorized) ? Color.red : Color.black)
                    
                }
                .opacity(speechRecognizer.speechRecognitionAuthorized && speechRecognizer.microphoneAuthorized ? 1 : 0.5)
                
                
                Spacer()
                
                Button { // Restart Game Button
                    
                    viewModel.currentNumberOfServes = 0
                    viewModel.resetScore()
                   
                } label: {
                    Image(systemName: "arrow.circlepath")
                        .font(.system(size: 25))
                        .foregroundColor(Color.black)
                }
                
                Spacer()
                
                Button { // Duce Toggle Button
                    viewModel.winByTwo.toggle()
                } label: {
                    if viewModel.winByTwo {
                        Image(systemName: "circlebadge.2.fill")
                            .font(.system(size: 25))
                            .foregroundColor(Color.black)
                    } else {
                        Image(systemName: "circlebadge.2")
                            .font(.system(size: 25))
                            .foregroundColor(Color.black)
                    }
                    
                }
                
                Spacer()
                
            }
            
            
        }
    }
    
    
}

#Preview {
    MiddleBarView(speechRecognizer: SpeechRecognizer(), isSettingsMenuShown: .constant(false), showDictationText: .constant(false), isHelpMenuShown: .constant(false), isServerNumberEditing: .constant(false), newServerNumber: .constant(""), showingMicPrivacyAlert: .constant(false), isRecording: .constant(false), isGamePointEditing: .constant(false), newGamePoint: .constant(""))
        .environmentObject(MainViewViewModel())
}
