//
//  Timeline.swift
//  sketch-elements
//
//  Created by Filip Molcik on 12/12/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI

struct Timeline: View {
    
    var stories: [Story]
    var users: [User]
    var posts: [Post]
    var body: some View {
        
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators:false) {
                    HStack(spacing: 16) {
                        Profile(image: nil, add: true)

                    }
                    .padding([.leading, .trailing])
                }
                .frame(height: 80)
                .background(Constant.color.bgDefault)
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(posts) { post in
                        //NavigationLink(
                        //    destination: RecipesListView(category: category)
                        //) {

                    }
                }
            }.background(Constant.color.gray)
            .navigationBarColor(Constant.color.socialPrimary.uiColor())
            .navigationBarTitle(Text("Timeline"), displayMode: .large)
            .navigationBarItems(trailing: Image(systemName: Constant.icon.compose).foregroundColor(.white))
        }
    }
}

struct Timeline_Previews: PreviewProvider {
    static var previews: some View {
        Timeline(stories: storiesData, users: usersData, posts: postsData)
            .environmentObject(UserData())
            .environment(\.colorScheme, .light)
    }
}
