//
//  GameOverView.swift
//  PongTally
//
//  Created by Alek Vasek on 4/20/25.
//

import SwiftUI
import SwiftData

struct GameOverView: View {
    @EnvironmentObject var viewModel: MainViewViewModel
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query var games: [Game]
    
    @State private var confettiCounter = 0
    
    var winningTeamName: String
    var losingTeamName: String
    
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
                
                
                Text("Team: \(winningTeamName) Won")
                    .font(.system(size: 20))
                    .foregroundStyle(.black)
                    
                if winningTeamName == viewModel.team1Name {
                    Text("\(viewModel.team1Score) - \(viewModel.team2Score)")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                } else {
                    Text("\(viewModel.team2Score) - \(viewModel.team1Score)")
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
            insertGame()
            viewModel.resetScore()
        }
        .confettiCannon(trigger: $confettiCounter, num: 80)
        
    }
    
    func insertGame() {
        let newGame = Game(winningTeamName: winningTeamName, losingTeamName: losingTeamName, winningTeamScore: winningTeamName == viewModel.team1Name ? viewModel.team1Score : viewModel.team2Score, losingTeamScore: winningTeamName != viewModel.team1Name ? viewModel.team1Score : viewModel.team2Score, gameDate: .now)
        if !games.contains(where: { $0 == newGame }) {
            modelContext.insert(newGame)
        }
    }
        
    
}

#Preview {
    GameOverView(winningTeamName: "Team 1", losingTeamName: "Team 2")
        .environmentObject(MainViewViewModel())
}
