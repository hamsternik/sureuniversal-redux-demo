//
//  DownloadUsersMiddleware.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/26/25.
//

import Foundation
import Combine

public actor DownloadUsersMiddleware: Middleware {
    public func process(state: AppState, with action: Action) async -> Action? {
        switch action {
        case is Actions.StartFetchUsers:
            return Actions.WillDownloadUser(userId: state.users.count+1)
            
        case is Actions.UserDownloadSuccess where state.isLoading == true:
            guard state.users.count < 10 else {
                return Actions.FinishFetchUsers()
            }
            return Actions.WillDownloadUser(userId: state.users.count+1)
            
        default:
           return nil
        }
    }
}
