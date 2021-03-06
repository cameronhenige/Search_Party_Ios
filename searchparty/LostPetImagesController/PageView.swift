/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view for bridging a UIPageViewController.
*/

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewControllerLostPet(pages: pages, currentPage: $currentPage)
            PageControlLostPet(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.trailing)
        }
    }
}

//struct PageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView(pages: ModelData().features.map { _ in SingleLostPetImage(url: "dogg", lostPetId: "sdajf") })
//            .aspectRatio(3 / 2, contentMode: .fit)
//    }
//}
