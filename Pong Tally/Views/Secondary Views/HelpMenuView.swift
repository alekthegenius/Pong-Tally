//
//  HelpMenuView.swift
//  PongTally
//
//  Created by Alek Vasek on 4/20/25.
//

import SwiftUI

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
                        HStack {
                            Text("Buttons:")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(.black)
                            
                            Spacer()
                        }
                        

                        
                        HStack {
                                Image(systemName: "gearshape")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                     
                                Text("Open up the Settings Menu")
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.black)
                           
                            }
                            
                        Divider()
                        
                        HStack {
                                Image(systemName: "list.bullet.clipboard")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                     
                                Text("Opens A History of Games")
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.black)
                           
                            }
                            
                        Divider()
                        
                        HStack() {
                                Image(systemName: "microphone")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)

                                
                                Text("Toggles On and Off Voice Commands (Turns Red if Currently Recording)")
                                .font(.system(size: 15))
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.black)
                                
                            }
                        
                        Divider()
                        
                        HStack {
                                Image(systemName: "arrow.circlepath")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)

                                Text("Resets Both of the Team's Scores to Zero")
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.black)
                              
                            }
                        
                        Divider()
                            
                        HStack {
                                Image(systemName: "circlebadge.2.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                            
                                Text("Duce Mode: Players Have to Win By Two Points")
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.black)

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
                ScrollView(.horizontal) {
                    Text("Written From Texas with ❤️, © 2025 Alek Vasek                                                                                                                                                                                                                                                                                                                                                         Never                                                                                                                                                                            Gonna                                                                                                                                                                            Give                                                                                                                                                                            You                                                                                                                                                                            Up 😉                                   ")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .scrollIndicators(.never)
                .frame(width: 271, height: 30)
                        
                
                
                    
                Text("Version \(getAppVersion())")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 10)
        }
    }
    
}

#Preview {
    HelpMenuView()
}
