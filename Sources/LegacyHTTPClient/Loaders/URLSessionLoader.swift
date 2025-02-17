//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

public class URLSessionLoader: HTTPLoader {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    override public func load(request: HTTPRequest, completion: @escaping @Sendable (HTTPResult) -> Void) {
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

        let dataTask = session.dataTask(with: urlRequest) { data, urlResponse, error in
            let result = HTTPResult(request: request, urlResponse: urlResponse, body: data, error: error)
            completion(result)
        }
        
        dataTask.resume()
    }
}
