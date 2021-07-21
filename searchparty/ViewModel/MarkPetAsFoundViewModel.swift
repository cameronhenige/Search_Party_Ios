

import FirebaseFirestore
import FirebaseFirestoreSwift

public class MarkPetAsFoundViewModel: ObservableObject {
    private var completionHandler: ((Result<String, Error>) -> Void)?
    @Published var isMarkingPetAsFound = false
    
    
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorBody = ""
    
    func markPetAsFound(lostPetId: String, description: String, isFound: Bool, completionHandler: @escaping (Result<String, Error>) -> Void) {
        self.completionHandler = completionHandler
        isMarkingPetAsFound = true
    
            let itemData : [String: Any] = [
                "foundPetDescription" : description,
                "foundPet": isFound,
            ]
        
                Firestore.firestore().collection("Lost").document(lostPetId).updateData(itemData) { err in
                    self.isMarkingPetAsFound = false
                    if  err != nil {
                        self.showAlert = true
                        self.errorTitle = "Error updating pet"
                        self.errorBody = "There was an error marking your pet as found."

                    } else {
                         self.completionHandler!(.success("Marked Lost Pet as Found"))
                    }
                }
            
        
    }
    
}
