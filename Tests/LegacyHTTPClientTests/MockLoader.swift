//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation
@testable import LegacyHTTPClient

final class MockLoader: HTTPLoader {
    
    typealias HTTPHandler = (HTTPResult) -> Void
    typealias MockHandler = (HTTPRequest, HTTPHandler) -> Void
    
    private var handlers = [MockHandler]()
    
    override func load(task: HTTPTask) {
        if handlers.isEmpty == false {
            let handler = handlers.removeFirst()
            handler(task.request, task.complete(with:))
        }
        else {
            task.fail(code: .unknown)
        }
    }
    
    @discardableResult
    func add(_ handler: @escaping MockHandler) -> Self {
        handlers.append(handler)
        return self
    }
}
