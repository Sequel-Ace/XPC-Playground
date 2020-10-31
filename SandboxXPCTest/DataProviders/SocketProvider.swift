//
// 
//

import Foundation
import Combine
import fd

class SocketProvider: ObservableObject {
    @Published var path: String
    @Published var chat = [String]()

    var sock: UNIXListener?


    init(_ path: String) {
        self.path = path
    }

    func updateSocketPath(newPath: String) {
        path = newPath
    }

    private func ensureListener() -> UNIXListener? {
        if let sock = sock {
            return sock
        }
        do {
            print("Attempting to open socket at \(path)")
            sock = try UNIXListener(path: path)
            return sock
        } catch {
            print("failed to open listener \(error)")
            return nil
        }
    }

    private func getConn() -> UNIXConnection? {
        guard let sock = ensureListener() else {
            print("failed to get listener")
            return nil
        }
        do {
            return try sock.accept()
        } catch {
            print("Failed to sock.accept \(error)")
            return nil
        }
    }

    func sendText(text: String) {
        guard let c = getConn() else {
            chat.insert("! \(text)", at: 0)
            return
        }
        guard let data = text.data(using: .utf8) else {
            chat.insert("? \(text)", at: 0)
            return
        }
        do {
            _ = try c.write(data.asBytes())
            chat.insert("> \(text)", at: 0)
        } catch {
            chat.insert("~ \(text)", at: 0)
        }
    }
}


extension SocketProvider {
    static var Example = SocketProvider("/tmp/example-sock")
}

extension Data {
    func asBytes() -> [Byte] {
        let uInt = [UInt8](self)
        return uInt.map({ Byte($0) })
    }
}
