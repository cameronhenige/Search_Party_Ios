//
//  Recipes.swift
//  sketch-elements
//
//  Created by Filip Molcik on 27/02/2020.
//  Copyright © 2020 Filip Molcik. All rights reserved.
//

import SwiftUI
import CoreLocation

struct LostPets: View {
    
    @ObservedObject private var lostPetsViewModel = LostPetsViewModel()
    
    @State var isShowingAlert = true

    @State var isAddingLostPet = false


    var body: some View {
        
        
        if(lostPetsViewModel.permissionStatus == nil){
            AnyView(Text("Waiting on permission")).onAppear(){
                //locationManager.delegate = lostPetsViewModel
             }
        }else if(lostPetsViewModel.permissionStatus == .notDetermined){
            AnyView(Text("Permission not determined")).onAppear(){
                //locationManager.delegate = lostPetsViewModel
                self.lostPetsViewModel.requestLocationPermission()
             }
        }else if(lostPetsViewModel.permissionStatus == .denied){
            AnyView(Text("Permission denied!")).alert(isPresented: $isShowingAlert, content: {
                Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission in App Settings"), dismissButton: .default(Text("Go to Settings"), action: {
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                }))
            })
        }else{
            NavigationView {
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(lostPetsViewModel.lostPets) { lostPet in
                        
                        
                        NavigationLink(
                            destination: LostPetView(lostPet: lostPet)
                        ) {
                            
                            CardWithBackground(lostPet: lostPet, title: lostPet.name, subTitle: lostPet.getLostDate(), subSubTitle: lostPet.getLostLocationDescription(), height: 300.0, description: nil)
                        }
                    }
                    
                    
                }.toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink(destination: AddLostPet(), isActive: $isAddingLostPet) {
                            Button(action: {
                                self.isAddingLostPet = true
                            }) {
                                Text("Add Lost Pet")
                            }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
                        }
                    }
                }.navigationBarColor(Constant.color.tintColor.uiColor())
                .navigationBarTitle(Text("Lost"), displayMode: .inline)
                .background(Constant.color.gray)
                .onAppear(){
                    //locationManager.delegate = lostPetsViewModel

                    self.lostPetsViewModel.fetchLostPets()
                }
        
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            
        }

    }
    
    private func doSomething() {
        print("something")
    }
}

struct Recipes_Previews: PreviewProvider {
    static var previews: some View {
        LostPets()
            .environment(\.colorScheme, .light)
    }
}
