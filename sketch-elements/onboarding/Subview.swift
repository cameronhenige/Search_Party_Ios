//
//  Subview.swift
//  SearchPartyIos
//
//  Created by Hannah Krolewski on 3/10/21.
//

import SwiftUI

struct Subview: View {
    var imageString: String
    var body: some View {
        Image(imageString)
        .resizable()
            .aspectRatio(contentMode: .fit)
        .clipped()
    }
}

struct Subview_Previews: PreviewProvider {
    static var previews: some View {
        Subview(imageString: "first")
    }
}
