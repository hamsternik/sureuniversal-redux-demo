//
//  ContentView.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/25/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(Store<AppState>.self) private var store
    
    var body: some View {
        TabView {
            userCoordinator
                .tabItem {
                    Label {
                        Text("Users")
                    } icon: {
                        Image("icons8-heart-monitor-24")
                            .resizable()
                            .renderingMode(.template)
                    }
                }
            
            actionCoordinator
                .tabItem {
                    Label {
                        Text("Action")
                    } icon: {
                        Image("icons8-male-user-24")
                            .resizable()
                            .renderingMode(.template)
                            .background(Color.black)
                    }
                }
        }
    }
    
    private var userCoordinator: some View {
        UsersRootView()
    }
    
    private var actionCoordinator: some View {
            ActionRootView(
                props: .init(
                    title: "Action",
                    onTapStart: {
                        Task { await store.dispatch(Actions.StartFetchUsers()) }
                    },
                    onTapStop: {
                        Task { await store.dispatch(Actions.StopFetchUsers()) }
                    }
                )
            )
    }
}

#Preview {
    ContentView()
}
