//
//  TextStyle.swift
//  searchparty
//
//  Created by Hannah Krolewski on 8/31/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
struct Header: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.red)
            .foregroundColor(Color.white)
            .font(Font.custom("", size: 38))
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Text("Header").modifier(Header())
    }
}
