//
//  TabBar.swift
//  searchparty
//
//  Created by Hannah Krolewski on 7/22/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    
    var backgroundColor: Color = Constant.color.bgDefault
    var foregroundColor: Color = Constant.color.tintColor
    var content: TabItem
    
    var body: some View {
        HStack () {
                Spacer()
                VStack() {
                    if (content.customView != nil) {
                        content.customView
                    } else {
                        Image(systemName: content.icon ?? Constant.icon.circle).font(.system(size: 24))
                    }
                    Text(content.name)
                        .font(.subheadline).frame(alignment: .center).fixedSize(horizontal: false, vertical: true).padding(.top, 5)
                }
                .frame(maxWidth:.infinity)
                Spacer()
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 64.0)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        
    }
}


//struct TabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar(content: [
//            TabItem(name: "$$", icon: "creditcard"),
//            TabItem(name: "129 reviews", customView: Stars(3).eraseToAnyView()),
//            TabItem(name: "$18:00 - 22:00", icon: "clock.fill")
//        ])
//    }
//}
