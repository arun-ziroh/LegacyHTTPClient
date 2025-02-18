//
//  ServerEnvironment.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

public struct ServerEnvironment: HTTPRequestOption, Sendable {
    
    public static let defaultOptionValue: ServerEnvironment? = nil
    
    public var host: String
    public var pathPrefix: String
    public var headers: [String: String]
    public var query: [URLQueryItem]
    
    public init(host: String, pathPrefix: String = "/", headers: [String : String] = [:], query: [URLQueryItem] = []) {
        self.host = host
        self.pathPrefix = pathPrefix
        self.headers = headers
        self.query = query
    }
}

extension ServerEnvironment {
    
    public static let developemnt = ServerEnvironment(host: "development.example.com", pathPrefix: "/api-dev")
    public static let qa = ServerEnvironment(host: "qa.example.com", pathPrefix: "/api")
    public static let staging = ServerEnvironment(host: "staging.example.com", pathPrefix: "/api")
    public static let production = ServerEnvironment(host: "example.com", pathPrefix: "/api")
}
