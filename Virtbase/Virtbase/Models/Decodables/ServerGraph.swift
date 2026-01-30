//
//  ServerGraph.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

/*
 [{"cpu":0.0125612398009651,"mem":607297331.2,"maxmem":1073741824,"diskread":0,"diskwrite":1085.44,"netin":11582.5766666667,"netout":22.9666666666667,"time":1769782920}, ...]
 */

import Foundation

nonisolated
struct ServerGraph: Decodable {
    var processor: Double
    var memory: Double
    var maxMemory: Double?
    
    var read: Double
    var write: Double
    
    var incoming: Double
    var outgoing: Double
    
    var time: Int?
    
    enum CodingKeys: String, CodingKey {
        case processor = "cpu"
        case memory = "mem"
        case maxMemory = "maxmem"
        case read = "diskread"
        case write = "diskwrite"
        case incoming = "netin"
        case outgoing = "netout"
        case time = "time"
    }
}
