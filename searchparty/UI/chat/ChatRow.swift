
import SwiftUI

struct ChatRow: View {
    let sender: Bool
    @EnvironmentObject var model: ChatViewModel
    let isBeingSent: Bool


    let text: String

    init(text: String, sender: Bool, isBeingSent: Bool) {
        self.text = text
        self.sender = sender
        self.isBeingSent = isBeingSent
    }

    var body: some View {
        HStack {
            if sender { Spacer() }

            if(isBeingSent) {
                ProgressView()
            }
            
            HStack {
                Text(text)
                    .foregroundColor(sender ? Color.white : Color(.label))
                    .padding()
            }
            .background(sender ? Color.blue : Color(.systemGray4))
            .cornerRadius(6)

            if !sender { Spacer() }

        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatRow(text: "Test", sender: true, isBeingSent: false)
                .preferredColorScheme(.dark)
            ChatRow(text: "Test", sender: false, isBeingSent: false)
                .preferredColorScheme(.light)
            ChatRow(text: "Test", sender: false, isBeingSent: true)
                .preferredColorScheme(.light)
        }
    }
}
