//
//  Edit.swift
//  Atomic Note
//
//  Created by Steven J. Selcuk on 27.02.2021.
//

import Cocoa
import SwiftUI

let settings = UserDefaults.standard

extension UserDefaults {
    public func optionalString(forKey defaultName: String) -> String? {
        let defaults = self
        if let value = defaults.value(forKey: defaultName) {
            return value as? String
        }
        return nil
    }
}

final class MakeWindow: NSWindow, NSWindowDelegate {
    convenience init() {
        self.init(
            contentRect: .zero,
            styleMask: [
                .titled,
                .closable,
                .miniaturizable,
                .resizable,
            ],
            backing: .buffered,
            defer: true
        )

        titlebarAppearsTransparent = true
        delegate = self
    }
}

struct EditView: View {
    var nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
    @State var note: String = UserDefaults.standard.optionalString(forKey: "note") ?? "🐈 TabbyNote - Click here to change"
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            TextEditor(text: $note)
                .cornerRadius(9)
                .font(.body)
                .lineSpacing(0)
                .padding(.all, 5.0)
                .onChange(of: note) { _ in
                    settings.set(note, forKey: "note")
                    (NSApp.delegate as! AppDelegate).updateTitle(newTitle: String(note))
                    if note.isEmpty {
                        settings.set("🐈 TabbyNote", forKey: "note")
                        (NSApp.delegate as! AppDelegate).updateTitle(newTitle: String("🐈 TabbyNote"))
                    }
                }
                .padding(.all, 10.0)
            HStack {
                HStack {
                    Text("Bug or Feature?")

                    Button(action: {
                        let email = "https://github.com/thetabbycat/TabbyNote/issues"
                        if let url = URL(string: email) {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        Text("Tell Me")
                    }
                }

                HStack {
                    Text("Do you like it?")

                    Button(action: self.requestReviewManually) {
                        Text("5 X ⭐️")
                    }
                }
            }
            .padding(.bottom, 20.0)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }

    func requestReviewManually() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1555858947?action=write-review")
        else { fatalError("Expected a valid URL") }
        NSWorkspace.shared.open(writeReviewURL)
    }
}

final class EditWindowController: NSWindowController {
    convenience init() {
        let window = MakeWindow()
        self.init(window: window)

        window.contentView = NSHostingView(rootView: EditView())

        window.title = "🐈 TabbyNote - Edit Note"
        window.styleMask = [
            .titled,
            .closable,
            .borderless,
        ]
        var windowFrame = window.frame
        windowFrame.size = NSMakeSize(500, 160)

        window.setFrame(windowFrame, display: true, animate: true)
        window.level = .floating
        window.titlebarAppearsTransparent = true
        window.center()
    }

    func showWindow() {
        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(nil)
    }
}
