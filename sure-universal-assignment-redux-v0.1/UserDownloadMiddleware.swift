//
//  UserDownloadMiddleware.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/26/25.
//

import Foundation

@discardableResult
func startTimerTask() -> Task<Void, Never> {
    return Task.detached {
        while !Task.isCancelled {
            // Perform your periodic work here.
            print("Timer fired!")
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            } catch {
                break
            }
        }
    }
}

public actor UserDownloadMiddleware: Middleware {
    struct Dependencies {
        let perform: (Int) async throws -> User
        
        static var live: Dependencies {
            return .init { userId in
                let timer = startTimerTask()
                let user = try await withCheckedThrowingContinuation { continuation in
                    LiveApiClient().fetchUser(byId: userId) { result in
                        switch result {
                        case .success(let user):
                            continuation.resume(returning: user)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
                timer.cancel()
                return user
            }
        }
    }
    
    let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func process(state: AppState, with action: Action) async -> Action? {
        switch action {
        case let action as Actions.WillDownloadUser:
            let user = try? await dependencies.perform(action.userId)
            guard let user = user else { return nil }
            return Actions.UserDownloadSuccess(user: user)
            
        default:
            return nil
        }
    }
}
