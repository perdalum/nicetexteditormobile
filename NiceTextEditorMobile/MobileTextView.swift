import SwiftUI
import UIKit

struct MobileTextView: UIViewRepresentable {
    @Binding var text: String
    var fontName: String
    var fontSize: CGFloat
    var theme: EditorTheme
    var bottomPadding: CGFloat
    var findRequestID: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = .interactive
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .default
        textView.spellCheckingType = .default
        textView.smartQuotesType = .default
        textView.smartDashesType = .default
        textView.adjustsFontForContentSizeCategory = false
        textView.allowsEditingTextAttributes = false
        textView.text = text

        if #available(iOS 16.0, *) {
            textView.isFindInteractionEnabled = true
        }

        configure(textView, context: context)
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        context.coordinator.text = $text
        configure(textView, context: context)

        if textView.text != text {
            let selectedRange = textView.selectedRange
            context.coordinator.isApplyingProgrammaticChange = true
            textView.text = text
            textView.selectedRange = selectedRange.clamped(to: (text as NSString).length)
            context.coordinator.isApplyingProgrammaticChange = false
        }

        if context.coordinator.lastFindRequestID != findRequestID {
            context.coordinator.lastFindRequestID = findRequestID
            if #available(iOS 16.0, *) {
                textView.findInteraction?.presentFindNavigator(showingReplace: false)
            }
        }
    }

    private func configure(_ textView: UITextView, context: Context) {
        let editorFont = resolvedFont()
        textView.font = editorFont
        textView.backgroundColor = theme.backgroundColor
        textView.textColor = theme.foregroundColor
        textView.tintColor = theme.foregroundColor
        textView.typingAttributes = [
            .font: editorFont,
            .foregroundColor: theme.foregroundColor
        ]
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: bottomPadding, right: 16)
        textView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: max(0, bottomPadding - 80), right: 0)
    }

    private func resolvedFont() -> UIFont {
        let trimmedName = fontName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty, let chosenFont = UIFont(name: trimmedName, size: fontSize) {
            return chosenFont
        }
        return UIFont.systemFont(ofSize: fontSize)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var isApplyingProgrammaticChange = false
        var lastFindRequestID = 0

        init(text: Binding<String>) {
            self.text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            guard !isApplyingProgrammaticChange else { return }
            text.wrappedValue = textView.text
        }
    }
}

private extension NSRange {
    func clamped(to length: Int) -> NSRange {
        let safeLocation = min(location, length)
        let safeLength = min(self.length, max(0, length - safeLocation))
        return NSRange(location: safeLocation, length: safeLength)
    }
}
