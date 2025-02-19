//
//  ApplyEnvironmentLoader.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

public class ApplyEnvironmentLoader: HTTPLoader {
    
    private let serverEnviornment: ServerEnvironment?
    
    public init(serverEnviornment: ServerEnvironment? = nil) {
        self.serverEnviornment = serverEnviornment
    }
    
    override public func load(request: HTTPRequest, completion: @escaping @Sendable (HTTPResult) -> Void) {
        var copy = request
        
        let requestEnvironment = copy.serverEnvironment ?? serverEnviornment
        
        if let requestEnvironment {
            if copy.host.isEmpty {
                copy.host = requestEnvironment.host
            }
            
            if copy.path.hasPrefix("/") == false {
                copy.path = requestEnvironment.pathPrefix + "/" + copy.path
            }
            
            for (header, value) in requestEnvironment.headers {
                copy.headers[header] = value
            }
        }
        
        super.load(request: copy, completion: completion)
    }
}
