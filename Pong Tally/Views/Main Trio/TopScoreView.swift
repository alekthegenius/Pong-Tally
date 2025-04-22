//
//  TopScoreView.swift
//  PongTally
//
//  Created by Alek Vasek on 4/20/25.
//

import SwiftUI
import SwiftData

struct TopScoreView: View {
    @EnvironmentObject var viewModel: MainViewViewModel
    
    @State private var newTeamName: String = ""
    
    @State private var isTeam1TitleEditing: Bool = false
    @State private var isTeam1ColorEditing: Bool = false
    
    @State private var newBackgroundColor: Color = .white
    @State private var newTextColor: Color = .black
    
    @State private var isSavingColorData: Bool = false
    
    var profile: Profile
    
    
    
    var teamOneScore: () -> Void
    
    
    var body: some View {
        VStack() { // Aligns Main Three Elements: First Team Board, Menu Bar, and Second Team Board
            
            ZStack { // First Team Board
                Color.white
                    .ignoresSafeArea()
                
                Button { // Background Button to Enable Score
                    
                    teamOneScore()
                    
                } label: {
                    Rectangle()
                        .fill(Color(uiColor: profile.backgroundColor))
                        .ignoresSafeArea()
                    
                }
                
                VStack() { // Align Board Controls
                    
                    HStack() { // Align Board Header
                        
                        Button { // Team Name
                            newTeamName = profile.name
                            isTeam1TitleEditing = true
                        } label:{
                            Text("\(profile.name)")
                                .frame(maxHeight: 45)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(uiColor: profile.textColor))
                                .font(.system(size:40))
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            
                        }
                        .alert("Change Team Name", isPresented: $isTeam1TitleEditing) {
                            TextField("Enter new team name", text: $newTeamName)
                            Button("Save") {
                                if !newTeamName.isEmpty {
                                    profile.name = newTeamName
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                        .onAppear() {
                            viewModel.team1Name = profile.name
                        }
                        
                        Spacer()
                        
                        Button { // Color Settings Button
                            isTeam1ColorEditing = true
                        } label: {
                            Circle()
                                .stroke(Color(uiColor: profile.textColor), lineWidth: 5)
                                .frame(maxWidth: 40, maxHeight: 40)
                                .padding(.trailing, 10)
                                .sheet(isPresented: $isTeam1ColorEditing, onDismiss: updateProfileColors) {
                                    ColorPickerView(selectedBackgroundColor: $newBackgroundColor, selectedTextColor: $newTextColor, isSavingColorData: $isSavingColorData)
                                        
                                }
                                .presentationDetents([.medium])
                                .onAppear() {
                                    newBackgroundColor = Color(uiColor: profile.backgroundColor)
                                    newTextColor = Color(uiColor: profile.textColor)
                                }
                            
                        }
                        
                    }
                    .padding()
                    
                    Spacer()
                    
                    Text("\(profile.currentScore)") // Score Viewer
                        .fontWeight(.heavy)
                        .foregroundStyle(Color(uiColor: profile.textColor))
                        .font(.system(size:80))
                        .allowsHitTesting(false)
                        .offset(y: -25)
                        .onChange(of: viewModel.team1Score) {
                            profile.currentScore = viewModel.team1Score
                            print(profile.currentScore)
                        }
                        .onAppear() {
                            viewModel.team1Score = profile.currentScore
                            print(profile.currentScore)
                        }
                    
                    
                    
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
                                .font(.system(size: 40))
                                .foregroundStyle(Color(uiColor: profile.textColor))
                                .opacity(profile.currentScore > 0 ? 1 : 0.2)
                                .contentShape(Rectangle())
                        }
                        .disabled(profile.currentScore > 0 ? false : true)
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
                                    .stroke(Color(uiColor: profile.textColor), lineWidth: 4)
                                    .frame(width: 120, height: 50)
                                    .offset(y: 2)
                                
                                Text(viewModel.currentNumberOfServes.formatted())
                                    .font(.system(size: 25, weight: .medium))
                                    .foregroundStyle(Color(uiColor: profile.textColor))
                                    .offset(y: 5)
                                
                                
                                
                            }
                            .frame(width: 90, height: 50)
                            .contentShape(Triangle())
                            
                            
                            
                        }
                        .zIndex(2)
                        
                        
                        
                    }
                }
            }
        }
    }
    
    func updateProfileColors() {
        if isSavingColorData {
            profile.backgroundColor = UIColor(newBackgroundColor)
            profile.textColor = UIColor(newTextColor)
            isSavingColorData = false
        }
    }
    
}

#Preview {
    TopScoreView(profile: Profile(), teamOneScore: {})
        .environmentObject(MainViewViewModel())
}
