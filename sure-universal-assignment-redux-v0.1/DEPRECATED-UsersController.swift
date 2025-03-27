//
//  DEPRECATED-UsersController.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/26/25.
//

import Foundation
import Combine

public struct DispatchSourceConfiguration {
    public let queue: DispatchQueue
    public let repeatingInterval: DispatchTimeInterval
    
    public static let live: DispatchSourceConfiguration = .init(
        queue: DispatchQueue(
            label: "com.sureuniversal.apiclient.queue",
            qos: .utility /// these task are low priority but have higher priority than .background QoS
        //    qos: .userInitiated /// these tasks are high priority but do not necessarily need to run on the main thread
        ),
        repeatingInterval: .seconds(1)
    )
    
    public static let mock: DispatchSourceConfiguration = .init(
        queue: .global(),
        repeatingInterval: .milliseconds(10)
    )
}

public protocol UsersController: ObservableObject {
    var users: [User] { get }
    
    func startFetchingUsers()
    func stopFetchingUsers(cleanIfNeeded: Bool)
}

public final class LiveUsersController: UsersController {
    public init(
        apiClient: ApiClient,
        configuration: DispatchSourceConfiguration = .live
    ) {
        self.apiClient = apiClient
        self.configuration = configuration
    }
    
    @Published public private(set) var users: [User] = []
    private let configuration: DispatchSourceConfiguration
    
    public func startFetchingUsers() {
        func terminateIfNeeded() -> Bool {
            if let timer = timer, !timer.isCancelled {
                return true
            }

            if currentUserId > 10 {
                stopFetchingUsers(cleanIfNeeded: true)
                return true
            }
            
            return false
        }
        
        if terminateIfNeeded() { return }
        
//        Timer(timeInterval: TimeInterval, repeats: Bool, block: { timer in _ }})
        timer = DispatchSource.makeTimerSource(queue: configuration.queue)
        timer?.schedule(deadline: .now(), repeating: configuration.repeatingInterval)
        timer?.setEventHandler { [weak self] in
            precondition(!Thread.isMainThread, "Timer handler must not run on main thread!")
            
            guard let self = self else { return }
            guard self.currentUserId <= 10 else {
                return self.stopFetchingUsers(cleanIfNeeded: false)
            }
            self.apiClient.fetchUser(byId: self.currentUserId) { result in
                switch result {
                case .success(let user):
                    print(">>> Next user fetched: \(user.name), id: \(user.id)")
                    DispatchQueue.main.async {
                        self.users.append(user)
                    }
                case .failure:
                    self.stopFetchingUsers(cleanIfNeeded: false)
                }
            }
            self.currentUserId += 1
        }
        timer?.resume()
    }
    
    public func stopFetchingUsers(cleanIfNeeded: Bool) {
        print(">>> stop fetching users (invalidate timer, clean data)")
        invalidateState()
        
        if cleanIfNeeded {
            DispatchQueue.main.async {
                self.currentUserId = 1
                self.users.removeAll()
            }
        }
    }
    
    private let apiClient: ApiClient
    
    private var timer: DispatchSourceTimer?
    private var currentUserId = 1
    
    private func invalidateState() {
        print(">>> invalidate timer state")
        timer?.cancel()
        timer = nil
    }
}
