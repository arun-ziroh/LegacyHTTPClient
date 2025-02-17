//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public protocol HTTPBody: Sendable {
    
    var isEmpty: Bool { get }
    
    var additionalHeaders: [String: String] { get }
    
    func encode() throws -> Data
}

public extension HTTPBody {
    
    var isEmpty: Bool { false }
    
    var additionalHeaders: [String: String] { [:] }
}
