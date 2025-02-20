//
//  CustomPrintLoader.swift
//  LegacyHTTPClient
//
//  Created by Arun Kumar on 19/02/25.
//

import Foundation
@testable import LegacyHTTPClient

final class CustomPrintLoader: PrintLoader {
    
    override func load(request: HTTPRequest, completion: @escaping @Sendable (HTTPResult) -> Void) {
        super.load(request: request) { result in
            print("\(Self.self) load Called")
            completion(result)
        }
    }
    
    override func reset(with group: DispatchGroup) {
        group.enter()
        
        DispatchQueue.global().async {
            print("\(Self.self) Reset Called")
            group.leave()
        }
        
        super.reset(with: group)
    }
}
