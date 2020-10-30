//
// 
//

import Foundation
import Combine

class TextProvider: ObservableObject {
    @Published var path = "/Users/clay/github/SandboxXPCTest/SandboxXPCTest/TextProvider.swift" {
        didSet { updateText() }
    }
    @Published var useXPC = false { didSet { updateText() } }
    @Published var text = ""

    private var connection = SandboxBreakerConnection()

    init() {
        updateText()
    }

    func updateText() {
        if useXPC {
            connection.connect()
            getContentsFromXPC()
        } else {
            loadFile()
        }
    }

    func loadFile() {
        guard let bytes = FileManager.default.contents(atPath: path) else {
            text = "Could not get the contents of \(path)"
            return
        }
        if let text = String(bytes: bytes, encoding: .utf8) {
            self.text = text
        } else {
            text = "Could not decode bytes as utf8. size=\(bytes.count)"
        }
    }

    func getContentsFromXPC() {
        text = "Fetching contents of \(path) via XPC"
        connection.getTextOfFile(path) { (maybeText) in
            DispatchQueue.main.async {
                self.text = maybeText ?? "No text returned from XPC"
            }
        }
    }
}

extension TextProvider {
    static var Example: TextProvider {
        let p = TextProvider()
        p.text = """
    Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
        Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
    Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
        Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
    Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
        Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
            Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
    Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
        Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
    Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
        Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
    Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
        Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
            Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
    Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
        Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
    Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
        Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
    Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
        Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
            Hello, world! Hello, world! Hello, world! Hello, world! Hello, world! Hello, world!
    """
        return p
    }
}
