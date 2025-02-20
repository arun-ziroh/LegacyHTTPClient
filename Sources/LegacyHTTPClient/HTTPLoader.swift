//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

// TODO: Author wants to encapsulte some common logic so he replaced HTTPLoading Protocol with this class.
open class HTTPLoader {
    
    public var nextLoader: HTTPLoader? {
        willSet {
            guard nextLoader == nil else { fatalError("The next loader may only be set once.") }
        }
    }
    
    public init() { }
    
    open func load(task: HTTPTask) {
        if let nextLoader {
            nextLoader.load(task: task)
        }
        else {
            task.fail(code: .cannotConnect)
        }
    }
    
    open func reset(with group: DispatchGroup) {
        nextLoader?.reset(with: group)
    }
}

extension HTTPLoader {
    
    public func load(request: HTTPRequest, completion: @escaping @Sendable (HTTPResult) -> Void) -> HTTPTask {
        let task = HTTPTask(request: request, completion: completion)
        self.load(task: task)
        return task
    }
    
    public final func reset(on queue: DispatchQueue = .main, completionHandler: @escaping @Sendable () -> Void) {
        let group = DispatchGroup()
        self.reset(with: group)
        group.notify(queue: queue, execute: completionHandler)
    }
}
