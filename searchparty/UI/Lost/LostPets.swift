

import SwiftUI
import CoreLocation

struct LostPets: View {
    
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState

        
    @State var isShowingAlert = true


    var body: some View {
        NavigationView {

        
        if(searchPartyAppState.permissionStatus == nil){
            AnyView(Text("Waiting on permission")).onAppear(){
                //locationManager.delegate = lostPetsViewModel
             }
        }else if(searchPartyAppState.permissionStatus == .notDetermined){
            AnyView(Text("Permission not determined")).onAppear(){
                //locationManager.delegate = lostPetsViewModel
                self.searchPartyAppState.requestLocationPermission()
             }
        }else if(searchPartyAppState.permissionStatus == .denied){
            AnyView(Text("Permission denied!")).alert(isPresented: $isShowingAlert, content: {
                Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission in App Settings"), dismissButton: .default(Text("Go to Settings"), action: {
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                }))
            })
        }else{

            
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(searchPartyAppState.lostPets) { lostPet in
//                        NavigationLink(destination: LostPetView(),
//                                       tag: lostPet,
//                                       selection: $searchPartyAppState.selectedLostPet,
//                                       label: {
//                                            CardWithBackground(lostPet: lostPet, title: lostPet.name, subTitle: lostPet.getLostDate(), subSubTitle: lostPet.getLostLocationDescription(), height: 300.0, description: nil)
//                        })
                        
                        CardWithBackground(lostPet: lostPet, title: lostPet.name, subTitle: lostPet.getLostDate(), subSubTitle: lostPet.getLostLocationDescription(), height: 300.0, description: nil).onTapGesture {
                            searchPartyAppState.selectedLostPet = lostPet
                            searchPartyAppState.isOnLostPet = true
                        }
                        
                    }
                    
                    
                    NavigationLink(destination: AddLostPet().environmentObject(searchPartyAppState), isActive: $searchPartyAppState.isOnAddingLostPet) {
                
                            }
                    
                    NavigationLink(destination: FilterView().environmentObject(searchPartyAppState), isActive: $searchPartyAppState.isFiltering) {
                
                            }
                    
                    NavigationLink(destination: LostPetView(),
                                   isActive: self.$searchPartyAppState.isOnLostPet) {
                                    EmptyView()
                    }
                    
                }.toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {

                    Button(action: {
                        self.searchPartyAppState.isOnAddingLostPet = true
                    }) {
                        Text("Add Lost Pet")
                    }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
                    
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {

                        
                        
                            Button(action: {
                                self.searchPartyAppState.isFiltering = true
                            }) {
                                Text("Filter")
                            }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading, .trailing])
                        
                    }

                }
                .navigationBarTitle(Text(""), displayMode: .inline)
                .onAppear(){
                    //locationManager.delegate = lostPetsViewModel

                    self.searchPartyAppState.fetchLostPets()
                }
                
                    
            }
        

        }.navigationViewStyle(StackNavigationViewStyle())

    }
    
}

struct Recipes_Previews: PreviewProvider {
    static var previews: some View {
        LostPets()
            .environment(\.colorScheme, .light)
    }
}
