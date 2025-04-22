//
//  ServerIndicatorView.swift
//  PongTally
//
//  Created by Alek Vasek on 3/20/25.
//

import SwiftUI

struct ServerIndicatorView: View {
    @State var fillColor: Color
    @State var strokeColor: Color
    @State var paddleAngle: Angle
    
    var body: some View {
        
        ZStack {
            Color.white
            
            
            
            PingPongPaddle()
                .fill(Color.blue)
                .stroke(Color.white, lineWidth: 5)
                .frame(width: 150, height: 210)
                .shadow(radius: 5)
                .padding()
                
                
        }
    }
}

struct PingPongPaddle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
                
        let faceDiameter = rect.width * 0.8 // Slightly smaller circle
        let faceRect = CGRect(
            x: rect.midX - faceDiameter / 2,
            y: rect.minY + rect.height * 0.1, // Slightly lowered for balance
            width: faceDiameter,
            height: faceDiameter
        )
        
        let handleWidth = rect.width * 0.2
        let handleHeight = rect.height * 0.4
        let handleRect = CGRect(
            x: rect.midX - handleWidth / 2,
            y: rect.maxY - handleHeight + 15,
            width: handleWidth,
            height: handleHeight
        )
        
        // Add handle first
        path.addRoundedRect(in: handleRect, cornerSize: CGSize(width: 5, height: 5))
        
        // Then add paddle face, making it a single continuous path
        path.addEllipse(in: faceRect)

        return path
    }
}

#Preview {
    ServerIndicatorView(fillColor: Color.white, strokeColor: Color.black, paddleAngle: .degrees(30))
}
