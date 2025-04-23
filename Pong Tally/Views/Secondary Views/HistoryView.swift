//
//  HistoryView.swift
//  PongTally
//
//  Created by Alek Vasek on 4/22/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\Game.gameDate, order: .reverse)]) var games: [Game]
    
    
    var body: some View {
        NavigationStack {
            VStack{
                List {
                    if games.isEmpty {
                        Text("Start a Game to Start Tallying!")
                            .font(.headline)
                    } else {
                        ForEach(games) { game in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(game.winningTeamName): \(game.winningTeamScore) - \(game.losingTeamName): \(game.losingTeamScore)")
                                        .font(.headline)
                                    Spacer()
                                }
                                Text(game.gameDate.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                
                            }

                        }
                        .onDelete(perform: deleteGame)
                    }
                    
                }
                
                
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(Color.blue)
                        Text("Close")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.white)
                        
                        
                    }
                    .frame(width: 250, height: 60)
                        
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Game History")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            
            
            
        }
    }
    
    func deleteGame(_ indexSet: IndexSet) {
        for index in indexSet {
            let game = games[index]
            modelContext.delete(game)
        }
    }
}

#Preview {
    HistoryView()
    
}
