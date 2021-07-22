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
    var content: [TabItem]
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState

    
    var body: some View {
        HStack () {
            ForEach(content) {tab in
                Spacer()
                VStack() {
                    if (tab.customView != nil) {
                        tab.customView
                    } else {
                        Image(systemName: tab.icon ?? Constant.icon.circle)
                    }
                    Text(tab.name)
                        .font(.caption)
                }
                .frame(maxWidth:.infinity)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 64.0)
        .background(backgroundColor)
        .foregroundColor(foregroundColor).onTapGesture {
            print("Hey")
            searchPartyAppState.isOnChat = true
        }
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
