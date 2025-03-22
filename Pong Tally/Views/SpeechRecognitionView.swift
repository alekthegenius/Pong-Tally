//
//  SpeechRecognitionView.swift
//  PongTally
//
//  Created by Alek Vasek on 2/26/25.
//

import SwiftUI

struct SpeechRecognitionView: View {
    
    @ObservedObject var viewModel: MainViewViewModel
    @State private var dragAmount: CGPoint?
    
    
    
    var body: some View {
        GeometryReader { gp in
            ZStack() {
                RoundedRectangle(cornerRadius: 25, style:  .continuous)
                    .foregroundStyle(Color.white
                        .opacity(0.7))
                    
                
                VStack(alignment: .center) {
                    Text("Voice Recognition Preview")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(height: 15)
                        .padding(.top, 5)
                        .padding(.horizontal, 5)
                        
                    
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            Text(viewModel.dictatedText)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.black)
                                .id("voiceText")
                        }
                        .padding(.vertical, 15)
                        .frame(height: 15)
                        .onAppear() {
                            withAnimation {
                                proxy.scrollTo("voiceText", anchor: .trailing)
                            }
                        }
                        .onChange(of: viewModel.dictatedText) {
                            withAnimation {
                                proxy.scrollTo("voiceText", anchor: .trailing)
                            }
                        }
                    }
                    .frame(width: 250)
                }
                
                    
                    
                
                
                
                
            }
            .frame(width: 275, height: 65)
            .animation(.none, value: 0)
            .position(self.dragAmount ?? CGPoint(x: gp.size.width / 2, y: 50))
            .highPriorityGesture(  // << to do no action on drag !!
                DragGesture()
                    .onChanged { self.dragAmount = $0.location}
            )
            .onTapGesture(count: 2) {
                dragAmount = CGPoint(x: gp.size.width / 2, y: 50)
            }
            
           
            
        }
        
        
    }
        
}

#Preview {
    SpeechRecognitionView(viewModel: MainViewViewModel())
}
