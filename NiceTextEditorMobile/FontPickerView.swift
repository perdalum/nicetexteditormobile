import SwiftUI
import UIKit

struct FontPickerView: UIViewControllerRepresentable {
    @Binding var selectedFontName: String
    @Environment(\.dismiss) private var dismiss

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedFontName: $selectedFontName, dismiss: { dismiss() })
    }

    func makeUIViewController(context: Context) -> UIFontPickerViewController {
        let configuration = UIFontPickerViewController.Configuration()
        configuration.includeFaces = true
        let viewController = UIFontPickerViewController(configuration: configuration)
        viewController.delegate = context.coordinator

        if let descriptor = selectedFontDescriptor {
            viewController.selectedFontDescriptor = descriptor
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIFontPickerViewController, context: Context) {
        if let descriptor = selectedFontDescriptor,
           uiViewController.selectedFontDescriptor?.postscriptName != descriptor.postscriptName {
            uiViewController.selectedFontDescriptor = descriptor
        }
    }

    private var selectedFontDescriptor: UIFontDescriptor? {
        let trimmed = selectedFontName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return UIFont(name: trimmed, size: 17)?.fontDescriptor
    }

    final class Coordinator: NSObject, UIFontPickerViewControllerDelegate {
        private var selectedFontName: Binding<String>
        private let dismiss: () -> Void

        init(selectedFontName: Binding<String>, dismiss: @escaping () -> Void) {
            self.selectedFontName = selectedFontName
            self.dismiss = dismiss
        }

        func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
            if let postscriptName = viewController.selectedFontDescriptor?.postscriptName {
                selectedFontName.wrappedValue = postscriptName
            }
            dismiss()
        }

        func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
            dismiss()
        }
    }
}
