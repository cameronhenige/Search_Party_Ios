
import SwiftUI
import FirebaseAuth

struct ChatView: View {
    @State var message: String = ""
    @StateObject var model = ChatViewModel()

    @EnvironmentObject var searchPartyAppState: SearchPartyAppState

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ScrollViewReader { scrollView in

                ForEach(model.messages, id: \.self) { message in
                    ChatRow(text: message.message!,
                            sender: message.sender == Auth.auth().currentUser?.uid)
                        .padding(3)
                }.onChange(of: model.messages) { _ in
                    scrollView.scrollTo(model.messages[model.messages.endIndex - 1])
                }.onAppear(){
                    if(model.messages.count>0){
                    scrollView.scrollTo(model.messages[model.messages.endIndex - 1])
                    }
                }
                    
                }
            }

            HStack {
                TextField("Message...", text: $message)
                    .modifier(CustomField())

                
                if(model.isAddingMessage){
                    ProgressView()
                }else{
                    SendButton(text: $message, model: model)
                }
            }
            .padding()
        }
        .navigationBarTitle("Chat with Search Party", displayMode: .inline)
        .onAppear {
            model.getMessages(lostPetId: (searchPartyAppState.selectedLostPet?.id)!)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .preferredColorScheme(.dark)
    }
}
