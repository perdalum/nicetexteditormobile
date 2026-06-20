import SwiftUI

@main
struct NiceTextEditorMobileApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: PlainTextDocument()) { file in
            DocumentEditorView(document: file.$document, fileURL: file.fileURL)
        }
    }
}
