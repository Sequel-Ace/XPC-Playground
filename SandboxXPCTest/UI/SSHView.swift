//
// 
//

import SwiftUI
import Combine

struct SSHView: View {
    @ObservedObject var provider: SSHProvider

    var body: some View {
        VStack {
            VStack {
                HStack {
                    TextField("User", text: $provider.user)
                    Text("@")
                    TextField("Host", text: $provider.host)
                }
                HStack {
                    Text("SSH_AUTH_SOCK")
                    TextField("", text: $provider.authSock)
                    Toggle("XPC", isOn: $provider.useXPC)
                }
            }.disabled(provider.connecting)
            HStack {
                Text("Args")
                ForEach(provider.args.indices, id: \.self) { TextField("", text: $provider.args[$0]) }
                Button("+", action: { provider.args.append("") })
                Spacer()
                Button(provider.connecting ? "Disconnect" : "Connect", action: provider.toggleConnection)
            }
            ScrollView {
                ForEach(provider.lines, id: \.self) { line in
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
