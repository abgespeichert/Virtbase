//
//  VirtbaseApp.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 28.01.26.
//

import SwiftUI
@main
struct VirtbaseApp: App {
    
    @StateObject private
    var authentication: AuthenticationModel
    = AuthenticationModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authentication)
                .environment(\.session, authentication.session)
        }
    }
}
