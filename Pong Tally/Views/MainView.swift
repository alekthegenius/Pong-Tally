//
//  MainView.swift
//  Pong Tally
//
//  Created by Alek Vasek on 1/12/25.
//

import SwiftUI
import ConfettiSwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewViewModel()
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    @State private var newTeamName: String = ""
    
    @State private var isTeam1TitleEditing: Bool = false
    @State private var isTeam1ColorEditing: Bool = false
    
    @State private var isTeam2TitleEditing: Bool = false
    @State private var isTeam2ColorEditing: Bool = false
    
    @State private var isGamePointEditing: Bool = false
    @State private var newGamePoint: String = ""
    
    @State private var isSettingsMenuShown: Bool = false
    
    @State private var showDictationText: Bool = true
    
    @State private var isHelpMenuShown: Bool = false
    
    @State private var isServerNumberEditing: Bool = false
    @State private var newServerNumber: String = ""
    
    @State private var showingMicPrivacyAlert: Bool = false
    
    
    @State private var isRecording: Bool = false
    
    
    
    let heavyhapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    

    

    
    
    var body: some View {
        
        
        ZStack { // Allows for the Use of Overlays
            
            VStack() { // Aligns Main Three Elements: First Team Board, Menu Bar, and Second Team Board
                
                ZStack { // First Team Board
                    Color.white
                        .ignoresSafeArea()
                    
                    Button { // Background Button to Enable Score
                        
                        teamOneScore()
                        
                    } label: {
                        Rectangle()
                            .fill(viewModel.team1Color)
                            .ignoresSafeArea()
                        
                    }
                    
                    VStack() { // Align Board Controls
                        
                        HStack() { // Align Board Header
                            
                            Button { // Team Name
                                newTeamName = viewModel.team1Name
                                isTeam1TitleEditing = true
                            } label:{
                                Text("\(viewModel.team1Name)")
                                    .frame(maxHeight: 45)
                                    .fontWeight(.bold)
                                    .foregroundStyle(viewModel.text1Color)
                                    .font(.system(size:40))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                    
                            }
                            .alert("Change Team Name", isPresented: $isTeam1TitleEditing) {
                                TextField("Enter new team name", text: $newTeamName)
                                Button("Save") {
                                    if !newTeamName.isEmpty {
                                        viewModel.team1Name = newTeamName
                                    }
                                }
                                Button("Cancel", role: .cancel) { }
                            }
                            
                            Spacer()
                            
                            Button { // Color Settings Button
                                isTeam1ColorEditing = true
                            } label: {
                                Circle()
                                    .stroke(viewModel.text1Color, lineWidth: 5)
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .padding(.trailing, 10)
                                    .sheet(isPresented: $isTeam1ColorEditing) {
                                        ColorPickerView(selectedBackgroundColor: $viewModel.team1Color, selectedTextColor: $viewModel.text1Color)
                                    }
                                    
                            }
                            
                        }
                        .padding()
                        
                        Spacer()

                        Text("\(viewModel.team1Score)") // Score Viewer
                            .fontWeight(.heavy)
                            .foregroundStyle(viewModel.text1Color)
                            .font(.system(size:80))
                            .allowsHitTesting(false)
                            .offset(y: -25)
                        
                        
                        
                        Spacer()
                        
                        
                        
                    }
                    .padding(.top, 20)
                    
                    VStack{ // Bottom Header
                        
                        Spacer()
                        
                        HStack { // Align Score Loss Button
                            
                            Spacer()
                            
                            Button { // Score Loss Button
                                viewModel.decreaseTeam1()
                                
                            } label: {
                                Image(systemName: "arrowshape.turn.up.backward")
                                    .font(.system(size: 30))
                                    .foregroundStyle(viewModel.text1Color)
                                    .opacity(viewModel.showTeam1BackButton ? 1 : 0.2)
                                    .disabled(viewModel.showTeam1BackButton)
                            }
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                        }
                        
                       
                    }
                    
                    if viewModel.servingTeam == 1 && viewModel.servingIndicators {
                        VStack {
                            
                            Spacer()
                            
                            Button { // Server Indicator
                                viewModel.servingTeam = 2
                                viewModel.currentNumberOfServes = 0
                            } label: {
                                
                                
                                ZStack {
                                    
                                    Color.clear
                                    
                                    Triangle()
                                        .fill(Color.white.opacity(0.5))
                                        .stroke(viewModel.text1Color, lineWidth: 4)
                                        .frame(width: 120, height: 50)
                                        .offset(y: 2)
                                    
                                    Text(viewModel.currentNumberOfServes.formatted())
                                        .font(.system(size: 25, weight: .medium))
                                        .foregroundStyle(viewModel.text1Color)
                                        .offset(y: 5)
                                    
                                    
                                    
                                }
                                .frame(width: 90, height: 50)
                                .contentShape(Triangle())
                                
                                
                                
                            }
                            .zIndex(2)
                            
                            
                            
                        }
                    }
                }
                
                
                
                
                
                
                
                // Middle Menu Bar
                ZStack() {
                    

                    Color.white // Menu Bar Background
                    
                    
                        
                    
                    
                    HStack() { // Align Menu Bar Items
                        
                        Spacer()
                        
                        Button { // Help Menu Buttons
                            isHelpMenuShown = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.clear)
                                    .strokeBorder(.black, lineWidth: 2)
                                    .frame(width: 100, height: 40)
                                
                                Text("PongTally")
                                    .font(.system(size: 17))
                                    .foregroundColor(Color.black)
                                    .fontWeight(.bold)
                                    
                            }
                            
                        }
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
                            viewModel.showTeam1BackButton = false
                            viewModel.showTeam2BackButton = false
                            
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
                .frame(maxWidth: 500)
                .frame(height: 60) // Keep Constant Menu Bar Height
                .zIndex(3)
                
                
                
                
                ZStack { // Second Team Board
                    Color.white
                        .ignoresSafeArea()
                    
                    Button { // Background Button to Enable Score
                        
                        teamTwoScore()
                        
                    } label: {
                        Rectangle()
                            .fill(viewModel.team2Color)
                            .ignoresSafeArea()
                    }
                    
                        
                    VStack() { // Align Board Controls
                        

                        
                        HStack() { // Align Board Header
                            
                            Button { // Team Name
                                newTeamName = viewModel.team2Name
                                isTeam2TitleEditing = true
                            } label: {
                                Text("\(viewModel.team2Name)")
                                    .frame(maxHeight: 45)
                                    .fontWeight(.bold)
                                    .foregroundStyle(viewModel.text2Color)
                                    .font(.system(size:40))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                    
                            }
                            .alert("Change Team Name", isPresented: $isTeam2TitleEditing) {
                                TextField("Enter new team name", text: $newTeamName)
                                Button("Save") {
                                    if !newTeamName.isEmpty {
                                        viewModel.team2Name = newTeamName
                                    }
                                }
                                Button("Cancel", role: .cancel) { }
                            }
                            
                            Spacer()
                            Button() { // Color Settings Button
                                isTeam2ColorEditing = true
                            } label: {
                                Circle()
                                    .stroke(viewModel.text2Color, lineWidth: 5)
                                    .frame(maxWidth: 40, maxHeight: 40)
                                    .padding(.trailing, 10)
                                    .sheet(isPresented: $isTeam2ColorEditing) {
                                        ColorPickerView(selectedBackgroundColor: $viewModel.team2Color, selectedTextColor: $viewModel.text2Color)
                                    }
                                    .presentationDetents([.medium])
                            }
                            
                        }
                        .padding()
                        
                        Spacer() // Score Viewer
                        Text("\(viewModel.team2Score)")
                            .fontWeight(.heavy)
                            .foregroundStyle(viewModel.text2Color)
                            .font(.system(size:80))
                            .allowsHitTesting(false)
                            .offset(y: -25)
                        
                        
                        Spacer()
                    }
                    
                    VStack { // Bottom Header
                        
                        Spacer()
                        
                        HStack { // Align Score Loss Button
                            
                            Spacer()
                            
                            Button { // Score Loss Button
                                viewModel.decreaseTeam2()
                                
                            } label: {
                                Image(systemName: "arrowshape.turn.up.backward")
                                    .font(.system(size: 30))
                                    .foregroundStyle(viewModel.text2Color)
                                    .opacity(viewModel.showTeam2BackButton ? 1 : 0.2)
                                    .disabled(viewModel.showTeam2BackButton)
                            }
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                            
                        }
                        
                        
                    }
                    
                    if viewModel.servingTeam == 2 && viewModel.servingIndicators {
                        VStack {
                            
                            Button { // Server Indicator
                                viewModel.servingTeam = 1
                                viewModel.currentNumberOfServes = 0
                            } label: {
                                
                                
                                ZStack {
                                    
                                    Color.clear
                                    
                                    Triangle()
                                        .fill(Color.white.opacity(0.5))
                                        .stroke(viewModel.text2Color, lineWidth: 4)
                                        .frame(width: 120, height: 50)
                                        .rotationEffect(Angle(degrees: 180))
                                        .offset(y: -2)
                                    
                                    Text(viewModel.currentNumberOfServes.formatted())
                                        .font(.system(size: 25, weight: .medium))
                                        .foregroundStyle(viewModel.text2Color)
                                        .offset(y: -5)
                                    
                                    
                                    
                                    
                                }
                                .frame(width: 90, height: 50)
                                .contentShape(Triangle())
                                
                                
                            }
                            .zIndex(2)
                            
                            Spacer()
                        }
                    }
                        
                }
  
            
            }
            .onAppear {
                speechRecognizer.resetTranscript()
            }
            .background(.white)
            .alert(isPresented: $showingMicPrivacyAlert) {
                  Alert(title: Text("Permisson Error"),
                        message: Text("Enable Microphone and Speech Recognition under Settings > Privacy. If you believe this is a bug, contact alek@hunacenterprises.com"),
                        primaryButton: .default(Text("Open Settings"), action: {
                              if let settingsURL = URL(string: UIApplication.openSettingsURLString),
                                 UIApplication.shared.canOpenURL(settingsURL) {
                                  UIApplication.shared.open(settingsURL)
                              }
                          }),
                        secondaryButton: .default(Text("Ok"))
                  )
              }
            .sheet(isPresented: $viewModel.gameOver) {
                GameOverView()
                    .environmentObject(viewModel)
            }
            .onChange(of: speechRecognizer.transcript) {
                viewModel.processCommand(speechRecognizer.transcript)
            }
            
            if isRecording == true && showDictationText == true {
                SpeechRecognitionView(dictatedText: $speechRecognizer.transcript)
                
            }
            
            
        }
        
        
        
       
    }
    
    func teamOneScore() {
        heavyhapticGenerator.impactOccurred(intensity: 1)
        viewModel.increaseTeam1()
    }
    
    func teamTwoScore() {
        heavyhapticGenerator.impactOccurred(intensity: 1)
        viewModel.increaseTeam2()
    }
}


struct HelpMenuView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                HStack() {
                    Text("PongTally")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .padding(.top, 25)
                        .foregroundStyle(LinearGradient(colors: [.blue, .red], startPoint: .leading, endPoint: .trailing))
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 3, y: 3)
                    
                    Image("PongTallyIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 85, height: 85)
                        .padding(.top, 25)
                        .padding(.leading, 10)
                        
                        
                }
                
                
                
                    

                    
                ScrollView() {
                    VStack(alignment: HorizontalAlignment.leading, spacing: 10) {
                        buttonContentRow()
                            .foregroundStyle(.black)
                    }
                    
                }
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.clear)
                                .stroke(.black, lineWidth: 2)
                            
                            Text("Dismiss")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                    
                }
                .frame(width: 100, height: 40)
                .padding(.bottom, 15)
                
                
                Spacer()
                
                Divider()
                Text("Written From Texas with ❤️, © 2025 Alek Vasek")
                    .font(.caption)
                    .foregroundStyle(.gray)
                        
                
                
                    
                Text("Version \(getAppVersion())")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 10)
        }
    }
    @ViewBuilder
    func buttonContentRow() -> some View {
        HStack {
            Text("Buttons:")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.black)
            
            Spacer()
        }
        
        
        
        HStack {
                Image(systemName: "gearshape")
                .font(.system(size: 20))
     
                Text("Open up the Settings Menu")
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
           
            }
            
        Divider()
        
        HStack() {
                Image(systemName: "microphone")
                .font(.system(size: 20))

                
                Text("Toggles On and Off Voice Commands (Turns Red if Currently Recording)")
                .font(.system(size: 15))
                .multilineTextAlignment(.leading)
                
            }
        
        Divider()
        
        HStack {
                Image(systemName: "arrow.circlepath")
                .font(.system(size: 20))

                Text("Resets Both of the Team's Scores to Zero")
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
              
            }
        
        Divider()
            
        HStack {
                Image(systemName: "circlebadge.2.fill")
                .font(.system(size: 20))
            
                Text("Duce Mode: Players Have to Win By Two Points")
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)

            }
        
        Divider()
        
        HStack {
            Text("Voice Commands:")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.black)
                .padding(.top, 15)
            
            Spacer()
        }
        
        
        
        VStack(alignment: .leading) {
            HStack {
                Text("'Team Name' score:")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.vertical, 5)
                Text("Add a point to the dictacted team")
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    .padding(.vertical, 5)
                
            }
            
            Divider()
            
            
            HStack {
                Text("'Team Name' loss:")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.vertical, 5)
                Text("Remove a point from the dictacted team")
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    .padding(.vertical, 5)
            }
            
            
            Divider()
            
            HStack {
                Text("restart game:")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.vertical, 5)
                Text("Reset both of the teams scores to zero")
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    .padding(.vertical, 5)
            }
            
            
            Divider()
            
                
                
        }
        
        HStack {
            Text("Voice Recognition Preview")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.black)
                .padding(.top, 15)
            
            Spacer()
        }
        
        
        
        VStack(alignment: .leading) {
            
            Text("Press and hold to drag around.")
                .font(.system(size: 15))
                .foregroundStyle(.black)
                .padding(.vertical, 5)
                
                
            
            Divider()
            
            
            
            
            Text("Double click to reset position.")
                .font(.system(size: 15))
                .foregroundStyle(.black)
                .padding(.vertical, 5)
            
            
           
            Divider()
                
                
        }
        
        
        

        

    }
    
    
    
    
    
    
    
    
    
}

struct ColorPickerView: View {
    @Binding var selectedBackgroundColor: Color
    @Binding var selectedTextColor: Color
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                Text("Change Colors")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(.black)
                
                ColorPicker("Choose a Background Color", selection: $selectedBackgroundColor)
                    .padding()
                    .font(.system(size: 25))
                    .foregroundStyle(.black)
                
                Divider()
                
                ColorPicker("Choose a Text Color", selection: $selectedTextColor)
                    .padding()
                    .font(.system(size: 25))
                    .foregroundStyle(.black)
                Button() {
                    dismiss() // Close the sheet
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .stroke(.black, lineWidth: 2)
                            .frame(maxHeight: 40)
                        Text("Save")
                            .font(.system(size: 25))
                            .foregroundStyle(.black)
                    }
                    
                }
                .padding()

            }
                
        }
        .presentationDetents([.medium])
        
        
    }
    
    
        
}

struct SettingsView: View {
    @EnvironmentObject var viewModel: MainViewViewModel
    
    @Binding var isGamePointEditing: Bool
    @Binding var newGamePoint: String
    @Binding var isServerNumberEditing: Bool
    @Binding var newServerNumber: String
    @Binding var showDictationText: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                Text("Settings")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.black)
                    .padding()
                
                
                ScrollView(.vertical, showsIndicators: false){
                    Divider()
                    Button {
                        isGamePointEditing = true
                    } label: {
                        HStack {
                            Text("Set Game Point")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .padding()
                            
                            Spacer()
                            Image(systemName: "trophy")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        .alert("Set Game Point", isPresented: $isGamePointEditing) {
                            TextField("Current Game Point: \(viewModel.gamePoint)", text: $newGamePoint)
                                .keyboardType(.numberPad) // Numeric keyboard
                                .padding()
                            Button("Save") {
                                if !newGamePoint.isEmpty || !(Int(newGamePoint) ?? 21 <= viewModel.team1Score) || !(Int(newGamePoint) ?? 21 <= viewModel.team2Score) {
                                    viewModel.gamePoint = Int(newGamePoint) ?? 21
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                        
                        
                    }
                    
                    Divider()
                    
                    Button {
                        showDictationText.toggle()
                    } label: {
                        HStack {
                            
                            Text("Show Voice Recognition Preview")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .padding()
                            
                            Spacer()
                            Image(systemName: showDictationText ? "message.badge.waveform.fill" : "message.badge.waveform")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        
                        
                    }
                    
                    Divider()
                    
                    Button {
                        
                        if viewModel.screenActivityMode == 1 {
                            viewModel.changeScreenMode(screenMode: 0)
                        } else {
                            viewModel.changeScreenMode(screenMode: 1)
                        }
                    } label: {
                        HStack {
                            
                            Text("Keep Display Awake")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .padding()
                            
                            Spacer()
                            Image(systemName: viewModel.screenActivityMode == 1 ? "sleep.circle.fill" : "sleep.circle")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        
                        
                    }
                    Divider()
                    
                    Button {
                        
                        viewModel.servingIndicators.toggle()
                    } label: {
                        HStack {
                            
                            Text("Enable Serving Indicators")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .padding()
                            
                            Spacer()
                            Image(systemName: viewModel.servingIndicators ? "figure.tennis.circle.fill" : "figure.tennis.circle")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        
                        
                    }
                    
                    
                    Divider()
                    

                    Button {
                        isServerNumberEditing = true
                    } label: {
                        HStack {
                            Text("Set Number of Serves")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                                .padding()
                            
                            Spacer()
                            Image(systemName: "figure.tennis")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        .alert("Set Number of Serves", isPresented: $isServerNumberEditing) {
                            TextField("Current Number of Serves: \(viewModel.servesPerServer)", text: $newServerNumber)
                                .keyboardType(.numberPad) // Numeric keyboard
                                .padding()
                            Button("Save") {
                                if !newServerNumber.isEmpty && Int(newServerNumber) ?? 2 > 0 {
                                    viewModel.servesPerServer = Int(newServerNumber) ?? 2
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                        
                        
                    }
                    
                    Divider()
                }
                
                    
                    
                

                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .stroke(.black, lineWidth: 2)
                            .frame(maxHeight: 50)
                        Text("Save")
                            .font(.system(size: 25))
                            .foregroundStyle(.black)
                    }
                    
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 10)
            }
        }
    }
}


struct GameOverView: View {
    @EnvironmentObject var viewModel: MainViewViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var confettiCounter = 0
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                Text("GAME OVER")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(.black)
                
                if viewModel.team1Score > viewModel.team2Score {
                    Text("Team: \(viewModel.team1Name) Won")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                    Text("Score = \(viewModel.team1Score) - \(viewModel.team2Score)")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                } else {
                    Text("Team: \(viewModel.team2Name) Won")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                    Text("Score: \(viewModel.team2Score) - \(viewModel.team1Score)")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                }
                
                Button {
                    viewModel.resetScore()
                    dismiss() // Close the sheet
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.clear)
                            .stroke(Color.black, lineWidth: 3)
                            .frame(width: 105, height: 40)
                        
                        Text("Restart")
                            .font(.system(size: 25))
                            .foregroundStyle(.black)
                    }
                }
                .padding()
            
            }
        }
        
        .onAppear {
            confettiCounter += 1
        }
        .onDisappear {
            viewModel.resetScore()
        }
        .confettiCannon(trigger: $confettiCounter, num: 80)
        
    }
        
    
}


func isColorWhite(_ color: Color) -> Bool {
    let uiColor = UIColor(color)
    guard let components = uiColor.cgColor.components, components.count >= 3 else {
        return false
    }
    
    let red = components[0]
    let green = components[1]
    let blue = components[2]
    
    if red >= 0.7 && green >= 0.7 && blue >= 0.7 {
        return true
    } else if red >= 0.9 && green >= 0.9 && blue >= 0 {
        return true
    } else {
        return false
    }
    

}

func getAppVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return "Unknown"
    }

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start from the bottom left
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        // Add line to the top middle
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        // Add line to the bottom right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Close the path to create the third side of the triangle
        path.closeSubpath()

        return path
    }
}

#Preview {
    MainView()
}
