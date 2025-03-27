//
//  sure_universal_assignment_redux_v0_1App.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/25/25.
//

import SwiftUI

public protocol Action {}
enum Actions {
    struct StartFetchUsers: Action {}
    struct FinishFetchUsers: Action {}
    struct StopFetchUsers: Action {}
    struct WillDownloadUser: Action {
        let userId: Int
    }
    struct UserDownloadSuccess: Action {
        let user: User
    }
    struct UserDownloadFailure: Action {
        let errorDescription: String
    }
}

@main
struct Application: App {
    @State var store = Store<AppState>(
        initialState: AppState(),
        reducer: AppReducer(),
        middlewares: [
            DownloadUsersMiddleware(),
            UserDownloadMiddleware(dependencies: .live)
        ]
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
