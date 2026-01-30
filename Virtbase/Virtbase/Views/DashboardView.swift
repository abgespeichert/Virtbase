//
//  DashboardView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI

struct DashboardView: View {
    
    @Environment(\.session) private
    var session
    
    @StateObject private var viewModel: ServerGraphViewModel
    = ServerGraphViewModel.init()
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    VStack {
                        if let graphs = viewModel.graphs {
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
                } footer: {
                    Text("Bei diesen Werten handelt es sich um die Gesamtwerte der letzten Stunde. Sie ergeben sich aus allen verfügbaren Servern und stellen einen Durchschnitt.")
                }
                
                
                Section("Verwalten") {
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.grid.1x3.fill")
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 30)
                            Text("Server")
                        }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "firewall.fill")
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 30)
                            Text("Firewall")
                        }
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "globe.badge.clock")
                                .foregroundStyle(.secondary)
                                .frame(minWidth: 30)
                            Text("rDNS")
                        }
                    }
                }
            }
            .navigationTitle("Übersicht")
        }
        .task {
            await viewModel.fetch(
                session: session
            )
        }
    }
}

#Preview {
    DashboardView()
}
