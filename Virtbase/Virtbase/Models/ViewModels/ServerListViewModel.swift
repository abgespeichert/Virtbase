//
//  ServerListViewModel.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//


import SwiftUI
import Combine
import Alamofire

class ServerListViewModel: ObservableObject {
    
    @Published
    var serverState: ServerState?
    
    func fetch(
        session: Session,
        id: String
    ) async {
        let serverState = try? await Feature.server(
            session: session,
            id: id
        )
        
        self.serverState = serverState
    }
}
