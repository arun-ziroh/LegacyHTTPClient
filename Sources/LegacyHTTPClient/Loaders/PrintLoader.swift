//
//  PrintLoader.swift
//  LegacyHTTPClient
//
//  Created by Arun on 16/02/25.
//

import Foundation

public class PrintLoader: HTTPLoader {
    
    override public func load(task: HTTPTask) {
        print("Loading \(task.request)")
        super.load(task: task)
    }
}
