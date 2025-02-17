//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public struct DataBody: HTTPBody {
    
    public var isEmpty: Bool { data.isEmpty }
    
    public let additionalHeaders: [String : String]
    
    private let data: Data
    
    init(data: Data, additionalHeaders: [String: String] = [:]) {
        self.data = data
        self.additionalHeaders = additionalHeaders
    }
    
    public func encode() throws -> Data {
        data
    }
}
