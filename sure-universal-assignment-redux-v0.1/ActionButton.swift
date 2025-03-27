//
//  ActionButton.swift
//  sure-universal-assignment-redux-v0.1
//
//  Created by Niki Khomitsevych on 3/25/25.
//

import SwiftUI

struct ActionButton_PRevew: PreviewProvider {
    static var previews: some View {
        VStack {
            ActionButton(
                props: .init(
                    style: .primary,
                    title: "Start",
                    icon: nil,
                    onTap: {}
                )
            )
            ActionButton(
                props: .init(
                    style: .secondary,
                    title: "Stop",
                    icon: nil,
                    onTap: {}
                )
            )
        }
        .padding(.horizontal)
    }
}


struct ActionButton: View {
    struct Props {
        enum Style {
            case primary
            case secondary
        }
        
        let style: Style
        let title: String
        let icon: Image?
        let estimatedSize: CGSize
        let onTap: @MainActor () -> Void
        
        init(
            style: Style,
            title: String,
            icon: Image? = nil,
            estimatedSize: CGSize = .init(
                width: CGFloat.infinity,
                height: Constant.minimalControlHeight
            ),
            onTap: @escaping () -> Void
        ) {
            self.style = style
            self.title = title
            self.icon = icon
            self.estimatedSize = estimatedSize
            self.onTap = onTap
        }
    }
    
    let props: Props
    
    init(props: Props) {
        self.props = props
    }
}

extension ActionButton {
    var body: some View {
        Button(action: props.onTap) {
            Label {
                buttonTitle
            } icon: {
                if let icon = props.icon {
                    buttonImage(icon)
                }
            }
            .frame(
                maxWidth: props.estimatedSize.width,
                minHeight: props.estimatedSize.height
            )
        }
        .background(
            RoundedRectangle(cornerRadius: Constant.controlRadius)
                .stroke(props.style.backgroundColor, lineWidth: 1)
        )
        .background(props.style.backgroundColor)
        .cornerRadius(Constant.controlRadius)
    }
    
    private var buttonTitle: some View {
        Text(props.title)
            .font(props.style.titleFont)
            .foregroundStyle(props.style.foregroundColor)
    }
    
    private func buttonImage(_ image: Image) -> some View {
        image
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(props.style.foregroundColor)
        // TODO: While no need to display any icon the default size is defined.
            .frame(width: 20, height: 20)
    }
}

// MARK: Props Extension

extension ActionButton.Props: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(style)
        hasher.combine(title)
        // TODO: Include onTap hash value, when the type would be hashable.
        // hasher.combine(onTap)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.style == rhs.style
        && lhs.title == rhs.title
    }
}

// MARK: ActionButton Style

extension ActionButton.Props.Style {
    fileprivate var backgroundColor: Color {
        switch self {
        case .primary:
            return Color.green
        case .secondary:
            return Color.gray
        }
    }
    
    fileprivate var foregroundColor: Color {
        switch self {
        case .primary:
            return Color.purple
        case .secondary:
            return Color.teal
        }
    }
    
    fileprivate var titleFont: Font {
        .system(size: 16, weight: .regular, design: .default)
    }
}

private enum Constant {
    /// Create controls that measure at least 44 points x 44 points
    /// so they can be accurately tapped with a finger.
    /// More in https://developer.apple.com/design/tips.
    static let minimalControlHeight: CGFloat = 44
    static let controlRadius: CGFloat = minimalControlHeight / 2
}

