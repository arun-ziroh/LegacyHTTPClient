//
//  HTTPError.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public struct HTTPError: Error {
    
    public let code: Code
    
    public let request: HTTPRequest
    
    public let response: HTTPResponse?
    
    public let underlyingError: Error?
    
    public init(code: Code, request: HTTPRequest, response: HTTPResponse? = nil, underlyingError: Error? = nil) {
        self.code = code
        self.request = request
        self.response = response
        self.underlyingError = underlyingError
    }
}

extension HTTPError {
    
    public enum Code: Sendable {
        case invalidRequest
        case cannotConnectToHost
        case notConntectedToInternet
        case connectionLost
        case cancelled
        case insecureConnection
        case invalidResponse
        case unknown
    }
}

extension HTTPError.Code {
    
    init(_ code: URLError.Code) {
        switch code {
        case .badURL: self = .invalidRequest
        case .cannotFindHost, .cannotConnectToHost: self = .cannotConnectToHost
        case .notConnectedToInternet: self = .notConntectedToInternet
        case .badServerResponse: self = .invalidResponse
        case .networkConnectionLost: self = .connectionLost
        default: self = .unknown
        }
    }
}
