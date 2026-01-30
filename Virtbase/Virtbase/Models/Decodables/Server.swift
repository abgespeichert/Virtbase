//
//  Server.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

/*
[
  {
    "id": "kvm_1KE70TXYSKKZX95SM9TD2E3W1",
    "vmid": 1000,
    "name": "vb1000",
    "kvmPackage": {
      "id": "pck_1KDR2MQPZEBG7XYVNBDCW8D88",
      "cores": 1,
      "memory": 1024,
      "storage": 100,
      "netrate": 1000
    },
    "template": {
      "id": "temp_1KDR2S9RDDG7P8Z4KS3DHHPH2",
      "name": "Debian 12 (Bookworm)",
      "icon": "debian"
    }
  }
]
*/

import Foundation

nonisolated
struct ServerPackage: Identifiable, Decodable {
    var id: String
    var cores: Double
    var memory: Int
    var storage: Int
    var netrate: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cores = "cores"
        case memory = "memory"
        case storage = "storage"
        case netrate = "netrate"
    }
}

nonisolated
struct ServerTemplate: Identifiable, Decodable {
    var id: String
    var name: String
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case icon = "icon"
    }
}

nonisolated
struct Server: Identifiable, Decodable {
    var id: String
    var name: String
    
    var package: ServerPackage
    var template: ServerTemplate
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case package = "kvmPackage"
        case template = "template"
    }
}
