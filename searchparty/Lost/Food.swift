//
//  ContentView.swift
//  sketch-elements
//
//  Created by Filip Molcik on 26/02/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI

struct Food: View {
    
    var categories:[Category] = recipeCategoriesData
    var restaurants:[Restaurant] = restaurantsData
    
    var body: some View {
        TabView() {
            LostPets(categories: categories).tabItem {
                Text("Lost")
                Image("lost_icon").renderingMode(.template)
            }
            Restaurants(restaurants: restaurants).tabItem {
                Text("Found")
                Image("found_icon").renderingMode(.template)
            }
        }
        .tabBarOpaque()
        .accentColor(Constant.color.foodPrimary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Food().environmentObject(UserData())
    }
}


