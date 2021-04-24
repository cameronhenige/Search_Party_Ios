//
//  PrimaryButtonStyle.swift
//  searchparty
//
//  Created by Hannah Krolewski on 4/23/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
                .background(Constant.color.tintColor)
                .foregroundColor(Color(.white))
                .cornerRadius(8)
        }
}
