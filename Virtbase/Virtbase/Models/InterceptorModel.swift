//
//  InterceptorModel.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import Alamofire
import Foundation


// this interceptor takes all of our network requests
// and puts the virtbase api token in there
// its basically a middleware

// @unchecked Sendable is required for Swift 6
// otherwise we get a concurency warning/error
final class Interceptor: RequestInterceptor, @unchecked Sendable {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        
        request.setValue("https://virtbase.com", forHTTPHeaderField: "Origin")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let keychain = KeychainModel.shared
            let token = try keychain.read()
            
            request.setValue(
                token,
                forHTTPHeaderField: "X-Virtbase-API-Key"
            )
        } catch {
            completion(.failure(error))
        }
        
        
        completion(.success(request))
    }
}
