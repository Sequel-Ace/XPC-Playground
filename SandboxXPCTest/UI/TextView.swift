//
// 
//

import SwiftUI
import Combine

struct FileTextView: View {
    @ObservedObject var provider: TextProvider

    var body: some View {
        VStack {
            HStack {
                TextField("File To Display", text: $provider.path)
                Toggle("XPC", isOn: $provider.useXPC)
            }
            ScrollView([.vertical, .horizontal], showsIndicators: true) {
                Text(provider.text)
                    .frame(maxWidth: .infinity)
                    .padding([.leading, .top, .bottom], 4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
}
