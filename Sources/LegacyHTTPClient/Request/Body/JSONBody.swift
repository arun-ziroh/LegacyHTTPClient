//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public struct JSONBody: HTTPBody {
    
    public var isEmpty: Bool { false }
    
    private let encodeClosure: @Sendable () throws -> Data
    
    public var additionalHeaders: [String : String] = ["Content-Type": "application/json; charset=utf-8"]
    
    init<T: Encodable & Sendable>(value: T, encoder: JSONEncoder = JSONEncoder()) {
        encodeClosure = {  try encoder.encode(value) }
    }
    
    public func encode() throws -> Data {
        try encodeClosure()
    }
}
