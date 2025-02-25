//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun Kumar on 19/02/25.
//

import Foundation

public class ResetGuardLoader: HTTPLoader, @unchecked Sendable {
    
    public var isResetting = false
    
    override public func load(task: HTTPTask) {
        if isResetting == false {
            super.load(task: task)
        }
        else {
            task.fail(code: .resetInProgress)
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
