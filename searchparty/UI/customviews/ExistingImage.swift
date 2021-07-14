
import SwiftUI
import Kingfisher
import FirebaseStorage

struct ExistingImage: View {
    var url: String
    var lostPetId: String
    
    @State var fullUrl: URL?

    var body: some View {
        
        VStack {
            
            if(fullUrl != nil){
                KFImage(fullUrl)
                    .resizable()
                    .aspectRatio(3 / 2, contentMode: .fit)
            }
            
        }.onAppear {
            
                let storageLocation : String = "Lost/" + lostPetId + "/generalImages/" + url
                let storage = Storage.storage().reference().child(storageLocation)
                storage.downloadURL { (URL, Error) in
                    if(Error != nil){
                        print(Error?.localizedDescription)
                        return
                    }
                    fullUrl = URL
                }
            
        }
        
    
    }
}
