
import SwiftUI

struct MarkPetAsFound: View {
    @EnvironmentObject var lostViewRouter: SearchPartyAppState
    @State private var isFound: Bool = true
    
    @State private var foundInformation: String = ""
    @StateObject private var markPetAsFoundViewModel = MarkPetAsFoundViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Pet Status").font(.title).padding(.bottom)
            
            Toggle("Is Found", isOn: $isFound).padding(.vertical)
            
            if(isFound){
                
                Text("If you choose, you may add some information about the status of your pet. This will be seen by anybody that looks at your post.")
                
                MultilineTextField("", text: $foundInformation).disabled(markPetAsFoundViewModel.isMarkingPetAsFound).background(Color(.systemGray6)).padding(.vertical)
            }
            
            
            Button(action: {
                self.markPetAsFoundViewModel.markPetAsFound(lostPetId: (lostViewRouter.selectedLostPet?.id)!, description: foundInformation, isFound: isFound) { result in
                    self.lostViewRouter.isOnLostPetIsFound = false
                }
            }) {
                Text("Update Pet Status")
            }.buttonStyle(PrimaryButtonStyle()).disabled(markPetAsFoundViewModel.isMarkingPetAsFound)
            
            
            Spacer()
            
        }.padding().alert(isPresented: $markPetAsFoundViewModel.showAlert) {
            Alert(title: Text(markPetAsFoundViewModel.errorTitle), message: Text(markPetAsFoundViewModel.errorBody), dismissButton: .default(Text("Ok")))
        }.onAppear {
            let selectedLostPet = lostViewRouter.selectedLostPet
            
            self.foundInformation = selectedLostPet?.foundPetDescription ?? ""
            
            if let foundPet = selectedLostPet?.foundPet {
                self.isFound = foundPet
            }
        }
    }
}

struct MarkPetAsFound_Previews: PreviewProvider {
    static var previews: some View {
        MarkPetAsFound()
    }
}
