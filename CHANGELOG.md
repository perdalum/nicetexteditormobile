# Changelog

## Unreleased

- Moved the global font chooser into an in-app Settings sheet.
- Remember the selected editor font between launches with `@AppStorage("defaultFontName")`.
- Added a System Font reset action in Settings.
- Added toolbar text-width presets: 100%, 80%, and 60%.
- Added the NiceTextEditor app icon from the macOS project to the iOS app icon asset catalog.

## 0.0.1 - 2026-06-19

Initial iPadOS/iOS prototype.

- Added Xcode iOS app project: `NiceTextEditorMobile.xcodeproj`.
- Added SwiftUI `DocumentGroup` document app entry point.
- Added `PlainTextDocument` for UTF-8/UTF-16/MacRoman reading and UTF-8 writing.
- Added UIKit `UITextView` editing surface through `UIViewRepresentable`.
- Enabled standard editing behavior and system find interaction.
- Added text-size controls, simple themes, character count, and share sheet.
- Registered plain text/source-code document types for Files integration.
- Intentionally excluded MPW/worksheet shell features.
- Intentionally excluded Go To Line.
