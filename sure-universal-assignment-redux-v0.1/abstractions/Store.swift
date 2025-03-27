//
//  Store.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/25/25.
//

import Foundation
import os.log

@Observable
public final class Store<State> {
    public private(set) var state: State
    
    private let reducer: any Reducer<State>
    private let middlewares: [any Middleware<State>]
    private let lock = NSRecursiveLock()

    public init(
        initialState state: State,
        reducer: some Reducer<State>,
        middlewares: [any Middleware<State>]
    ) {
        self.state = state
        self.reducer = reducer
        self.middlewares = middlewares
    }
    
    @MainActor
    public func dispatch(_ action: Action) async {
        consoleLog(action)
        lock.withLock { state = reducer.reduce(state, with: action) }
        
        let capturedState = lock.withLock { state }
        await withTaskGroup(of: Optional<Action>.self) { group in
            middlewares.forEach { middleware in
                _ = group.addTaskUnlessCancelled {
                    await middleware.process(state: capturedState, with: action)
                }
            }
            
            for await case let nextAction? in group where !Task.isCancelled {
                await dispatch(nextAction)
            }
        }
    }
    
    private func consoleLog(_ action: Action) {
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "")
        let msg = ">>> \(String(reflecting: action).prefix(100))"
        os_log("%@", log: log, type: .debug, msg)
    }
}
