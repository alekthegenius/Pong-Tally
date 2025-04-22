//
//  SettingsView.swift
//  PongTally
//
//  Created by Alek Vasek on 4/20/25.
//

import SwiftUI

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

#Preview {
    SettingsView(isGamePointEditing: .constant(false), newGamePoint: .constant(""), isServerNumberEditing: .constant(false), newServerNumber: .constant(""), showDictationText: .constant(false))
        .environmentObject(MainViewViewModel())
}
