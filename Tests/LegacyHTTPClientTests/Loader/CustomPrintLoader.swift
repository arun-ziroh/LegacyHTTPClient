//
//  CustomPrintLoader.swift
//  LegacyHTTPClient
//
//  Created by Arun Kumar on 19/02/25.
//

import Foundation
@testable import LegacyHTTPClient

final class CustomPrintLoader: PrintLoader {
    
    override func load(task: HTTPTask) {
        super.load(task: task)
    }
    
    override func reset(with group: DispatchGroup) {
        group.enter()
        
        DispatchQueue.global().async {
            print("\(Self.self) Reset Called")
            group.leave()
        }
        
        super.reset(with: group)
    }
}
