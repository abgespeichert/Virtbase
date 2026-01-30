//
//  Feature+server.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import Foundation
import Alamofire

extension Feature {
    static func server(
        session: Session,
        id: String
    ) async throws -> ServerState {
        
        let address = (
            "https://virtbase.com/"
            + "api/v1/kvm/"
            + id
            + "/status"
        )
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let servers = try await session.request(
            address,
            method: .get
        )
        .validate()
        .serializingDecodable(
            ServerState.self,
            decoder: decoder
        )
        .value
        
        return servers
    }
}
