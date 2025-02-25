//
//  HTTPTask.swift
//  LegacyHTTPClient
//
//  Created by Arun Kumar on 20/02/25.
//

import Foundation

public class HTTPTask: @unchecked Sendable {
    
    private var cancellationHandlers = [() -> Void]()
    
    public var id: UUID { request.id }
    
    private(set) var request: HTTPRequest
    
    private let completion: (HTTPResult) -> Void
    
    private var isCancelled = false
    
    private var isCompleted = false
    
    public init(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        self.request = request
        self.completion = completion
    }
    
    public func complete(with result: HTTPResult) {
        isCompleted = true
        completion(result)
    }
    
    public func modify(request: HTTPRequest) {
        self.request = request
    }
    
    public func fail(code: HTTPError.Code) {
        let error = HTTPError(code: code, request: request, response: nil, underlyingError: nil)
        completion(.failure(error))
    }
    
    public func addCancellationHandler(handler: @escaping () -> Void) {
        // TODO: -
        // 1. Thread Safe
        // 2. What if this was already cancelled ?
        // 3. What if this is already finished
        
        if isCancelled == false || isCompleted == false {
            cancellationHandlers.append(handler)
        }
    }
    
    public func cancel() {
        // TODO: - Use some state to indicate isCancelled is True.
        // Make this thread safe.
        isCancelled = true
        let handlers = cancellationHandlers
        cancellationHandlers = []
        handlers.reversed().forEach { $0() }
    }
}
