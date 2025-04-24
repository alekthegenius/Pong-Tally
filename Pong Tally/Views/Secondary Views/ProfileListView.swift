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
    
    @EnvironmentObject var viewModel: MainViewViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    
    @Binding var currentUser: String
    @Binding var secondaryUser: String
    
    var teamSlot: TeamSlot
    
    var resetScore: () -> Void
    
    @State private var editMode = EditMode.inactive
    
    @State private var isTitleEditing = false
    @State private var newProfileName: String = "Team Name"
    @State private var profileBeingEdited: Profile? = nil
    
    var activeProfiles: [Profile] {
        profiles
            .filter { $0.id == currentUser || $0.id == secondaryUser }
            .sorted {
                $0.id == currentUser && $1.id != currentUser
            }
    }

    var otherProfiles: [Profile] {
        profiles
            .filter { $0.id != currentUser && $0.id != secondaryUser }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    
                    List {
                        Section("Active Profiles") {
                               ForEach(activeProfiles) { profile in
                                   if currentUser == profile.id {
                                       profileListItem(profile: profile, inUse: true)
                                           .listRowBackground(Color(uiColor: profile.backgroundColor))
                                   } else {
                                       profileListItem(profile: profile)
                                           .listRowBackground(Color(uiColor: profile.backgroundColor))
                                   }
                               }
                           }

                           Section("Other Profiles") {
                               ForEach(otherProfiles) { profile in
                                   profileListItem(profile: profile)
                                       .listRowBackground(Color(uiColor: profile.backgroundColor))
                               }
                               .onDelete(perform: deleteProfile)
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
                .alert("Change Profile Name", isPresented: $isTitleEditing) {
                    TextField("Enter Profile Name", text: $newProfileName)
                        Button("Save") {
                            if let profile = profileBeingEdited, !newProfileName.isEmpty {
                                if profile.id == currentUser {
                                    switch teamSlot {
                                    case .team1:
                                        viewModel.team1Name = newProfileName
                                    case .team2:
                                        viewModel.team2Name = newProfileName
                                    }
                                } else if profile.id == secondaryUser {
                                    switch teamSlot {
                                    case .team1:
                                        viewModel.team2Name = newProfileName
                                    case .team2:
                                        viewModel.team1Name = newProfileName
                                    }
                                }
                                
                                profile.name = newProfileName
                                profileBeingEdited = nil
                            }
                        }
                        Button("Cancel", role: .cancel) {
                            profileBeingEdited = nil
                        }
                } message: {
                    Text("Enter a new team name")
                }
                .navigationTitle("Profiles")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                    
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        if editMode == .inactive{
                            Button {
                                
                                createProfile()
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
    func profileListItem(profile: Profile, inUse: Bool = false) -> some View {
        HStack {
            Button {
                if !inUse && secondaryUser != profile.id {
                    switch teamSlot {
                    case .team1:
                        viewModel.team1Name = profile.name
                    case .team2:
                        viewModel.team2Name = profile.name
                    }
                    
                    currentUser = profile.id
                    profile.currentScore = 0
                    resetScore()
                    
                }
            } label: {
                HStack {
                    if inUse {
                        Image(systemName: "star.fill")
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(uiColor: profile.textColor))
                    }
                    
                    Text(profile.name)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color(uiColor: profile.textColor))
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
            
                
            Spacer()
            
            Button {
                newProfileName = profile.name
                profileBeingEdited = profile
                isTitleEditing = true
            } label: {
                Text("Edit")
                    .foregroundStyle(Color(uiColor: profile.textColor))
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
        }
        .contentShape(Rectangle())
    }
    
    func createProfile() {
        let newProfile = Profile()
        
        modelContext.insert(newProfile)
        
    }
    
    func deleteProfile(_ indexSet: IndexSet) {
        for index in indexSet {
            let profile = otherProfiles[index]

            modelContext.delete(profile)
        }
    }
    
}

#Preview {
    ProfileListView(currentUser: .constant(""), secondaryUser: .constant(""), teamSlot: TeamSlot.team1, resetScore: {})
}
