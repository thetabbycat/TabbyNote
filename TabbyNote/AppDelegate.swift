//
//  AppDelegate.swift
//  Atomic Note
//
//  Created by Steven J. Selcuk on 27.02.2021.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        if let button = statusBarItem.button {
        //    button.image = NSImage(named: "menubar-icon") No icon. Just text.
            button.imagePosition = NSControl.ImagePosition.imageLeft
            button.title = UserDefaults.standard.optionalString(forKey: "note") ?? "🐈 TabbyNote - Click here to change"
          //  button.font = NSFont.menuBarFont(ofSize: 12)
            button.font = NSFont.boldSystemFont(ofSize: 12)
         //   button.font = NSFont.monospacedDigitSystemFont(ofSize: 12.0, weight: NSFont.Weight.bold)
            button.action = #selector(togglePopover(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        let event = NSApp.currentEvent!

        if event.type == NSEvent.EventType.rightMouseUp {
        } else if event.type == NSEvent.EventType.leftMouseUp {
            let menu = NSMenu()
            menu.addItem(withTitle: "Copy", action: #selector(copyIt), keyEquivalent: "c")
            menu.addItem(withTitle: "Edit", action: #selector(edit), keyEquivalent: "e")
            menu.addItem(NSMenuItem.separator())
            menu.addItem(withTitle: "Quit App", action: #selector(quit), keyEquivalent: "q")
            statusBarItem.menu = menu
            statusBarItem.button?.performClick(nil)
            statusBarItem.menu = nil
        }
    }

    @objc func copyIt() {
        let note = UserDefaults.standard.optionalString(forKey: "note") ?? "🐈 TabbyNote"
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(note, forType: NSPasteboard.PasteboardType.string)
        NSSound(named: "Pop")?.play()
    }

    @objc func edit() {
        EditWindowController().showWindow()
    }

    @objc func quit() {
        NSApp.terminate(self)
    }

    func updateTitle(newTitle: String) {
        statusBarItem.button?.title = newTitle
    }

}
