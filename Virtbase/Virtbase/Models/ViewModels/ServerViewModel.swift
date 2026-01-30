//
//  ServerViewModel.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI
import Combine
import Alamofire

class ServerViewModel: ObservableObject {
    
    @Published
    var servers: [Server]?
    
    func fetch(
        session: Session
    ) async {
        let servers = try? await Feature.servers(
            session: session
        )
        self.servers = servers
    }
}
