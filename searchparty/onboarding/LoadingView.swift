//
//  LoadingView.swift
//  SearchPartyIos
//
//  Created by Hannah Krolewski on 3/10/21.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack{
            LottieSubview(filename: "gift").frame(width: 200, height: 200)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
