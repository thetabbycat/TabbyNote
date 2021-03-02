//
//  Edit.swift
//  Atomic Note
//
//  Created by Steven J. Selcuk on 27.02.2021.
//

import Cocoa
import SwiftUI

let settings = UserDefaults.standard

extension String {
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

extension UserDefaults {
    public func optionalString(forKey defaultName: String) -> String? {
        let defaults = self
        if let value = defaults.value(forKey: defaultName) {
            return value as? String
        }
        return nil
    }
}

struct EditView: View {
    @State var note: String = UserDefaults.standard.optionalString(forKey: "note") ?? "TabbyNote"
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            TextEditor(text: $note)
                .cornerRadius(9)
                .font(.body)
                .lineSpacing(0)
                .padding(.all, 5.0)
                .onChange(of: note) { _ in

                    if note.count > 120 {
                        note.removeLast()
                    }

                    let a = note.trim()

                    settings.set(a, forKey: "note")
                    (NSApp.delegate as! AppDelegate).updateTitle(newTitle: String(a))
                    /**
                      We have menubar icon now.So There is no need.
                     if note.isEmpty {
                     settings.set("TabbyNote", forKey: "note")
                     (NSApp.delegate as! AppDelegate).updateTitle(newTitle: String("TabbyNote"))
                     }
                     */
                }
                .background(Color.clear)
                .padding(.all, 10.0)
            HStack {
                Button(action: self.copyIt) {
                    Text("Copy to clipboard")
                }

                Button(action: self.quit) {
                    Text("Quit")
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

    func copyIt() {
        let note = UserDefaults.standard.optionalString(forKey: "note") ?? "TabbyNote"
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(note, forType: NSPasteboard.PasteboardType.string)
        NSSound(named: "Pop")?.play()
    }

    func quit() {
        NSApp.terminate(self)
    }
}
