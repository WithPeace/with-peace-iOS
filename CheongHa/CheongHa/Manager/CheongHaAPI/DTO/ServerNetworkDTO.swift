//
//  ServerNetworkDTO.swift
//  WithPeace
//
//  Created by Dylan_Y on 6/15/24.
//

import Foundation

struct ServerNetworkDTO<T: Codable>: Codable {
    var data: T?
    var error: ServerNetworkErrorData?
}

struct ServerNetworkErrorData: Codable {
    var code: Int
    var message: String
}
