//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

public class ApplyEnviornmentLoader: HTTPLoader {
    
    private let serverEnviornment: ServerEnviornment
    
    init(serverEnviornment: ServerEnviornment) {
        self.serverEnviornment = serverEnviornment
    }
    
    override public func load(request: HTTPRequest, completion: @escaping @Sendable (HTTPResult) -> Void) {
        var copy = request
        
        if copy.host.isEmpty {
            copy.host = serverEnviornment.host
        }
        
        if copy.path.hasPrefix("/") == false {
            copy.path = serverEnviornment.pathPrefix + copy.path
        }
        
        for (header, value) in request.headers {
            copy.headers[header] = value
        }
        
        super.load(request: copy, completion: completion)
    }
}
