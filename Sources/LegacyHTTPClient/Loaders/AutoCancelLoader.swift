//
//  File.swift
//  LegacyHTTPClient
//
//  Created by Arun Kumar on 25/02/25.
//

import Foundation

public class AutoCancelLoader: HTTPLoader {
    
    private let queue = DispatchQueue(label: "AutoCancelLoader")
    
    private var currentTasks = [UUID: HTTPTask]()
    
    public override func load(task: HTTPTask) {
        queue.sync {
            let id = task.id
            currentTasks[id] = task
            task.addCancellationHandler {
                
            }
        }
    }
}
