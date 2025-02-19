//
//  StarWarsAPI.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation
@testable import LegacyHTTPClient

struct StarWarsAPI {
    
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func requestPeople(completion: @escaping @Sendable (PeopleListResponse?, HTTPError?) -> Void) {
        var httpRequest = HTTPRequest()
        httpRequest.path = "people"

        loader.load(request: httpRequest) { result in
            do {
                if let data = result.response?.body {
                    let result = try JSONDecoder().decode(PeopleListResponse.self, from: data)
                    completion(result, nil)
                    return
                }
            }
            catch {
                print("Falied to obtain response: \(error.localizedDescription)")
                let httpError = HTTPError(
                    code: .invalidResponse,
                    request: result.request,
                    response: result.response,
                    underlyingError: error
                )
                completion(nil, httpError)   
            }
        }
    }
    
    func requestPeople(with serverEnvironment: ServerEnvironment?, completion: @escaping @Sendable (PeopleListResponse?, HTTPError?) -> Void) {
        var httpRequest = HTTPRequest()
        httpRequest.path = "people"
        httpRequest.serverEnvironment = serverEnvironment

        loader.load(request: httpRequest) { result in
            do {
                if let data = result.response?.body {
                    let result = try JSONDecoder().decode(PeopleListResponse.self, from: data)
                    completion(result, nil)
                    return
                }
            }
            catch {
                print("Falied to obtain response: \(error.localizedDescription)")
                let httpError = HTTPError(
                    code: .invalidResponse,
                    request: result.request,
                    response: result.response,
                    underlyingError: error
                )
                completion(nil, httpError)
            }
        }
    }
}
