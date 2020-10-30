//
// 
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    var text = TextProvider()
    var ssh = SSHProvider()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(textProvider: text, sshProvider: ssh)

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 640, height: 480),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.title = "Sandbox XPC Playground"
        window.makeKeyAndOrderFront(nil)
    }

    @IBAction @objc func openFile(sender: AnyObject) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.beginSheetModal(for: window) { (response) in
            defer {panel.close()}
            guard response == .OK else {
                NSLog("Response was: \(response)")
                return
            }
            if let url = panel.url {
                self.text.path = url.path
            } else {
                self.text.text = "Nothing selected"
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}
