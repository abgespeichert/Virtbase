//
//  SettingsView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.openURL)
    private var openURL
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    @State private
    var token: String = ""
    
    private let registrationURL = URL(
        string: "https://app.virtbase.com/register"
    )!
    
    private let creationURL = URL(
        string: "https://app.virtbase.com/account/settings/api"
    )!
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SecureField("sk_...", text: $token)
                        .monospaced()
                        .keyboardType(.asciiCapable)
                        .submitLabel(.continue)
                        .onSubmit {
                            Task {
                                do {
                                    try await authentication.authenticate(
                                        token: token
                                    )
                                    
                                    token = ""
                                } catch {
                                    print(error)
                                }
                            }
                        }
                } header: {
                    if authentication.authenticationState == .authenticated {
                        Text("Schlüssel Aktualisieren")
                    } else {
                        Text("Schlüssel")
                    }
                } footer: {
                    Text("Die Virtbase App benötigt einen Schlüssel, den du in deinem Virtbase Account erstellen kannst, um Daten von deinen Servern abrufen und gegebenfalls zu bearbeiten. Du solltest diesen Schlüssel unter keinen Umständen weitergeben.")
                }
                
                if authentication.authenticationState == .processing {
                    HStack {
                        ProgressView()
                        Text("Überprüfung")
                    }
                }
                
                if authentication.authenticationState == .authenticated {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.title3)
                        
                        Text("Angemeldet")
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            do {
                                try authentication.deauthenticate()
                            } catch {
                                print(error)
                            }
                        } label: {
                            Label(
                                "Abmelden",
                                systemImage: "trash"
                            )
                        }
                    }
                }
                
                Section("Virtbase") {
                    Button {
                        openURL(creationURL)
                    } label: {
                        HStack {
                            Text("Schlüssel Erstellen")
                            Spacer(minLength: 0)
                            Image(systemName: "arrow.up.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Button {
                        openURL(registrationURL)
                    } label: {
                        HStack {
                            Text("Account Erstellen")
                            Spacer(minLength: 0)
                            Image(systemName: "arrow.up.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Einstellungen")
        }
    }
}

#Preview {
    SettingsView()
}
