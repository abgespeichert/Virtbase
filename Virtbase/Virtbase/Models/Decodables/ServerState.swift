//
//  ServerState.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

/*
 {
   "status": "RUNNING",
   "task": "REBOOTING",
   "stats": {
     "netin": 1000,
     "netout": 1000,
     "uptime": 1000,
     "mem": 1000,
     "freemem": 1073700000,
     "maxmem": 1073700000,
     "disk": 10737000000,
     "cpu": 0.5,
     "maxdisk": 1000,
     "cpus": 1
   },
   "installedAt": "2026-01-01T00:00:00Z",
   "suspendedAt": "2026-01-01T00:00:00Z",
   "terminatesAt": "2026-01-01T00:00:00Z"
 }
 */

import Foundation

nonisolated
struct ServerStateStatistics: Decodable {
    var netin: Int
    var netout: Int
    var uptime: Int
    var mem: Int
    var freemem: Int
    var maxmem: Int
    var disk: Int
    var cpu: Double
    var maxdisk: Int
    
    enum CodingKeys: CodingKey {
        case netin
        case netout
        case uptime
        case mem
        case freemem
        case maxmem
        case disk
        case cpu
        case maxdisk
    }
}

nonisolated
enum ServerStateStatus: String, Codable {
    case running = "RUNNING"
    case stopped = "STOPPED"
    case paused = "PAUSED"
    case suspended = "SUSPENDED"
    case unknown = "UNKNOWN"
}

nonisolated
struct ServerState: Decodable {
    
    var status: ServerStateStatus
    var task: String?
    
    var statistics: ServerStateStatistics?
    
    var installed: Date?
    var suspended: Date?
    var terminate: Date?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case task = "task"
        case statistics = "stats"
        case installed = "installedAt"
        case suspended = "suspendedAt"
        case terminate = "terminatesAt"
    }
}
