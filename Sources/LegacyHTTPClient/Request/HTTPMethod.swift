//
//  HTTPMethod.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public enum HTTPMethod: Sendable {
    case get, post, put, patch, delete, custom(String)
    
    var type: String {
        switch self {
        case .get: "GET"
        case .post: "POST"
        case .put: "PUT"
        case .patch: "PATCH"
        case .delete: "DELETE"
        case .custom(let type): type
        }
    }
    
    init(_ value: String) {
        switch value {
        case Self.get.type: self = .get
        case Self.post.type: self = .post
        case Self.put.type: self = .put
        case Self.patch.type: self = .patch
        case Self.delete.type: self = .delete
        default: self = .custom(value)
        }
    }
}
