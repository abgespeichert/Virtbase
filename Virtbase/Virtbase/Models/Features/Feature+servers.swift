//
//  OwnedServer.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import Foundation
import Alamofire

class Feature {
    static func servers(
        session: Session
    ) async throws -> [Server] {
        
        let address = (
            "https://virtbase.com/"
            + "api/v1/kvm/owned"
        )
        
        let servers = try await session.request(
            address,
            method: .get
        )
        .validate()
        .serializingDecodable([Server].self)
        .value
        
        return servers
    }
}
