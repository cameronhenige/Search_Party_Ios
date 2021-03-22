//
//  ButtonSecondary.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/21/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//
import Foundation
import SwiftUI

struct ButtonSecondary<Content: View>: View {
    
    var action: () -> Void
    var foregroundColor: Color = Constant.color.tintColor
    var backgroundColor: Color = Color(.white)
    
    let content: Content
    
    init(
        action: @escaping () -> Void,
        backgroundColor: Color = Color(.white),
        foregroundColor: Color = Constant.color.tintColor,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.action = action
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        Button(action: action){
            content
        }
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .cornerRadius(8)
    }
    
}

struct ButtonSecondary_Previews: PreviewProvider {
    static var previews: some View {
        ButtonSecondary(action: {}) {
            Image(Constant.icon.heart)
            Text("Love it!")
                .font(.headline)
        }
    }
}
