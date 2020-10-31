import Foundation
import Combine

class SSHProvider: ObservableObject {
    @Published var user = "git"
    @Published var host = "github.com"
    @Published var authSock = "/private/tmp/com.apple.launchd.XrlkpKMtwJ/Listeners"
    @Published var useXPC = false
    @Published var connecting = false
    @Published var args = [String]()
    @Published var lines = [String]()

    private var task: Process?
    private var xpcConn = SandboxBreakerConnection()

    func toggleConnection() {
        if let task = task {
            task.interrupt()
        } else {
            connect()
        }
    }

    private func disconnect() {

    }

    private func connect() {
        connecting = true
        if useXPC {
            let localSock = ""
            xpcConn.connect()
            xpcConn.setSocket(authSock) {
                self.makeSshConnection(localSshSock: localSock)
            }
        } else {
            makeSshConnection(localSshSock: authSock)
        }
    }

    private func makeSshConnection(localSshSock: String) {
        let t = Process()
        t.launchPath = "/usr/bin/ssh"
        t.arguments = ["\(user)@\(host)"] + args
        t.environment = [
            "SSH_AUTH_SOCK": localSshSock
        ]
        let stdOut = Pipe()
        let stdErr = Pipe()
        t.standardOutput = stdOut
        t.standardError = stdErr
        t.launch()

        DispatchQueue.global().async {
            t.waitUntilExit()
            DispatchQueue.main.async { self.connecting = false }

            let output = String(data: stdOut.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? "could not read stdout"
            let err = String(data: stdErr.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? "could not read stderr"
            DispatchQueue.main.async {
                let outLines = output.split(separator: "\n").map { String($0) }
                let errLines = err.split(separator: "\n").map { String($0) }
                self.lines = ["STDOUT"] + outLines
                    + ["STDERR"] + errLines
            }
        }
    }
}

extension SSHProvider {
    static var Example: SSHProvider {
        let p = SSHProvider()
        p.user = "git"
        p.host = "github.com"
        p.lines = [
            "Line 1",
            "Line 2",
            "Line 3",
            "Line 4",
        ]
        return p
    }
}
