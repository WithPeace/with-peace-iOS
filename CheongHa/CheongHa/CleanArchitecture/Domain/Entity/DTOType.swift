//
//  DTOType.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/6/24.
//

import Foundation

protocol DTOType: Codable {
    associatedtype DataType
    
    var data: DataType { get }
    var error: Errors? { get }
}


struct Errors: Codable {
    var code: Int?
    var message: String?
}
