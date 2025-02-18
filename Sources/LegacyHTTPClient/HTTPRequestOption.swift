//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 17/02/25.
//

import Foundation

public protocol HTTPRequestOption {
    
    associatedtype Value: Sendable
    
    static var defaultOptionValue: Value { get }
}
