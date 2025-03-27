//
//  AppState.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/26/25.
//

import Foundation

public struct AppState {
    var isLoading = false
    var users: [User] = []
    var errorDescription: String? = nil
}

public struct AppReducer: Reducer {
    public func reduce(_ state: AppState, with action: Action) -> AppState {
        var newState = state
        
        switch action {
        case is Actions.StartFetchUsers:
            newState.isLoading = true
            newState.users = []
            
        case is Actions.FinishFetchUsers:
            newState.isLoading = false
            
        case is Actions.StopFetchUsers:
            newState.isLoading = false
            newState.users = []
            
        case is Actions.WillDownloadUser:
            break

        case let action as Actions.UserDownloadSuccess:
            newState.isLoading = true
            newState.users.append(action.user)

        case let action as Actions.UserDownloadFailure:
            newState.errorDescription = action.errorDescription
            
        default:
            fatalError("Failed to handle the action: \(action)")
        }
        
        return newState
    }
}
