//
//  oscBanApp.swift
//  oscBan
//
//  Created by trs on 4/2/25.
//

import SwiftUI

@main
struct oscBanApp: App {
    
    @StateObject private var oscManager = OSCManager()

    var body: some Scene {
        WindowGroup {
            ContentView(oscManager: oscManager)
                .environmentObject(oscManager)
        }
    }
}
