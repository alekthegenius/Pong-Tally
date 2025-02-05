//
//  scoreboardview.swift
//  Pong Tally
//
//  Created by Alek Vasek on 1/12/25.
//

import SwiftUI
import ConfettiSwiftUI


struct scoreboardview: View {
    
    @StateObject var viewModel = ScoreboardViewModel()
    
    @State private var newTeamName: String = ""
    
    @State private var isTeam1TitleEditing: Bool = false
    @State private var isTeam1ColorEditing: Bool = false
    
    @State private var isTeam2TitleEditing: Bool = false
    @State private var isTeam2ColorEditing: Bool = false
    
    @State private var isGamePointEditing: Bool = false
    @State private var newGamePoint: String = ""
    

    @State private var gameWinner: Int = 0
    
    @State private var showTeam1BackButton = false
    
    @State private var showTeam2BackButton = false
    
    @State private var text1Color: Color = .white
    @State private var text2Color: Color = .white
    
    
    let heavyhapticGenerator = UIImpactFeedbackGenerator(style: .heavy)

    

    
    
    var body: some View {
        
        
        VStack() {
            Button {
                //
                heavyhapticGenerator.impactOccurred(intensity: 1)
                viewModel.increaseTeam1()
                if viewModel.team1Score > 0 {
                    showTeam1BackButton = true
                }
                if (viewModel.team1Score >= viewModel.gamePoint){
                    if viewModel.winByTwo && ((viewModel.team1Score - viewModel.team2Score) >= 2){
                        
                        gameWinner = 1
                        showTeam1BackButton = false
                        showTeam2BackButton = false
                        viewModel.gameOver = true
                    } else if !viewModel.winByTwo {
                        gameWinner = 1
                        showTeam1BackButton = false
                        showTeam2BackButton = false
                        viewModel.gameOver = true
                    }
                }

            } label: {
                ZStack() {
                    
                    Rectangle()
                        .fill(viewModel.team1Color)
                        .ignoresSafeArea()
                    
                        VStack() {
                            HStack() {
                                Text("\(viewModel.team1Name)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // Centers the text
                                    .fontWeight(.bold)
                                    .foregroundStyle(text1Color)
                                    .font(.system(size:40))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                    .onTapGesture {
                                        newTeamName = viewModel.team1Name
                                        isTeam1TitleEditing = true
                                    }
                                    .alert("Change Team Name", isPresented: $isTeam1TitleEditing) {
                                        TextField("Enter new team name", text: $newTeamName)
                                        Button("Save") {
                                            if !newTeamName.isEmpty {
                                                viewModel.team1Name = newTeamName
                                            }
                                        }
                                        Button("Cancel", role: .cancel) { }
                                    }
                                
                                Circle()
                                    .stroke(text1Color, lineWidth: 5)
                                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
                                    .padding(.trailing, 10)
                                    .onTapGesture {
                                        isTeam1ColorEditing = true
                                    }
                                    .sheet(isPresented: $isTeam1ColorEditing) {
                                        ColorPickerView(selectedColor: $viewModel.team1Color)
                                    }
                                    .onChange(of: viewModel.team1Color) {
                                        if isColorWhite(viewModel.team1Color){
                                            text1Color = .black
                                        } else {
                                            text1Color = .white
                                        }
                                    }
                                
                            }
                            .padding()
                            
                            Spacer()
                            Text("\(viewModel.team1Score)")
                                .fontWeight(.heavy)
                                .foregroundStyle(text1Color)
                                .font(.system(size:80))
                            
                            
                            Spacer()
                            
                            
                            
                        }
                        .padding(.top, 20)
                    
                        VStack{
                            Spacer()
                            HStack {
                                Spacer()
                                Button {
                                    if viewModel.team1Score > 0 {
                                        viewModel.decreaseTeam1()
                                    } else {
                                        showTeam1BackButton = false
                                    }
                                    
                                    if viewModel.team1Score == 0 {
                                        showTeam1BackButton = false
                                    }
                                    
                                } label: {
                                    Image(systemName: "arrowshape.turn.up.backward")
                                        .font(.system(size: 30))
                                        .foregroundStyle(text1Color)
                                        .opacity(showTeam1BackButton ? 1 : 0.2)
                                        .disabled(showTeam1BackButton)
                                }
                                .padding(.bottom, 20)
                                .padding(.trailing, 20)
                            }
                        }
                        
                    }
                    
                    
                }
                
               
                
                
        
                
            // Middle Menu Bar
            
            ZStack() {
                Rectangle()
                    .fill(.white)
                    .frame(maxHeight: 30)
                
                
                HStack() {
                    
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.clear)
                            .strokeBorder(.black, lineWidth: 2)
                            .frame(width: 100, height: 40)
                            
                        Text("PongTally")
                            .font(.system(size: 17))
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .padding()
                    }
                    
                    Button {

                        if viewModel.speechRecognitionStatus {
                            viewModel.stopListening()
                        } else {
                            if viewModel.speechRecognitionAuthorized {
                                viewModel.startListening()
                           }
                       }
                        viewModel.speechRecognitionStatus.toggle()
                        print(viewModel.speechRecognitionStatus)

                    } label: {
                        Image(systemName: (viewModel.speechRecognitionStatus && viewModel.speechRecognitionAuthorized) ? "microphone.fill" : "microphone.slash")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                        
                    }
                    .padding()
                    .opacity(viewModel.speechRecognitionAuthorized ? 1 : 0.5)
                    .disabled(!viewModel.speechRecognitionAuthorized)
                    
                    
                    Image(systemName: "trophy")
                            .font(.system(size: 25))
                            .foregroundColor(Color.black)
                            .onTapGesture {
                                isGamePointEditing = true
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
                            .padding()
                    
                    Button {
                        showTeam1BackButton = false
                        showTeam2BackButton = false
                        viewModel.resetScore()
                    } label: {
                        Image(systemName: "arrow.circlepath")
                            .font(.system(size: 25))
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    
                    Button {
                        viewModel.winByTwo.toggle()
                    } label: {
                        if viewModel.winByTwo {
                            Image(systemName: "circlebadge.2.fill")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                                .padding()
                        } else {
                            Image(systemName: "circlebadge.2")
                                .font(.system(size: 25))
                                .foregroundColor(Color.black)
                                .padding()
                        }
                        
                    }
                    
                }
                

            }
            
            Button {
                //
                heavyhapticGenerator.impactOccurred(intensity: 1)
                viewModel.increaseTeam2()
                
                if viewModel.team2Score > 0 {
                    showTeam2BackButton = true
                }
                
                if (viewModel.team2Score >= viewModel.gamePoint){
                    if viewModel.winByTwo && ((viewModel.team2Score - viewModel.team1Score) >= 2){
                        
                        gameWinner = 2
                        showTeam1BackButton = false
                        showTeam2BackButton = false
                        viewModel.gameOver = true
                    } else if !viewModel.winByTwo {
                        gameWinner = 2
                        showTeam1BackButton = false
                        showTeam2BackButton = false
                        viewModel.gameOver = true
                    }
                }
                
            } label: {
                ZStack() {
                    
                    Rectangle()
                        .fill(viewModel.team2Color)
                        .ignoresSafeArea()
                    VStack(alignment: HorizontalAlignment.center) {
                        HStack() {
                            Text("\(viewModel.team2Name)")
                                .frame(maxWidth: .infinity, alignment: .leading) // Centers the text
                                .fontWeight(.bold)
                                .foregroundStyle(text2Color)
                                .font(.system(size:40))
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                .onTapGesture {
                                    newTeamName = viewModel.team2Name
                                    isTeam2TitleEditing = true
                                }
                                .alert("Change Team Name", isPresented: $isTeam2TitleEditing) {
                                    TextField("Enter new team name", text: $newTeamName)
                                    Button("Save") {
                                        if !newTeamName.isEmpty {
                                            viewModel.team2Name = newTeamName
                                        }
                                    }
                                    Button("Cancel", role: .cancel) { }
                                }
                            
                            Circle()
                                .stroke(text2Color, lineWidth: 5)
                                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .trailing)
                                .padding(.trailing, 10)
                                .onTapGesture {
                                    isTeam2ColorEditing = true
                                }
                                .sheet(isPresented: $isTeam2ColorEditing) {
                                    ColorPickerView(selectedColor: $viewModel.team2Color)
                                }
                                .onChange(of: viewModel.team2Color) {
                                    if isColorWhite(viewModel.team2Color){
                                        text2Color = .black
                                    } else {
                                        text2Color = .white
                                    }
                                }
                            
                        }
                        .padding()
                        
                        Spacer()
                        Text("\(viewModel.team2Score)")
                            .fontWeight(.heavy)
                            .foregroundStyle(text2Color)
                            .font(.system(size:80))
                        
                        
                        Spacer()
                    }
                    
                    VStack{
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                if viewModel.team2Score > 0 {
                                    viewModel.decreaseTeam2()
                                } else {
                                    showTeam2BackButton = false
                                }
                                
                                if viewModel.team2Score == 0 {
                                    showTeam2BackButton = false
                                }
                                
                            } label: {
                                Image(systemName: "arrowshape.turn.up.backward")
                                    .font(.system(size: 30))
                                    .foregroundStyle(text2Color)
                                    .opacity(showTeam2BackButton ? 1 : 0.2)
                                    .disabled(showTeam2BackButton)
                            }
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                        }
                    }
                    
                
                    
                }
            }
            .onAppear {
                heavyhapticGenerator.prepare() // Required for immediate feedback
            }
            
        }
        .background(.white)
        .sheet(isPresented: $viewModel.gameOver) {
            GameOverView()
                .environmentObject(viewModel)
        }
    }
    
}




struct ColorPickerView: View {
    @Binding var selectedColor: Color
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                Text("Select Team Color")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(.black)
                
                ColorPicker("Choose a color", selection: $selectedColor)
                    .padding()
                    .font(.system(size: 25))
                    .foregroundStyle(.black)
                Button() {
                    presentationMode.wrappedValue.dismiss() // Close the sheet
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


struct GameOverView: View {
    @EnvironmentObject var viewModel: ScoreboardViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var confettiCounter = 0
    
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
                
                if viewModel.team1Score > viewModel.team2Score {
                    Text("Team: \(viewModel.team1Name) Won")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                    Text("Score = \(viewModel.team1Score) - \(viewModel.team2Score)")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                } else {
                    Text("Team: \(viewModel.team2Name) Won")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                    Text("Score: \(viewModel.team2Score) - \(viewModel.team1Score)")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                }
                
                Button {
                    viewModel.resetScore()
                    presentationMode.wrappedValue.dismiss() // Close the sheet
                    
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
            presentationMode.wrappedValue.dismiss()
        }
        .confettiCannon(trigger: $confettiCounter, num: 80)
        
    }
        
    
}


func isColorWhite(_ color: Color) -> Bool {
    let uiColor = UIColor(color)
    guard let components = uiColor.cgColor.components, components.count >= 3 else {
        return false
    }
    
    let red = components[0]
    let green = components[1]
    let blue = components[2]
    
    if red >= 0.7 && green >= 0.7 && blue >= 0.7 {
        return true
    } else if red >= 0.9 && green >= 0.9 && blue >= 0 {
        return true
    } else {
        return false
    }
    

}

#Preview {
    scoreboardview()
}
