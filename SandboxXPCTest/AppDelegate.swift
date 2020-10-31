//
// 
//

import Cocoa
import SwiftUI

struct Providers {
    let text: TextProvider
    let ssh: SSHProvider
    let sock: SocketProvider
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    var curWindow: NSWindow!
    var windows = [NSWindow: Providers]()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        newWindow(sender: self)
    }

    @IBAction @objc func newWindow(sender: AnyObject) {
        curWindow = makeWindow()
        curWindow.makeKeyAndOrderFront(nil)
    }

    func makeWindow() -> NSWindow {
        var d = FileManager.default.temporaryDirectory
        d.appendPathComponent("chat.sock")
        let path = d.path
        let defaultFrame = NSRect(x: 0, y: 0, width: 640, height: 480)
        let windowStyle: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .fullSizeContentView]
        let provider = Providers(text: TextProvider(), ssh: SSHProvider(), sock: SocketProvider(path))
        let contentView = ContentView(textProvider: provider.text, sshProvider: provider.ssh, socketProvider: provider.sock)
        let window = NSWindow(contentRect: defaultFrame, styleMask: windowStyle, backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.title = "Sandbox XPC Playground (\(windows.count + 1))"
        window.delegate = self
        windows[window] = provider
        return window
    }


    @IBAction @objc func openFile(sender: AnyObject) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.beginSheetModal(for: curWindow) { (response) in
            defer {panel.close()}
            guard response == .OK else {
                NSLog("Response was: \(response)")
                return
            }
            guard let p = self.windows[self.curWindow] else {
                return
            }
            if let url = panel.url {
                p.text.path = url.path
            } else {
                p.text.text = "Nothing selected"
            }
        }
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        if let p = windows.removeValue(forKey: sender) {
            // cleanup the providers
        }
        if curWindow == sender {
            curWindow = nil
        }
        return true
    }

    func windowDidBecomeMain(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            curWindow = window
        } else {
            print("Got object: \(notification.object)")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}
