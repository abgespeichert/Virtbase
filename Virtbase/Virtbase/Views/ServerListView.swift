//
//  ServerListView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI

struct ServerListView: View {
    
    @Environment(\.session) private
    var session
    
    @StateObject private var viewModel: ServerListViewModel
    = ServerListViewModel.init()
    
    var server: Server
    
    var body: some View {
        NavigationLink {
            ServerDetailView(
                server: server
            )
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(server.name)
                    
                    /*
                     Text("Online")
                         .font(.caption)
                         .foregroundStyle(.white)
                         .padding(.vertical, 2)
                         .padding(.horizontal, 4)
                         .background {
                             Capsule()
                                 .foregroundStyle(.green)
                         }
                     */
                }
                
                if let serverState = viewModel.serverState,
                   let terminate = serverState.terminate {
                    TimeLeftView(expire: terminate)
                } else {
                    ProgressView()
                }
            }
        }
        .task {
            await viewModel.fetch(
                session: session,
                id: server.id
            )
        }
    }
}
