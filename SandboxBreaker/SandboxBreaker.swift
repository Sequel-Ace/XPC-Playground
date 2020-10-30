//
// 
//

import Foundation

@objc class SandboxBreaker: NSObject, SandboxBreakerProtocol {
    private var socketPath = ""

    func setSocket(_ path: String!, done: (() -> Void)!) {
        DispatchQueue.global().asyncAfter(wallDeadline: .now() + 2.0, execute: done)
        //        let s = SocketPort(protocolFamily: AF_UNIX, socketType: SOCK_STREAM, protocol: 0, address: <#T##Data#>)
        //        let handle = FileHandle(fileDescriptor: s.socket)
        //        print("Socket: \(s) \(s.socket)")
        //        print("Raw Handle: \(handle.fileDescriptor)")
    }
    
    func send(_ data: Data!, response: ((Data?) -> Void)!) {
        response(nil)
    }
    
    func getTextOfFile(_ path: String!, withReply reply: ((String?) -> Void)!) {
        guard let path = path else {
            return reply("No path provided")
        }
        guard let bytes = FileManager.default.contents(atPath: path) else {
            return reply("Failed to get contents of '\(path)'")
        }
        guard let text = String(data: bytes, encoding: .utf8) else {
            return reply("Failed to decode contents of file: \(bytes)")
        }
        reply(text)
    }
}
