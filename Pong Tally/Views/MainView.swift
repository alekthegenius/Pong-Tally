//
//  MainView.swift
//  Pong Tally
//
//  Created by Alek Vasek on 1/12/25.
//

import SwiftUI
import ConfettiSwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @Query var profiles: [Profile]
    
    @StateObject var viewModel = MainViewViewModel()
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    @State private var newTeamName: String = ""
    
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
    
    @AppStorage("selectedTeam1Profile") private var selectedProfileTeam1: String = "team1"
    @AppStorage("selectedTeam2Profile") private var selectedProfileTeam2: String = "team2"
    
    

    @State private var isShowingProfileMenuForTeam1: Bool = false
    @State private var isShowingProfileMenuForTeam2: Bool = false
    
    
    let heavyhapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
    

    

    
    
    var body: some View {
        
        
        ZStack { // Allows for the Use of Overlays
            Color.white
            
            VStack() { // Aligns Main Three Elements: Top Team Board, Middle Bar, and Bottom Team Board
                
                
                // Top Score View
                if profiles.count >= 2 {
                    if let selectedProfile = profiles.first(where: { $0.id == selectedProfileTeam1 }) {
                        TopScoreView(isShowingProfileMenu: $isShowingProfileMenuForTeam1, profile: selectedProfile, teamOneScore: teamOneScore)
                            .environmentObject(viewModel)
                    } else {
                        Text("Profile not found")
                    }
                    
                    
                    
                    // Middle Bar View
                    MiddleBarView(speechRecognizer: speechRecognizer, isSettingsMenuShown: $isSettingsMenuShown, showDictationText: $showDictationText, isHelpMenuShown: $isHelpMenuShown, isServerNumberEditing: $isServerNumberEditing, newServerNumber: $newServerNumber, showingMicPrivacyAlert: $showingMicPrivacyAlert, isRecording: $isRecording, isGamePointEditing: $isGamePointEditing, newGamePoint: $newGamePoint)
                    .frame(maxWidth: 500)
                    .frame(height: 60) // Keep Constant Menu Bar Height
                    .zIndex(3)
                    .environmentObject(viewModel)
                    
                    
                    
                    // Bottom Bar View
                    if let selectedProfile = profiles.first(where: { $0.id == selectedProfileTeam2 }) {
                        BottomScoreView(isShowingProfileMenu: $isShowingProfileMenuForTeam2, profile: selectedProfile, teamTwoScore: teamTwoScore)
                            .environmentObject(viewModel)
                    } else {
                        Text("Profile Not Found")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                    }
                    
                } else {
                    Text("ERROR: Profiles Not Found")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                }
                
            
  
            
            }
            .onAppear {
                speechRecognizer.resetTranscript()
                
                if profiles.count < 2 {
                    let team1Starter = Profile(name: "Team 1", textColor: UIColor(red: 27/255, green: 93/255, blue: 215/255, alpha: 1.0), backgroundColor: UIColor(red: 209/255, green: 253/255, blue: 255/255, alpha: 1.0), id: "team1")
                    let team2Starter = Profile(name: "Team 2",textColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), backgroundColor: UIColor(red: 255/255, green: 31/255, blue: 86/255, alpha: 1.0), id: "team2")
                    
                    if !profiles.contains(where: { $0.id == team1Starter.id }) {
                        modelContext.insert(team1Starter)
                    }
                    
                    if !profiles.contains(where: { $0.id == team2Starter.id }) {
                        modelContext.insert(team2Starter)
                    }
                }
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
                GameOverView(winningTeamName: viewModel.gameWinner, losingTeamName: viewModel.gameLoser)
                    .environmentObject(viewModel)
            }
            .onChange(of: speechRecognizer.transcript) {
                viewModel.processCommand(speechRecognizer.transcript)
            }
            .sheet(isPresented: $isShowingProfileMenuForTeam1) {
                ProfileListView(currentUser: $selectedProfileTeam1, secondaryUser: $selectedProfileTeam2, resetScore: viewModel.resetScore)
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $isShowingProfileMenuForTeam2) {
                ProfileListView(currentUser: $selectedProfileTeam2, secondaryUser: $selectedProfileTeam1, resetScore: viewModel.resetScore)
                    .environmentObject(viewModel)
                    
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
