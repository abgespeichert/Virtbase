//
//  ServerDetailGraphViewModel.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI
import Combine
import Alamofire

class ServerDetailGraphViewModel: ObservableObject {
    
    @Published
    var samples: [ServerGraph]?
    
    func fetch(
        session: Session,
        id: String
    ) async {
        let samples = try? await Feature.graph(
            session: session,
            id: id
        )
        
        self.samples = samples
    }
}
