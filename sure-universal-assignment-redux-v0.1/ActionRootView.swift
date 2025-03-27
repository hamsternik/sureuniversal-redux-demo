//
//  ActionRootView.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/4/25.
//

import SwiftUI

struct ActionRootView: View {
    struct Props {
        let title: String
        let onTapStart: () -> Void
        let onTapStop: () -> Void
    }
    
    let props: Props
    init(props: Props) {
        self.props = props
    }
    
    @Environment(Store<AppState>.self) private var store
    
    var body: some View {
        VStack {
            VStack {
                Text(props.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            
            VStack(spacing: 44) {
                Spacer()
                ActionButton(props: .init(
                    style: .primary,
                    title: "Start",
                    onTap: props.onTapStart
                ))
                
                ActionButton(props: .init(
                    style: .secondary,
                    title: "Stop",
                    onTap: props.onTapStop
                ))
                Spacer()
            }
            .padding(.horizontal, 8)
            .background(Color.blue)
        }
        .background(Color.gray.opacity(0.4))
    }
}

// MARK: Preview

struct ActionRootView_Previews: PreviewProvider {
    static var previews: some View {
        ActionRootView(
            props: .init(
                title: "Action",
                onTapStart: { },
                onTapStop: { }
            )
        )
    }
}
