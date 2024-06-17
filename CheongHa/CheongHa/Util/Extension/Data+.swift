//
//  Data+.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/25/24.
//

import Foundation

extension Data {
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
