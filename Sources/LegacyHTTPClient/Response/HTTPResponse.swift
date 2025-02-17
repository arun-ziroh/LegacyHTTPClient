//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public struct HTTPResponse: Sendable {
    
    public let request: HTTPRequest
    
    private let urlResponse: HTTPURLResponse
    
    public let body: Data?
    
    public var statusCode: Int {
        urlResponse.statusCode
    }
    
    public var message: String {
        HTTPURLResponse.localizedString(forStatusCode: urlResponse.statusCode)
    }
    
    public var headers: [AnyHashable: Any] { urlResponse.allHeaderFields }
    
    public init(request: HTTPRequest, urlResponse: HTTPURLResponse, body: Data?) {
        self.request = request
        self.urlResponse = urlResponse
        self.body = body
    }
}
