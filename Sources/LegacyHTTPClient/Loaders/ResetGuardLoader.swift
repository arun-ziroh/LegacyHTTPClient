//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun Kumar on 19/02/25.
//

import Foundation

public class ResetGuardLoader: HTTPLoader, @unchecked Sendable {
    
    public var isResetting = false
    
    public override func load(request: HTTPRequest, completion: @escaping @Sendable (HTTPResult) -> Void) {
        if isResetting == false {
            super.load(request: request, completion: completion)
        }
        else {
            let error = HTTPError(code: .resetInProgress, request: request)
            completion(.failure(error))
        }
    }
    
    public override func reset(with group: DispatchGroup) {
        if isResetting {
            print("Resetting is already in progress.")
            return
        }
        
        guard let nextLoader else {
            print("There is no next loader.")
            return
        }
        
        group.enter()
        isResetting = true
        nextLoader.reset {
            self.isResetting = false
            group.leave()
        }
    }
}
