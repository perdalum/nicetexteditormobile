import SwiftUI
import UIKit

enum EditorTheme: String, CaseIterable, Identifiable {
    case system
    case cream
    case dark
    case terminalGreen
    case amber

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: "System"
        case .cream: "Cream"
        case .dark: "Dark"
        case .terminalGreen: "Terminal Green"
        case .amber: "Amber"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .system:
            .systemBackground
        case .cream:
            UIColor { traits in
                traits.userInterfaceStyle == .dark
                    ? UIColor(red: 0.18, green: 0.15, blue: 0.10, alpha: 1)
                    : UIColor(red: 1.00, green: 0.97, blue: 0.86, alpha: 1)
            }
        case .dark:
            .black
        case .terminalGreen:
            UIColor(red: 0.02, green: 0.07, blue: 0.035, alpha: 1)
        case .amber:
            UIColor(red: 0.10, green: 0.07, blue: 0.03, alpha: 1)
        }
    }

    var foregroundColor: UIColor {
        switch self {
        case .system:
            .label
        case .cream:
            UIColor { traits in
                traits.userInterfaceStyle == .dark
                    ? UIColor(red: 0.94, green: 0.90, blue: 0.82, alpha: 1)
                    : UIColor(red: 0.14, green: 0.12, blue: 0.09, alpha: 1)
            }
        case .dark:
            UIColor(white: 0.92, alpha: 1)
        case .terminalGreen:
            UIColor(red: 0.36, green: 1.00, blue: 0.48, alpha: 1)
        case .amber:
            UIColor(red: 1.00, green: 0.74, blue: 0.22, alpha: 1)
        }
    }

    var swiftUIBackground: Color { Color(backgroundColor) }
    var swiftUIForeground: Color { Color(foregroundColor) }
}
