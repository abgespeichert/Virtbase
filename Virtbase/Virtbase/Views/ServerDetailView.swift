//
//  ServerDetailView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI

struct ServerDetailView: View {
    
    @Environment(\.session) private
    var session
    
    @StateObject private var infoModel: ServerDetailGraphViewModel
    = ServerDetailGraphViewModel.init()
    
    @StateObject private var detailsModel: ServerListViewModel
    = ServerListViewModel.init()
    
    var server: Server
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack {
                        if let graphs = infoModel.samples {
                            GraphView(
                                samples: graphs
                            )
                        } else {
                            ProgressView()
                                .frame(minHeight: 200)
                        }
                        
                        HStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(width: 8, height: 20)
                                    .foregroundStyle(.yellow)
                                Text("CPU")
                                    .monospaced()
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(width: 8, height: 20)
                                    .foregroundStyle(.green)
                                Text("RAM")
                                    .monospaced()
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        }
                        
                        HStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(width: 8, height: 20)
                                    .foregroundStyle(.teal)
                                Text("Schreiben")
                                    .monospaced()
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(width: 8, height: 20)
                                    .foregroundStyle(.purple)
                                Text("Lesen")
                                    .monospaced()
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        }
                        
                        HStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(width: 8, height: 20)
                                    .foregroundStyle(.blue)
                                Text("Eingehend")
                                    .monospaced()
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .frame(width: 8, height: 20)
                                    .foregroundStyle(.orange)
                                Text("Ausgehend")
                                    .monospaced()
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        }
                    }
                } header: {
                    Text("Übersicht")
                }
                
                Section("Details") {
                    VStack(alignment: .leading) {
                        Text(server.name)
                        Text(server.template.name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    switch detailsModel.serverState?.status {
                    case .running:
                        HStack {
                            Circle()
                                .frame(width: 10)
                                .foregroundStyle(.green)
                            
                            Text("Läuft")
                        }
                    case .stopped:
                        HStack {
                            Circle()
                                .frame(width: 10)
                                .foregroundStyle(.red)
                            
                            Text("Gestoppt")
                        }
                    case .paused:
                        HStack {
                            Circle()
                                .frame(width: 10)
                                .foregroundStyle(.yellow)
                            
                            Text("Pausiert")
                        }
                    case .suspended:
                        HStack {
                            Circle()
                                .frame(width: 10)
                                .foregroundStyle(.gray)
                            
                            Text("Suspendiert")
                        }
                    case .unknown:
                        HStack {
                            Circle()
                                .frame(width: 10)
                                .foregroundStyle(.tertiary)
                            
                            Text("Unbekannt")
                        }
                    case nil:
                        EmptyView()
                    }
                }
                
                Section("Aktionen") {
                    if detailsModel.serverState?.status == .running {
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "stop.fill")
                                    .frame(minWidth: 30)
                                Text("Stoppen")
                            }
                        }
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "pause.fill")
                                    .frame(minWidth: 30)
                                Text("Pausieren")
                            }
                        }
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "inset.filled.square")
                                    .frame(minWidth: 30)
                                Text("Suspendieren")
                            }
                        }
                    } else if detailsModel.serverState?.status == .paused ||
                              detailsModel.serverState?.status == .suspended {
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "playpause.fill")
                                    .frame(minWidth: 30)
                                Text("Fortfahren")
                            }
                        }
                    } else if detailsModel.serverState?.status == .stopped {
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "play.fill")
                                    .frame(minWidth: 30)
                                Text("Starten")
                            }
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .frame(minWidth: 30)
                            Text("Neustarten")
                        }
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                                .frame(minWidth: 30)
                            Text("Löschen")
                        }
                    }
                }
            }
            .navigationTitle("Server")
        }
        .task {
            await infoModel.fetch(
                session: session,
                id: server.id
            )
            await detailsModel.fetch(
                session: session,
                id: server.id
            )
        }
    }
}
