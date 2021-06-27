
import SwiftUI

struct ChatRow: View {
    let sender: Bool
    @EnvironmentObject var model: ChatViewModel


    let text: String

    init(text: String, sender: Bool) {
        self.text = text
        self.sender = sender
    }

    var body: some View {
        HStack {
            if sender { Spacer() }


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
            ChatRow(text: "Test", sender: true)
                .preferredColorScheme(.dark)
            ChatRow(text: "Test", sender: false)
                .preferredColorScheme(.light)

        }
    }
}
