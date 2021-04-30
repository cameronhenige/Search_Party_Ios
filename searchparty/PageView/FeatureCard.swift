/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that shows a featured landmark.
*/

import SwiftUI
import Kingfisher
import FirebaseStorage

struct FeatureCard: View {
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
        
        
//        Image(url)
//            .resizable()
//            .aspectRatio(3 / 2, contentMode: .fit)
////            .overlay(TextOverlay(landmark: landmark))
    }
}

struct TextOverlay: View {
    var landmark: Landmark

    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [Color.black.opacity(0.6), Color.black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle().fill(gradient)
            VStack(alignment: .leading) {
                Text(landmark.name)
                    .font(.title)
                    .bold()
                Text(landmark.park)
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

struct FeatureCard_Previews: PreviewProvider {
    static var previews: some View {
        FeatureCard(url: "dog", lostPetId: "id")
    }
}
