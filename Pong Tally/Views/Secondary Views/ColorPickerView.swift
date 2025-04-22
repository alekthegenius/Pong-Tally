//
//  ColorPickerView.swift
//  PongTally
//
//  Created by Alek Vasek on 4/20/25.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedBackgroundColor: Color
    @Binding var selectedTextColor: Color
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isSavingColorData: Bool

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                Text("Change Colors")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(.black)
                
                ColorPicker("Choose a Background Color", selection: $selectedBackgroundColor)
                    .padding()
                    .font(.system(size: 25))
                    .foregroundStyle(.black)
                
                Divider()
                
                ColorPicker("Choose a Text Color", selection: $selectedTextColor)
                    .padding()
                    .font(.system(size: 25))
                    .foregroundStyle(.black)
                Button() {
                    isSavingColorData = true
                    dismiss() // Close the sheet
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .stroke(.black, lineWidth: 2)
                            .frame(maxHeight: 40)
                        Text("Save")
                            .font(.system(size: 25))
                            .foregroundStyle(.black)
                    }
                    
                }
                .padding()

            }
                
        }
        .presentationDetents([.medium])
        
        
    }
    
    
        
}

#Preview {
    ColorPickerView(selectedBackgroundColor: .constant(.red), selectedTextColor: .constant(.red), isSavingColorData: .constant(false))
}
