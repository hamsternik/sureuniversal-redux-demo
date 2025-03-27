//
//  UsersRootView.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/25/25.
//

import SwiftUI

struct UsersRootView: View {
    @Environment(Store<AppState>.self) private var store
    
    var body: some View {
        VStack {
            VStack {
                Text("Users")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            
            if let error = store.state.errorDescription {
                VStack {
                    Spacer()
                    Text("ERROR: \(error)")
                    Spacer()
                }
            }
            
            if store.state.users.count == 0 {
                VStack {
                    Spacer()
                    if store.state.isLoading {
                        HStack {
                            Text("No users have been downloaded yet.")
                            ProgressView()
                        }
                    } else {
                        Text("No users have been downloaded yet.")
                    }
                    Spacer()
                }
            } else {
                List(store.state.users, id: \.self) {
                    UserView(props: .init(id: $0.id, name: $0.name))
                    /// affects the individual row views, removing List built-in separator for each row
                        .listRowSeparator(.hidden)
                    /// affects the individual row views, setting bg color for each row
                        .listRowBackground(Color.white)
                }
                .listStyle(.plain)
                /// On iOS 16+ disable the default white background.
                .scrollContentBackground(.hidden)
                /// Set background color for the whole component,
                /// when there is no many elements need to scroll.
                .background(Color.gray.opacity(0.5))
            }
        }
        .background(Color.black.opacity(0.5))
    }
}

// MARK: Preview

struct UsersViewPreview: PreviewProvider {
    static var previews: some View {
        UsersRootView(
//            usersController: PreviewUsersController(
//                users: [.first, .second]
//            )
        )
    }
}

