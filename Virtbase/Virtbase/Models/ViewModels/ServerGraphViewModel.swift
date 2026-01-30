//
//  ServerGraphViewModel.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI
import Combine
import Alamofire

private func average(
    graphsArray: [[ServerGraph]]
) -> [ServerGraph] {
    // Find the minimum length to ensure all servers have data for that time point
    guard let minLength = graphsArray.map(\.count).min(), minLength > 0 else {
        return []
    }
    
    var averagedGraphs: [ServerGraph] = []
    
    // For each time point, average across all servers
    for index in 0..<minLength {
        let graphsAtTimePoint = graphsArray.map { $0[index] }
        let count = Double(graphsAtTimePoint.count)
        
        let processor = graphsAtTimePoint.reduce(0.0) { $0 + $1.processor } / count
        let memory    = graphsAtTimePoint.reduce(0.0) { $0 + $1.memory } / count
        let read      = graphsAtTimePoint.reduce(0.0) { $0 + $1.read } / count
        let write     = graphsAtTimePoint.reduce(0.0) { $0 + $1.write } / count
        let incoming  = graphsAtTimePoint.reduce(0.0) { $0 + $1.incoming } / count
        let outgoing  = graphsAtTimePoint.reduce(0.0) { $0 + $1.outgoing } / count
        
        averagedGraphs.append(
            ServerGraph(
                processor: processor,
                memory: memory,
                read: read,
                write: write,
                incoming: incoming,
                outgoing: outgoing
            )
        )
    }
    
    return averagedGraphs
}

class ServerGraphViewModel: ObservableObject {
    
    @Published
    var graphs: [ServerGraph]?
    
    func fetch(
        session: Session
    ) async {
        let servers = try? await Feature.servers(
            session: session
        )
        
        guard let servers, !servers.isEmpty else { return }
        
        var allGraphs: [[ServerGraph]] = []
        
        for server in servers {
            guard let graphArray = try? await Feature.graph(
                session: session,
                id: server.id
            ) else { continue }
            
            allGraphs.append(graphArray)
        }
        
        guard !allGraphs.isEmpty else { return }
        
        let averagedGraphs = average(graphsArray: allGraphs)
        
        await MainActor.run {
            self.graphs = averagedGraphs
        }
    }
}
