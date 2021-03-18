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
    @EnvironmentObject var authState: AuthenticationState
    var categories: [Category]
    var tintColor: Color = Constant.color.tintColor
    
    @ObservedObject private var lostPetsViewModel = LostPetsViewModel()
    
    @ObservedObject var mapData = MapViewModel()
    @State var locationManager = CLLocationManager()
    @State var isShowingAlert = true

    

    var body: some View {
        
        
        if(mapData.permissionStatus == nil){
            //locationManager.authorizationStatus
            AnyView(Text("Waiting on permission")).onAppear(){
                locationManager.delegate = mapData
             }
        }else if(mapData.permissionStatus == .notDetermined){
            AnyView(Text("Permission not determined")).onAppear(){
                locationManager.delegate = mapData

                locationManager.requestAlwaysAuthorization()
             }
        }else if(mapData.permissionStatus == .denied){
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
                locationManager.delegate = mapData

                self.lostPetsViewModel.fetchLostPets()
            }
            
        }
        
//        switch mapData.$permissionDenied {
//        case 1:
//            return AnyView(Text("Option 1"))
//        case 2:
//            return AnyView(Text("Option 2"))
//        default:
//            return AnyView(Text("Wrong option!"))
//        }
        
//        switch locationManager.locationAuthorizationStatus {
//        case .denied:
//            EmptyView()
//        case .notDetermined:
//            Button("Hi")
//        default:
//            ()
//        }
        

        

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
