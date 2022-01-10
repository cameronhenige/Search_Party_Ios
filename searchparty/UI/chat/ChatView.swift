
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
                    
                    
                    VStack {
                        ForEach(model.messages, id: \.self) { message in
                            ChatRow(text: message.message!,
                                    sender: message.sender == Auth.auth().currentUser?.uid, isBeingSent: false)
                                .padding(3)
                        }
                        
                        ForEach(model.messageBeingSent, id: \.self) { messageBeingSent in
                            ChatRow(text: messageBeingSent.message!,
                                    sender: messageBeingSent.sender == Auth.auth().currentUser?.uid, isBeingSent: true)
                                .padding(3)
                        }.onChange(of: model.messageBeingSent) { _ in
                            if(!model.messageBeingSent.isEmpty){
                                scrollView.scrollTo(model.messageBeingSent[model.messageBeingSent.endIndex - 1])
                            }
                        }
                        
                        
                    }.padding().onChange(of: model.messages) { _ in
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
                
                SendButton(text: $message, model: model)
                
            }
            .padding()
        }.alert("Failed to send \"" + model.errorMessage + "\"", isPresented: $model.errorSendingMessage) {
            Button("OK", role: .cancel) { }
        }
        .navigationBarTitle("Chat with Search Party", displayMode: .inline)
        .onAppear {
            model.getMessages(lostPetId: (searchPartyAppState.selectedLostPet?.id)!)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView().environmentObject(SearchPartyAppState())
            .preferredColorScheme(.dark)
    }
}
