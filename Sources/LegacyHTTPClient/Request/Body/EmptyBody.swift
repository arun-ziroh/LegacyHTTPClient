//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public struct EmptyBody: HTTPBody {
    
    public let isEmpty = true 
    
    public func encode() throws -> Data { Data() }
}
