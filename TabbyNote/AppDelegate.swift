//
//  AppDelegate.swift
//  Atomic Note
//
//  Created by Steven J. Selcuk on 27.02.2021.
//

import AppKit
import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        //  UserDefaults.standard.register(defaults: userDefaultsDefaults)
        // Create the SwiftUI view that provides the window contents.
        let contentView = EditView()

        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 500, height: 160)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        // It will override users mode preferences: Now it is dark.
        // popover.appearance = NSAppearance(named: .vibrantDark)

        self.popover = popover
        self.popover.contentViewController?.view.window?.becomeKey()

        if let button = statusBarItem.button {
            button.image = NSImage(named: "menubar")
            button.imagePosition = NSControl.ImagePosition.imageLeft
            button.title = UserDefaults.standard.optionalString(forKey: "note") ?? "TabbyNote"
            //     button.font = NSFont.menuBarFont(ofSize: 14)
            button.font = NSFont.boldSystemFont(ofSize: 12)
            //    button.font = NSFont.monospacedDigitSystemFont(ofSize: 14.0, weight: NSFont.Weight.bold)

            button.action = #selector(togglePopover(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        let event = NSApp.currentEvent!

        if event.type == NSEvent.EventType.leftMouseUp {
            if let sbutton = statusBarItem.button {
                if popover.isShown {
                    popover.performClose(sender)
                } else {
                    popover.show(relativeTo: sbutton.bounds, of: sbutton, preferredEdge: NSRectEdge.minY)
                }
            }

        } else if event.type == NSEvent.EventType.rightMouseUp {
            let menu = NSMenu()
            menu.addItem(withTitle: "Copy", action: #selector(copyIt), keyEquivalent: "c")
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "TabbyNote v1.0.1", action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Give ⭐️", action: #selector(giveStar), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "About", action: #selector(about), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Bug report", action: #selector(issues), keyEquivalent: ""))

            menu.addItem(NSMenuItem.separator())
            menu.addItem(withTitle: "Quit App", action: #selector(quit), keyEquivalent: "q")

            statusBarItem.menu = menu
            statusBarItem.button?.performClick(nil)
            statusBarItem.menu = nil
        }
    }

    @objc func copyIt() {
        let note = UserDefaults.standard.optionalString(forKey: "note") ?? "TabbyNote"
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(note, forType: NSPasteboard.PasteboardType.string)
        NSSound(named: "Pop")?.play()
    }

    @objc func giveStar() {
        let url = URL(string: "https://apps.apple.com/app/id1555858947?action=write-review")!
        NSWorkspace.shared.open(url)
    }

    @objc func about() {
        let url = URL(string: "https://github.com/thetabbycat/TabbyNote")!
        NSWorkspace.shared.open(url)
    }

    @objc func issues() {
        let url = URL(string: "https://github.com/thetabbycat/TabbyNote/issues")!
        NSWorkspace.shared.open(url)
    }

    @objc func quit() {
        NSApp.terminate(self)
    }

    func updateTitle(newTitle: String) {
        statusBarItem.button?.title = newTitle
    }
}
