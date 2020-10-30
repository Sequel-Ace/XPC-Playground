import Foundation

class SandboxBreakerStub: SandboxBreakerProtocol {
    func getTextOfFile(_ path: String!, withReply reply: ((String?) -> Void)!) {
        NSLog("Stub - Getting text of '\(path ?? "no path provided")'")
        reply(nil)
    }

    func setSocket(_ path: String!, done: (() -> Void)!) {
        NSLog("Stub - Setting socket path '\(path ?? "no path provided")'")
        done()
    }

    func send(_ data: Data!, response: ((Data?) -> Void)!) {
        NSLog("Stub - Sending data '\(String(describing: data))'")
    }

}

/// SandboxBreakerConnection is a facade for clients to use
/// in forward all calls to the XPC proxy (an interface provided by the XPC service)
/// the acutal work is done in SandboxBreaker
class SandboxBreakerConnection: SandboxBreakerProtocol {
    private var connection: NSXPCConnection?
    private var proxy: SandboxBreakerProtocol = SandboxBreakerStub()

    func connect() {
        guard connection == nil else { return }

        let connection = NSXPCConnection(serviceName: "me.clayreimann.SandboxBreaker")
        connection.remoteObjectInterface = NSXPCInterface(with: SandboxBreakerProtocol.self)
        connection.resume()
        self.connection = connection

        if let p = connection.remoteObjectProxy as? SandboxBreakerProtocol {
            proxy = p
        }
    }

    func disconnect() {
        connection?.invalidate()
    }

    func getTextOfFile(_ path: String!, withReply reply: ((String?) -> Void)!) {
        proxy.getTextOfFile(path, withReply: reply)
    }

    func setSocket(_ path: String!, done: (() -> Void)!) {
        proxy.setSocket(path, done: done)
    }

    func send(_ data: Data!, response: ((Data?) -> Void)!) {
        proxy.send(data, response: response)
    }

}
