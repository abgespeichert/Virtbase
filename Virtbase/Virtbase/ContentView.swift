//
//  ContentView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 28.01.26.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    private var authenticated: Bool {
        authentication.authenticationState == .authenticated
    }
    
    var body: some View {
        TabView {
            Tab {
                if authenticated {
                    DashboardView()
                } else {
                    WarningView()
                }
            } label: {
                Label(
                    "Übersicht",
                    systemImage: "rectangle.grid.3x1.fill"
                )
            } .disabled(!authenticated)
            
            Tab {
                if authenticated {
                    ServerView()
                } else {
                    WarningView()
                }
            } label: {
                Label(
                    "Server",
                    systemImage: "rectangle.grid.1x3.fill"
                )
                
            } .disabled(!authenticated)
            
            Tab {
                SettingsView()
            } label: {
                Label(
                    "Einstellungen",
                    systemImage: "gear"
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
