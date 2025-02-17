//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation
@testable import LegacyHTTPClient

struct StarWarsAPI {
    
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader) {
        let modifierLoader = ModifyRequestLoader { request in
            var copy = request
            
            if copy.host.isEmpty {
                copy.host = "swapi.dev"
            }
            
            if copy.path.hasPrefix("/") == false {
                copy.path = "/api/" + copy.path
            }
            
            return copy
        }
        self.loader =  modifierLoader --> loader
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
}
