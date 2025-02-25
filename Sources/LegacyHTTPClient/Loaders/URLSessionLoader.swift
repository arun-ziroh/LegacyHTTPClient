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
    
    override public func load(task: HTTPTask) {
        let request = task.request
        
        guard let url = request.url else {
            task.fail(code: .invalidRequest)
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
                task.fail(code: .invalidRequest)
                return
            }
        }
        urlRequest.allHTTPHeaderFields = headers

        let dataTask = session.dataTask(with: urlRequest) { data, urlResponse, error in
            let result = HTTPResult(request: request, urlResponse: urlResponse, body: data, error: error)
            task.complete(with: result)
        }
        
        task.addCancellationHandler { dataTask.cancel() }
        
        dataTask.resume()
    }
}
