//
//  Pong_TallyApp.swift
//  Pong Tally
//
//  Created by Alek Vasek on 1/12/25.
//

import SwiftUI
import SwiftData

@main
struct Pong_TallyApp: App {
    
    init() {
        ValueTransformer.setValueTransformer(UIColorValueTransformer(), forName: NSValueTransformerName("UIColorValueTransformer"))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: Profile.self)
    }
}
