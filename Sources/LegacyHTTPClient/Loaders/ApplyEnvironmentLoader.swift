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
    
    public override func load(task: HTTPTask) {
        var copy = task.request
        
        let env = copy.serverEnvironment ?? serverEnviornment
        
        if let env {
            if copy.host.isEmpty {
                copy.host = env.host
            }
            
            if copy.path.hasPrefix("/") == false {
                copy.path = env.pathPrefix + "/" + copy.path
            }
            
            for (header, value) in env.headers {
                copy.headers[header] = value
            }
        }
        task.modify(request: copy)
        super.load(task: task)
    }
}
