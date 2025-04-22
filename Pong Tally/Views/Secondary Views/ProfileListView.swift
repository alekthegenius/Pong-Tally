//
//  ProfileListView.swift
//  PongTally
//
//  Created by Alek Vasek on 4/21/25.
//

import SwiftUI
import SwiftData

struct ProfileListView: View {
    @Query var profiles: [Profile]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Binding var currentUser: Int
    
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            NavigationStack {
                VStack {
                    
                    List {
                        ForEach(profiles) { profile in
                            profileListItem(profile)
                                .listRowBackground(Color(uiColor: profile.backgroundColor))
                        }
                        
                    }
                    
                    
                }
                .listStyle(.automatic)
                .navigationTitle("Profiles")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                    
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        if editMode == .inactive{
                            Button {
                                
                                
                            } label: {
                                
                                Image(systemName: "plus")
                                
                            }
                        }
                    }
                }
                .environment(\.editMode, $editMode)
            
            }
            
        }
    }
    
    @ViewBuilder
    func profileListItem(_ profile: Profile) -> some View {
        HStack {
            Text(profile.name)
                .font(.system(size: 20, weight: .medium))
            Spacer()
            Button {
                
            } label: {
                Text("Edit")
            }
        }
    }
    
    func createProfile() {
        let newProfile = Profile()
        
        modelContext.insert(newProfile)
    }
}

#Preview {
    ProfileListView(currentUser: .constant(0))
}
