//
//  Recipes.swift
//  sketch-elements
//
//  Created by Filip Molcik on 27/02/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI

struct LostPets: View {
    @EnvironmentObject var authState: AuthenticationState
    var categories: [Category]
    var tintColor: Color = Constant.color.tintColor
    
    @ObservedObject private var lostPetsViewModel = LostPetsViewModel()
    
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(lostPetsViewModel.lostPets) { lostPet in
                    NavigationLink(
                        destination: RecipesListView(lostPet: lostPet)
                    ) {
                        
                        CardWithBackground(lostPet: lostPet, title: lostPet.name, subTitle: lostPet.getLostDate(), subSubTitle: lostPet.getLostLocationDescription(), height: 300.0, description: nil)
                    }
                }
                
                
            }
            .background(Constant.color.gray)
            .navigationBarColor(tintColor.uiColor())
            .navigationBarTitle(Text("Lost"), displayMode: .large)
            .navigationBarItems(trailing: Button(action: signoutTapped, label: {
                Image(systemName: "person.circle")
                Text("Logout")
            }))
            
        }.onAppear(){
            self.lostPetsViewModel.fetchLostPets()
        }
        

    }
    
    private func signoutTapped() {
        authState.signout()
    }
}

struct Recipes_Previews: PreviewProvider {
    static var previews: some View {
        LostPets(categories: recipeCategoriesData)
            .environmentObject(UserData())
            .environment(\.colorScheme, .light)
    }
}
