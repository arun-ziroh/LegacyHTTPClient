//
//  PrintLoader.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

public class PrintLoader: HTTPLoader {
    
    override public func load(request: HTTPRequest, completion: @escaping @Sendable (HTTPResult) -> Void) {
        print("Loading \(request)")
        super.load(request: request) { result in
            print("Got result: \(result)")
            completion(result)
        }
    }
}
