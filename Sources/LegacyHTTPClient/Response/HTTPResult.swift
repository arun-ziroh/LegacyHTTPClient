//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public typealias HTTPResult = Result<HTTPResponse, HTTPError>

extension HTTPResult {
    
    init(request: HTTPRequest, urlResponse: URLResponse?, body: Data?, error: Error?) {
        
        var httpResponse: HTTPResponse?
        if let urlResponse = urlResponse as? HTTPURLResponse {
            httpResponse = HTTPResponse(request: request, urlResponse: urlResponse, body: body)
        }
        
        if let urlError = error as? URLError {
            let httpError = HTTPError(code: .init(urlError.code), request: request, response: httpResponse, underlyingError: error)
            self = .failure(httpError)
        }
        else if let error {
            let httpError = HTTPError(code: .unknown, request: request, response: httpResponse, underlyingError: error)
            self = .failure(httpError)
        }
        else if let httpResponse {
            self = .success(httpResponse)
        }
        else {
            self = .failure(HTTPError(code: .unknown, request: request, response: httpResponse, underlyingError: error))
        }
    }
    
    public var request: HTTPRequest {
        switch self {
        case .success(let response): response.request
        case .failure(let error): error.request
        }
    }
    
    public var response: HTTPResponse? {
        switch self {
        case .success(let response): response
        case .failure(let error): error.response
        }
    }
    
    public var httpError: HTTPError? {
        if case Result.failure(let error) = self {
            return error
        }
        return nil
    }
}
