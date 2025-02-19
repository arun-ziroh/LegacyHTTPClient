//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public struct HTTPRequest: Sendable {
    
    private var urlComponents: URLComponents = .init()
    
    public var httpMethod: HTTPMethod = .get
    
    // TODO: Maybe we need to make dictionary keys case-Insensitve  -
    public var headers: [String: String] = [:]
    
    public var body: HTTPBody = EmptyBody()
    
    public var url: URL? { urlComponents.url }
    
    private var options = [ObjectIdentifier: any Sendable]()
    
    public init() {
        urlComponents.scheme = "https"
    }
    
    public subscript<O: HTTPRequestOption>(option type: O.Type) -> O.Value {
        get {
            let id = ObjectIdentifier(type)
            
            guard let value = options[id] as? O.Value else { return type.defaultValue }
            
            return value
        }
        set {
            let id = ObjectIdentifier(type)
            options[id] = newValue
        }
    }
}

public extension HTTPRequest {
    
   var scheme: String { urlComponents.scheme ?? "https" }
    
    var host: String {
        get { urlComponents.host ?? "" }
        set { urlComponents.host = newValue }
    }
    
    var path: String {
        get { urlComponents.path }
        set { urlComponents.path = newValue }
    }
}

public extension HTTPRequest {
    
    var serverEnvironment: ServerEnvironment? {
        get { self[option: ServerEnvironment.self] }
        set { self[option: ServerEnvironment.self] = newValue }
    }
}
