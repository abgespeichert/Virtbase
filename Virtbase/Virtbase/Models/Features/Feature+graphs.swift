//
//  Feature+graphs.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import Foundation
import Alamofire



extension Feature {
    static func graph(
        session: Session,
        id: String
    ) async throws -> [ServerGraph] {
        
        let address = (
            "https://virtbase.com/"
            + "api/v1/kvm/"
            + id
            + "/graphs"
        )
        
        let parameters: [String: String] = [
            "timeframe": "hour"
        ]
        
        let graphs = try await session.request(
            address,
            method: .get,
            parameters: parameters
        )
        .validate()
        .serializingDecodable(
            [ServerGraph].self
        )
        .value
        
        return graphs
    }
}
