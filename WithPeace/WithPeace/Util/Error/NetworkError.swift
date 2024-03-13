//
//  NetworkError.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/12/24.
//

enum NetworkError: Error {
    case defaultsError
    case responseError
    case getDataError
    case finishedToken401
    
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case unprocessableEntity
    case internalServerError
}
