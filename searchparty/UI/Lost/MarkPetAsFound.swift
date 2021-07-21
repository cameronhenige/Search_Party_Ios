
import SwiftUI

struct MarkPetAsFound: View {
    @EnvironmentObject var lostViewRouter: SearchPartyAppState

    @State private var foundInformation: String = ""
    @StateObject private var markPetAsFoundViewModel = MarkPetAsFoundViewModel()

    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Let's get some information").font(.title).padding(.bottom)
            
            Text("If you choose, you may add some information about the status of your pet. This will be seen by anybody that looks at your post.")
            
            MultilineTextField("How your pet was found", text: $foundInformation).disabled(markPetAsFoundViewModel.isMarkingPetAsFound)
            
            Button(action: {
                self.markPetAsFoundViewModel.markPetAsFound(lostPetId: (lostViewRouter.selectedLostPet?.id)!, description: foundInformation) { result in
                    self.lostViewRouter.isOnLostPetIsFound = false
                }
            }) {
                Text("Mark Pet as Found")
            }.buttonStyle(PrimaryButtonStyle()).disabled(markPetAsFoundViewModel.isMarkingPetAsFound)
            .padding()
            
            
            Spacer()

        }.padding().alert(isPresented: $markPetAsFoundViewModel.showAlert) {
            Alert(title: Text(markPetAsFoundViewModel.errorTitle), message: Text(markPetAsFoundViewModel.errorBody), dismissButton: .default(Text("Ok")))
        }
    }
}

struct MarkPetAsFound_Previews: PreviewProvider {
    static var previews: some View {
        MarkPetAsFound()
    }
}
