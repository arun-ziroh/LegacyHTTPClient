//
//  HTTPLoading.swift
//  LegacyHTTPClient
//
//  Created by Arun on 15/02/25.
//

import Foundation

public protocol HTTPLoading {
    
    func load(request: HTTPRequest, completion: @escaping @Sendable (HTTPResult) -> Void)
}

extension URLSession: HTTPLoading {
    
    public func load(request: HTTPRequest, completion: @escaping @Sendable (HTTPResult) -> Void) {
        
        guard let url = request.url else {
            completion(
                .failure(
                    .init(
                        code: .invalidRequest,
                        request: request,
                        response: .init(request: request, urlResponse: .init(), body: nil),
                        underlyingError: nil
                    )
                )
            )
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.type
        var headers = request.headers
        
        if request.body.isEmpty == false {
            for (key, value) in request.body.additionalHeaders {
                headers[key] = value
            }
            do {
                urlRequest.httpBody = try request.body.encode()
            }
            catch {
                print("Failed to encode body: \(error.localizedDescription)")
                completion(
                    .failure(
                        .init(
                            code: .invalidRequest,
                            request: request,
                            response: .init(request: request, urlResponse: .init(), body: nil),
                            underlyingError: error
                        )
                    )
                )
                return
            }
        }
        urlRequest.allHTTPHeaderFields = headers

        let dataTask = self.dataTask(with: urlRequest) { data, urlResponse, error in
            let result = HTTPResult(request: request, urlResponse: urlResponse, body: data, error: error)
            completion(result)
        }
        
        dataTask.resume()
    }
}
