//
//  UserView.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/5/25.
//

import SwiftUI

struct UserView: View {
    struct Props: Hashable, Identifiable {
        let id: Int
        let name: String
    }
    
    let props: Props
    init(props: Props) {
        self.props = props
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 4) {
                Text("User \(props.id)")
                    .font(.system(size: 14, weight: .medium, design: .default))
                Text("\(props.name)")
                    .font(.system(size: 14, weight: .regular, design: .default))
            }
            .padding(.vertical, 40)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.25))
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: Preview (UserView)

struct UserView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            UserView(
                props: .init(
                    id: 1,
                    name: "Leanne Graham"
                )
            )
            UserView(
                props: .init(
                    id: 2,
                    name: "Ervin Howell"
                )
            )
            UserView(
                props: .init(
                    id: 3,
                    name: "Clementine Bauch"
                )
            )
        }
    }
}
