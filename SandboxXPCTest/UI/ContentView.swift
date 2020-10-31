//
// 
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var textProvider: TextProvider
    @ObservedObject var sshProvider: SSHProvider
    @ObservedObject var socketProvider: SocketProvider

    var body: some View {
        TabView {
            Tab("Chat Socket") {
                SocketView(provider: socketProvider)
            }
            Tab("SSH") {
                SSHView(provider: sshProvider)
            }
            Tab("File") {
                FileTextView(provider: textProvider)
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
    static var text = TextProvider.Example
    static var ssh = SSHProvider.Example
    static var sock = SocketProvider.Example
    
    static var previews: some View {
        ContentView(textProvider: text, sshProvider: ssh, socketProvider: sock)
    }
}
