//
//  BottomScoreView.swift
//  PongTally
//
//  Created by Alek Vasek on 4/20/25.
//

import SwiftUI
import SwiftData

struct BottomScoreView: View {
    @EnvironmentObject var viewModel: MainViewViewModel
    
    @State private var newTeamName: String = ""
    
    @State private var isTeam2TitleEditing: Bool = false
    @State private var isTeam2ColorEditing: Bool = false
    
    @State private var newBackgroundColor: Color = .white
    @State private var newTextColor: Color = .black
    
    @State private var isSavingColorData: Bool = false
    
    @Binding var isShowingProfileMenu: Bool
    
    
    var profile: Profile
    
    
    var teamTwoScore: () -> Void
    
    var body: some View {
        ZStack { // Second Team Board
            Color.white
                .ignoresSafeArea()
            
            Button { // Background Button to Enable Score
                
                teamTwoScore()
                
            } label: {
                Rectangle()
                    .fill(Color(uiColor: profile.backgroundColor))
                    .ignoresSafeArea()
            }
            
                
            VStack() { // Align Board Controls
                

                
                HStack() { // Align Board Header
                    
                    Button { // Team Name
                        newTeamName = profile.name
                        isShowingProfileMenu = true
                    } label: {
                        Text("\(profile.name)")
                            .frame(maxHeight: 45)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(uiColor: profile.textColor))
                            .font(.system(size:40))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            
                    }
                    .onAppear() {
                        viewModel.team2Name = profile.name
                    }
                    
                    
                    Spacer()
                    Button() { // Color Settings Button
                        isTeam2ColorEditing = true
                        newBackgroundColor = Color(uiColor: profile.backgroundColor)
                        newTextColor = Color(uiColor: profile.textColor)
                    } label: {
                        Circle()
                            .stroke(Color(uiColor: profile.textColor), lineWidth: 5)
                            .frame(maxWidth: 40, maxHeight: 40)
                            .padding(.trailing, 10)
                            .sheet(isPresented: $isTeam2ColorEditing, onDismiss: updateProfileColors) {
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
                
                Spacer() // Score Viewer
                Text("\(profile.currentScore)")
                    .fontWeight(.heavy)
                    .foregroundStyle(Color(uiColor: profile.textColor))
                    .font(.system(size:80))
                    .allowsHitTesting(false)
                    .offset(y: -25)
                    .onChange(of: viewModel.team2Score) {
                        profile.currentScore = viewModel.team2Score
                        print(profile.currentScore)
                    }
                    .onAppear() {
                        viewModel.team2Score = profile.currentScore
                        print(profile.currentScore)
                    }
                
                
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
                                .stroke(Color(uiColor: profile.textColor), lineWidth: 4)
                                .frame(width: 120, height: 50)
                                .rotationEffect(Angle(degrees: 180))
                                .offset(y: -2)
                            
                            Text(viewModel.currentNumberOfServes.formatted())
                                .font(.system(size: 25, weight: .medium))
                                .foregroundStyle(Color(uiColor: profile.textColor))
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
    
    func updateProfileColors() {
        if isSavingColorData {
            profile.backgroundColor = UIColor(newBackgroundColor)
            profile.textColor = UIColor(newTextColor)
            isSavingColorData = false
        }
    }
}

#Preview {
    BottomScoreView(isShowingProfileMenu: .constant(false), profile: Profile(), teamTwoScore: {})
        .environmentObject(MainViewViewModel())
}
