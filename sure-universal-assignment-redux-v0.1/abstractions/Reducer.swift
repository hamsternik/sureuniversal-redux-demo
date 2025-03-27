//
//  Reducer.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/25/25.
//

import Foundation

public protocol Reducer<State> {
    associatedtype State
//    associatedtype TAction
    
    func reduce(_ state: State, with action: Action) -> State
}

public struct IdentityReducer<State>: Reducer {
    public func reduce(_ oldState: State, with action: Action) -> State {
        oldState
    }
}
