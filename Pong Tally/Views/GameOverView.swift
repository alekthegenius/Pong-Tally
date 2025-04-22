//
//  GameOverView.swift
//  PongTally
//
//  Created by Alek Vasek on 4/20/25.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var viewModel: MainViewViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var confettiCounter = 0
    
    var winningTeamName: String?
    
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
                
                
                Text("Team: \(viewModel.gameWinner) Won")
                    .font(.system(size: 20))
                    .foregroundStyle(.black)
                    
                
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

#Preview {
    GameOverView(winningTeamName: "Team 1")
        .environmentObject(MainViewViewModel())
}
