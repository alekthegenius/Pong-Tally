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
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(Color.white
                        .opacity(0.7))
                    
                
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(viewModel.dictatedText)
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            .id("voiceText")
                    }
                    .padding()
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
                    
                    
                
                
                
                
            }
            .frame(width: 275, height: 45)
            .animation(.none, value: 0)
            .position(self.dragAmount ?? CGPoint(x: gp.size.width / 2, y: 50))
            .highPriorityGesture(  // << to do no action on drag !!
                DragGesture()
                    .onChanged { self.dragAmount = $0.location})
           
            
        }
        
        
    }
}

#Preview {
    SpeechRecognitionView(viewModel: MainViewViewModel())
}
