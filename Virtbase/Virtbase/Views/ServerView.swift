//
//  ServerView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI

struct ServerView: View {
    
    @Environment(\.openURL)
    private var openURL
    
    @Environment(\.session) private
    var session
    
    @StateObject private var viewModel: ServerViewModel
    = ServerViewModel.init()
    
    private let purchaseURL = URL(
        string: "https://virtbase.com/de"
    )!
    
    var body: some View {
        NavigationStack {
            List {
                Button {
                    openURL(purchaseURL)
                } label: {
                    HStack {
                        Text("Server Mieten")
                        Spacer(minLength: 0)
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("Server") {
                    if let servers = viewModel.servers {
                        ForEach(servers) { server in
                            ServerListView(server: server)
                        }
                    } else {
                        Text("Keine Server")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                    }
                }
            }
            .navigationTitle("Server")
        }
        .task {
            await viewModel.fetch(
                session: session
            )
        }
    }
}

#Preview {
    ServerView()
}
