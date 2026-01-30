//
//  EnvironmentKey.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI
import Alamofire

// We can define this session key
// So we can inject our session
// Globally, via .environment(\.session)

private struct SessionKey: EnvironmentKey {
    static let defaultValue: Session = .init()
}

extension EnvironmentValues {
    var session: Session {
        get { self[SessionKey.self] }
        set { self[SessionKey.self] = newValue }
    }
}
