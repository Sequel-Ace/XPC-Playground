//
// 
//

import SwiftUI

struct SocketView: View {
    @ObservedObject var provider: SocketProvider
    @State private var newPath = "/tmp/"
    @State private var message = ""

    func sendMessage() {
        guard message != ""  else { return }
        provider.sendText(text: message)
        message = ""
    }

    var body: some View {
        VStack {
            HStack {
                Text("Socket: \(provider.path)")
            }
            HStack {
                TextField("Socket path", text: $newPath)
                Button("Update", action: { provider.updateSocketPath(newPath: newPath) })
            }
            HStack {
                TextField("Text to send", text: $message, onCommit: { sendMessage() })
                Button("Send", action: sendMessage)
            }
            ScrollView {
                ForEach(provider.chat, id: \.self) { line in
                    Text(line)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top, .bottom], 4)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color.white)
        }
    }
}
