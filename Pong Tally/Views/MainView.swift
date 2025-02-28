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
    
    
    let heavyhapticGenerator = UIImpactFeedbackGenerator(style: .heavy)

    

    
    
    var body: some View {
        
        
        ZStack {
            VStack() {
                Button {
                    //
                    heavyhapticGenerator.impactOccurred(intensity: 1)
                    viewModel.increaseTeam1()
                    if viewModel.team1Score > 0 {
                        viewModel.showTeam1BackButton = true
                    }
                    if (viewModel.team1Score >= viewModel.gamePoint){
                        if viewModel.winByTwo && ((viewModel.team1Score - viewModel.team2Score) >= 2){
                            
                            viewModel.gameWinner = 1
                            viewModel.showTeam1BackButton = false
                            viewModel.showTeam2BackButton = false
                            viewModel.gameOver = true
                        } else if !viewModel.winByTwo {
                            viewModel.gameWinner = 1
                            viewModel.showTeam1BackButton = false
                            viewModel.showTeam2BackButton = false
                            viewModel.gameOver = true
                        }
                    }
                    
                } label: {
                    ZStack() {
                        
                        Rectangle()
                            .fill(viewModel.team1Color)
                            .ignoresSafeArea()
                        
                        VStack() {
                            HStack() {
                                Button {
                                    newTeamName = viewModel.team1Name
                                    isTeam1TitleEditing = true
                                } label:{
                                    Text("\(viewModel.team1Name)")
                                        .frame(maxWidth: .infinity, alignment: .leading) // Centers the text
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
                                
                                Button {
                                    isTeam1ColorEditing = true
                                } label: {
                                    Circle()
                                        .stroke(viewModel.text1Color, lineWidth: 5)
                                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
                                        .padding(.trailing, 10)
                                        .sheet(isPresented: $isTeam1ColorEditing) {
                                            ColorPickerView(selectedBackgroundColor: $viewModel.team1Color, selectedTextColor: $viewModel.text1Color)
                                        }
                                        
                                }
                                
                            }
                            .padding()
                            
                            Spacer()
                            Text("\(viewModel.team1Score)")
                                .fontWeight(.heavy)
                                .foregroundStyle(viewModel.text1Color)
                                .font(.system(size:80))
                            
                            
                            Spacer()
                            
                            
                            
                        }
                        .padding(.top, 20)
                        
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    if viewModel.team1Score > 0 {
                                        viewModel.decreaseTeam1()
                                    } else {
                                        viewModel.showTeam1BackButton = false
                                    }
                                    
                                    if viewModel.team1Score == 0 {
                                        viewModel.showTeam1BackButton = false
                                    }
                                    
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
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                // Middle Menu Bar
                
                ZStack() {
                    Rectangle()
                        .fill(.white)
                        .frame(maxHeight: 30)
                    
                    
                    HStack() {
                        
                        Button {
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
                                    .padding()
                            }
                        }
                        .sheet(isPresented: $isHelpMenuShown) {
                            HelpMenuView()
                        }
                        
                        Button {
                            isSettingsMenuShown = true
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        .sheet(isPresented: $isSettingsMenuShown) {
                            SettingsView(isGamePointEditing: $isGamePointEditing, newGamePoint: $newGamePoint, showDictationText: $showDictationText)
                                .environmentObject(viewModel)
                        }
                        
                        
                        Button {
                            
                            if viewModel.speechRecognitionStatus {
                                viewModel.speechRecognitionStatus.toggle()
                                viewModel.stopListening()
                            } else {
                                if viewModel.speechRecognitionAuthorized {
                                    viewModel.speechRecognitionStatus.toggle()
                                    viewModel.startListening()
                                }
                            }
                            
                            print(viewModel.speechRecognitionStatus)
                            
                        } label: {
                            Image(systemName: (viewModel.speechRecognitionStatus && viewModel.speechRecognitionAuthorized) ? "microphone.fill" : "microphone.slash")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                            
                        }
                        .padding()
                        .opacity(viewModel.speechRecognitionAuthorized ? 1 : 0.5)
                        .disabled(!viewModel.speechRecognitionAuthorized)
                        
                        
                        
                        
                        
                        Button {
                            viewModel.showTeam1BackButton = false
                            viewModel.showTeam2BackButton = false
                            viewModel.resetScore()
                        } label: {
                            Image(systemName: "arrow.circlepath")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                        }
                        .padding()
                        
                        Button {
                            viewModel.winByTwo.toggle()
                        } label: {
                            if viewModel.winByTwo {
                                Image(systemName: "circlebadge.2.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.black)
                                    .padding()
                            } else {
                                Image(systemName: "circlebadge.2")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.black)
                                    .padding()
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
                Button {
                    //
                    heavyhapticGenerator.impactOccurred(intensity: 1)
                    viewModel.increaseTeam2()
                    
                    if viewModel.team2Score > 0 {
                        viewModel.showTeam2BackButton = true
                    }
                    
                    if (viewModel.team2Score >= viewModel.gamePoint){
                        if viewModel.winByTwo && ((viewModel.team2Score - viewModel.team1Score) >= 2){
                            
                            viewModel.gameWinner = 2
                            viewModel.showTeam1BackButton = false
                            viewModel.showTeam2BackButton = false
                            viewModel.gameOver = true
                        } else if !viewModel.winByTwo {
                            viewModel.gameWinner = 2
                            viewModel.showTeam1BackButton = false
                            viewModel.showTeam2BackButton = false
                            viewModel.gameOver = true
                        }
                    }
                    
                } label: {
                    ZStack() {
                        
                        Rectangle()
                            .fill(viewModel.team2Color)
                            .ignoresSafeArea()
                        VStack(alignment: HorizontalAlignment.center) {
                            HStack() {
                                Button {
                                    newTeamName = viewModel.team2Name
                                    isTeam2TitleEditing = true
                                } label: {
                                    Text("\(viewModel.team2Name)")
                                        .frame(maxWidth: .infinity, alignment: .leading) // Centers the text
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
                                
                                Button() {
                                    isTeam2ColorEditing = true
                                } label: {
                                    Circle()
                                        .stroke(viewModel.text2Color, lineWidth: 5)
                                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
                                        .padding(.trailing, 10)
                                        .sheet(isPresented: $isTeam2ColorEditing) {
                                            ColorPickerView(selectedBackgroundColor: $viewModel.team2Color, selectedTextColor: $viewModel.text2Color)
                                        }
                                        .presentationDetents([.medium])
                                }
                                
                            }
                            .padding()
                            
                            Spacer()
                            Text("\(viewModel.team2Score)")
                                .fontWeight(.heavy)
                                .foregroundStyle(viewModel.text2Color)
                                .font(.system(size:80))
                            
                            
                            Spacer()
                        }
                        
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    if viewModel.team2Score > 0 {
                                        viewModel.decreaseTeam2()
                                    } else {
                                        viewModel.showTeam2BackButton = false
                                    }
                                    
                                    if viewModel.team2Score == 0 {
                                        viewModel.showTeam2BackButton = false
                                    }
                                    
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
                        
                        
                        
                    }
                }
                .onAppear {
                    heavyhapticGenerator.prepare() // Required for immediate feedback
                }
                
                
                
            }
            .background(.white)
            .sheet(isPresented: $viewModel.gameOver) {
                GameOverView()
                    .environmentObject(viewModel)
            }
            
            if viewModel.speechRecognitionStatus == true && showDictationText == true{
                
                
                SpeechRecognitionView(viewModel: viewModel)
                    
            
                
            }
            
        }
        
        
        
       
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
        
        HStack() {
                Image(systemName: "microphone")
                .font(.system(size: 20))

                
                Text("Toggles On and Off Voice Commands")
                .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                
            }
        
        Divider()
        
        HStack {
                Image(systemName: "trophy")
                .font(.system(size: 20))
     
                Text("Sets the Winning Point for the Teams to Play To")
                .font(.system(size: 15))
                    .multilineTextAlignment(.center)
           
            }
            
        Divider()
        
        HStack {
                Image(systemName: "arrow.circlepath")
                .font(.system(size: 20))

                Text("Resets Both of the Team's Scores to Zero")
                .font(.system(size: 15))
                    .multilineTextAlignment(.center)
              
            }
        
        Divider()
            
        HStack {
                Image(systemName: "circlebadge.2.fill")
                .font(.system(size: 20))
            
                Text("Duce Mode: Players Have to Win By Two Points")
                .font(.system(size: 15))
                    .multilineTextAlignment(.center)

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
                Text("'teamName' score:")
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
                Text("'teamName' loss:")
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
            
            HStack {
                Text("stop voice commands:")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.black)
                    .padding(.vertical, 5)
                Text("Stop listening for voice commands")
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    .padding(.vertical, 5)
            }
            
           
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
                            
                            Text("Show Dictation Preview")
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

#Preview {
    MainView()
}
