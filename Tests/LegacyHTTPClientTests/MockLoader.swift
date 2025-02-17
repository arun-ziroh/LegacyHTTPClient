//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation
@testable import LegacyHTTPClient

class MockLoader: HTTPLoader {
    
    typealias HTTPHandler = (HTTPResult) -> Void
    
    typealias MockHandler = (HTTPRequest, HTTPHandler) -> Void
    
    private var handlers = [MockHandler]()
    
    override func load(request: HTTPRequest, completion: @escaping @Sendable HTTPHandler) {
        if handlers.isEmpty == false {
            let next = handlers.removeFirst()
            next(request, completion)
        }
        else {
            completion(.failure(HTTPError(code: .unknown, request: request, response: nil, underlyingError: nil)))
        }
    }
    
    @discardableResult
    func then(_ handler: @escaping MockHandler) -> Self {
        handlers.append(handler)
        return self
    }
}
