//
//  AuthenticationModel.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import Foundation
import Alamofire
import Combine

enum AuthenticationState: CaseIterable {
    case processing
    case authenticated
    case deauthenticated
}

class AuthenticationModel: ObservableObject {
    
    @Published
    var authenticationState: AuthenticationState
    = AuthenticationState.deauthenticated
    
    @Published
    var session: Session
    
    private let keychainModel: KeychainModel
    = KeychainModel.shared
    
    // Validate token by calling get-session
    // API keys don't return user data for some reason
    // we just need the 200 code and were good
    let authenticationPath: String = (
        "https://virtbase.com/"
        + "api/auth/get-session"
    )
    
    init() {
        
        // basic session configuration
        // set proper timeouts
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60

        // initialize session with configuration
        // interceptor acts as our middleware for auth
        self.session = Session(
            configuration: configuration,
            interceptor: Interceptor()
        )
        
        // Validate token by calling get-session
        // API keys don't return user data for some reason
        // we just need the 200 code and were good
        
        self.authenticationState =
        AuthenticationState.processing
        
        Task {
            do {
                let _ = try await session.request(
                    authenticationPath,
                    method: .get
                )
                .validate()
                .serializingData()
                .value
                
                self.authenticationState =
                AuthenticationState.authenticated
            } catch {
                self.authenticationState =
                AuthenticationState.deauthenticated
            }
        }
    }
    
    // this is logging out
    // funny because its so easy
    // just delete keychain
    func deauthenticate() throws {
        try KeychainModel.shared.clear()
        self.authenticationState =
        AuthenticationState.deauthenticated
    }
    
    func authenticate(
        token: String
    ) async throws {
        
        // write the token to keychain
        // will also write to cache
        try KeychainModel.shared.write(
            token: token
        )
        
        let _ = try await session.request(
            authenticationPath,
            method: .get
        )
        .validate()
        .serializingData()
        .value
        
        self.authenticationState =
        AuthenticationState.authenticated
    }
}
