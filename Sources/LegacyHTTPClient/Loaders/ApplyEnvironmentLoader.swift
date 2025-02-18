//
//  ApplyEnvironmentLoader.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

public class ApplyEnvironmentLoader: HTTPLoader {
    
    private let serverEnvironment: ServerEnvironment
    
    public init(serverEnvironment: ServerEnvironment) {
        self.serverEnvironment = serverEnvironment
        super.init()
    }
    
    override public func load(request: HTTPRequest, completion: @escaping @Sendable (HTTPResult) -> Void) {
        var copy = request
        
        let requestEnvironment = request.serverEnvironment ?? serverEnvironment
        
        if copy.host.isEmpty {
            copy.host = requestEnvironment.host
        }
        
        if copy.path.hasPrefix("/") == false {
            copy.path = requestEnvironment.pathPrefix + copy.path
        }
        
        for (header, value) in requestEnvironment.headers {
            copy.headers[header] = value
        }
        
        super.load(request: copy, completion: completion)
    }
}
