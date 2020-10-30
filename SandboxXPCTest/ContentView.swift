//
// 
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var textProvider: TextProvider
    @ObservedObject var sshProvider: SSHProvider

    var body: some View {
        TabView {
            Tab("SSH") {
                VStack {
                    HStack {
                        TextField("User", text: $sshProvider.user)
                        Text("@")
                        TextField("Host", text: $sshProvider.host)
                    }
                    HStack {
                        Text("SSH_AUTH_SOCK")
                        TextField("", text: $sshProvider.authSock)
                        Toggle("XPC", isOn: $sshProvider.useXPC)
                    }
                }.disabled(sshProvider.connecting)
                HStack {
                    Text("Args")
                    ForEach(sshProvider.args.indices, id: \.self) { TextField("", text: $sshProvider.args[$0]) }
                    Button("+", action: { sshProvider.args.append("") })
                    Spacer()
                    Button(sshProvider.connecting ? "Disconnect" : "Connect", action: sshProvider.toggleConnection)
                }
                ScrollView {
                    ForEach(sshProvider.lines, id: \.self) { line in
                        Text(line)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .top, .bottom], 4)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background(Color.white)
            }
            
            Tab("File") {
                HStack {
                    TextField("File To Display", text: $textProvider.path)
                    Toggle("XPC", isOn: $textProvider.useXPC)
                }
                ScrollView([.vertical, .horizontal], showsIndicators: true) {
                    Text(textProvider.text)
                        .frame(maxWidth: .infinity)
                        .padding([.leading, .top, .bottom], 4)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
        }
        .padding(.all)
        .frame(minWidth: 480, idealWidth: 640, minHeight: 300, idealHeight: 480)
    }
}

struct Tab<Content: View>: View {
    let title: String
    let content: () -> Content

    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(spacing: 8, content: content)
            .padding(.all)
            .tabItem { Text(title) }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var provider = TextProvider.Example
    static var ssh = SSHProvider.Example
    
    static var previews: some View {
        ContentView(textProvider: provider, sshProvider: ssh)
    }
}
