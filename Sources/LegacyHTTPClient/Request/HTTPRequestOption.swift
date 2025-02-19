//
//  HTTPRequestOption.swift
//  LegacyHTTPClient
//
//  Created by Arun Kumar on 18/02/25.
//

import Foundation

public protocol HTTPRequestOption {
    
    associatedtype Value: Sendable
    
    static var defaultValue: Value { get }
}
