//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

public struct ServerEnviornment: Sendable {
    
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

extension ServerEnviornment {
    
    public static let developemnt = ServerEnviornment(host: "development.example.com", pathPrefix: "/api-dev")
    public static let qa = ServerEnviornment(host: "qa.example.com", pathPrefix: "/api")
    public static let staging = ServerEnviornment(host: "staging.example.com", pathPrefix: "/api")
    public static let production = ServerEnviornment(host: "example.com", pathPrefix: "/api")
}
