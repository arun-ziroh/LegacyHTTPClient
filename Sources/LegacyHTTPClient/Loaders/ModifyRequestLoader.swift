//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

public class ModifyRequestLoader: HTTPLoader {
    
    private let modifier: (HTTPRequest) -> HTTPRequest
    
    public init(modifier: @escaping (HTTPRequest) -> HTTPRequest) {
        self.modifier = modifier
        super.init()
    }
    
    override public func load(task: HTTPTask) {
        let modifiedRequest = modifier(task.request)
        task.modify(request: modifiedRequest)
        super.load(task: task)
    }
}
