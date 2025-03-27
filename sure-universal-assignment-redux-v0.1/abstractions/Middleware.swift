//
//  Middleware.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/25/25.
//

import Foundation

public protocol Middleware<State> {
    associatedtype State
//    associatedtype TAction: Action
    
    func process(state: State, with action: Action) async -> Action?
}

struct OptionalMiddleware<UnwrappedState>: Middleware {
    typealias State = Optional<UnwrappedState>
    
    let middleware: any Middleware<UnwrappedState>
    
    func process(state: State, with action: Action) async -> Action? {
        guard let state else {
            return nil
        }
        return await middleware.process(state: state, with: action)
    }
}

extension Middleware {
    public func optional() -> some Middleware<State?> {
        OptionalMiddleware(middleware: self)
    }
}
