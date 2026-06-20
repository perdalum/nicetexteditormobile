import SwiftUI
import UIKit

struct AppSettingsView: View {
    @AppStorage("defaultFontName") private var fontName = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingFontPicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Editor Font") {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(fontDisplayName)
                            Text(fontDetailText)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }

                    Button {
                        isShowingFontPicker = true
                    } label: {
                        Label("Choose Font…", systemImage: "textformat")
                    }

                    if !fontName.isEmpty {
                        Button(role: .destructive) {
                            fontName = ""
                        } label: {
                            Label("Use System Font", systemImage: "arrow.counterclockwise")
                        }
                    }
                }

                Section {
                    Text("The font setting is global and applies to all documents. It is remembered between launches.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $isShowingFontPicker) {
                FontPickerView(selectedFontName: $fontName)
            }
        }
    }

    private var fontDisplayName: String {
        let trimmedName = fontName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, let font = UIFont(name: trimmedName, size: 17) else {
            return "System Font"
        }
        return font.familyName == font.fontName ? font.fontName : font.familyName
    }

    private var fontDetailText: String {
        let trimmedName = fontName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            return "Default iOS system font"
        }
        return trimmedName
    }
}
