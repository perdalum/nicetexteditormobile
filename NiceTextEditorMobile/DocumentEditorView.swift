import SwiftUI

struct DocumentEditorView: View {
    @Binding var document: PlainTextDocument
    let fileURL: URL?

    @AppStorage("defaultFontName") private var fontName = ""
    @AppStorage("defaultFontSize") private var fontSize = 17.0
    @AppStorage("defaultTheme") private var themeRawValue = EditorTheme.system.rawValue
    @AppStorage("textWidthPercent") private var textWidthPercent = 100.0

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var findRequestID = 0
    @State private var isShowingSettings = false
    @State private var isShowingShareSheet = false

    private var theme: EditorTheme {
        get { EditorTheme(rawValue: themeRawValue) ?? .system }
        nonmutating set { themeRawValue = newValue.rawValue }
    }

    private var displayName: String {
        fileURL?.lastPathComponent ?? "Untitled"
    }

    private var characterCountText: String {
        "\(document.text.count) characters"
    }

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    Spacer(minLength: 0)
                    MobileTextView(
                        text: $document.text,
                        fontName: fontName,
                        fontSize: CGFloat(fontSize),
                        theme: theme,
                        bottomPadding: horizontalSizeClass == .compact ? 180 : 220,
                        findRequestID: findRequestID
                    )
                    .frame(width: editorWidth(for: proxy.size.width))
                    Spacer(minLength: 0)
                }
                .background(theme.swiftUIBackground)
            }

            Divider()

            statusBar
        }
        .navigationTitle(displayName)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    findRequestID += 1
                } label: {
                    Label("Find", systemImage: "magnifyingglass")
                }
                .keyboardShortcut("f", modifiers: [.command])

                Menu {
                    Button("Smaller") { decreaseTextSize() }
                        .keyboardShortcut("-", modifiers: [.command])
                    Button("Larger") { increaseTextSize() }
                        .keyboardShortcut("+", modifiers: [.command])
                    Button("Actual Size") { resetTextSize() }
                        .keyboardShortcut("0", modifiers: [.command])

                    Divider()

                    ForEach([13.0, 15.0, 17.0, 19.0, 22.0, 26.0, 30.0], id: \.self) { size in
                        Button {
                            fontSize = size
                        } label: {
                            if Int(fontSize) == Int(size) {
                                Label("\(Int(size)) pt", systemImage: "checkmark")
                            } else {
                                Text("\(Int(size)) pt")
                            }
                        }
                    }
                } label: {
                    Label("Text Size", systemImage: "textformat.size")
                }

                Menu {
                    ForEach([100.0, 80.0, 60.0], id: \.self) { percent in
                        Button {
                            textWidthPercent = percent
                        } label: {
                            if Int(textWidthPercent) == Int(percent) {
                                Label("\(Int(percent))%", systemImage: "checkmark")
                            } else {
                                Text("\(Int(percent))%")
                            }
                        }
                    }
                } label: {
                    Label("Width \(Int(textWidthPercent))%", systemImage: "rectangle.compress.vertical")
                        .monospacedDigit()
                }

                Menu {
                    ForEach(EditorTheme.allCases) { candidate in
                        Button {
                            theme = candidate
                        } label: {
                            if candidate == theme {
                                Label(candidate.displayName, systemImage: "checkmark")
                            } else {
                                Text(candidate.displayName)
                            }
                        }
                    }
                } label: {
                    Label("Theme", systemImage: "paintpalette")
                }

                Button {
                    isShowingShareSheet = true
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }

                Button {
                    isShowingSettings = true
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
            }
        }
        .sheet(isPresented: $isShowingSettings) {
            AppSettingsView()
        }
        .sheet(isPresented: $isShowingShareSheet) {
            ActivityView(activityItems: shareItems())
                .ignoresSafeArea()
        }
    }

    private func editorWidth(for availableWidth: CGFloat) -> CGFloat {
        let percent = min(100, max(60, textWidthPercent)) / 100
        return min(availableWidth, max(min(availableWidth, 260), availableWidth * percent))
    }

    private var statusBar: some View {
        HStack(spacing: 8) {
            Label(displayName, systemImage: "doc.text")
                .lineLimit(1)
                .truncationMode(.middle)
            Spacer(minLength: 8)
            Text(characterCountText)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(.bar)
    }

    private func increaseTextSize() {
        fontSize = min(34, fontSize + 1)
    }

    private func decreaseTextSize() {
        fontSize = max(10, fontSize - 1)
    }

    private func resetTextSize() {
        fontSize = 17
    }

    private func shareItems() -> [Any] {
        if let fileURL {
            return [fileURL]
        }
        return [document.text]
    }
}
