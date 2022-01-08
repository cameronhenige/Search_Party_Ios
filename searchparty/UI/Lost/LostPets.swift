

import SwiftUI
import CoreLocation

struct LostPets: View {
    
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState
    @StateObject var lostPetsViewModel: LostPetsViewModel = LostPetsViewModel()

    @State var isShowingAlert = true
    @State var lostPetForm: LostPetForm = LostPetForm()


    var body: some View {
        NavigationView {
        
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

            
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(lostPetsViewModel.lostPets) { lostPet in
//                        NavigationLink(destination: LostPetView(),
//                                       tag: lostPet,
//                                       selection: $searchPartyAppState.selectedLostPet,
//                                       label: {
//                                            CardWithBackground(lostPet: lostPet, title: lostPet.name, subTitle: lostPet.getLostDate(), subSubTitle: lostPet.getLostLocationDescription(), height: 300.0, description: nil)
//                        })
                        
                        CardWithBackground(lostPet: lostPet, height: 300.0, description: nil).onTapGesture {
                            searchPartyAppState.selectedLostPet = lostPet
                            searchPartyAppState.isOnLostPet = true
                        }
                        
                    }
                    
                    
                    NavigationLink(destination: AddLostPet(addLostPetViewModel: AddLostPetViewModel(lostPetForm: lostPetForm, isEditing: false)).environmentObject(searchPartyAppState), isActive: $searchPartyAppState.isOnAddingLostPet) {
                
                            }
                    
                    NavigationLink(destination: FilterView().environmentObject(searchPartyAppState), isActive: $searchPartyAppState.isFiltering) {
                
                            }
                    
                    NavigationLink(destination: LostPetView().environmentObject(searchPartyAppState),
                                   isActive: $searchPartyAppState.isOnLostPet) {
                    }
                    
                }.toolbar {
                    
                    
                    ToolbarItemGroup(placement: .navigationBarLeading) {

                    Button(action: {
                        lostPetForm = LostPetForm()
                        self.searchPartyAppState.isOnAddingLostPet = true
                    }) {
                        Text("Add Lost Pet")
                    }
                    
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {

                        
                        
                            Button(action: {
                                self.searchPartyAppState.isFiltering = true
                            }) {
                                Text("Filter")
                            }
                        
                    }

                }
                .navigationBarTitle(Text(""), displayMode: .inline)
                .onAppear(){
                    //todo can probably be smarter about refreshing lost pets
                    print("appeared")
                    self.lostPetsViewModel.fetchLostPets()
                }
                
                    
            }
        

        }.navigationViewStyle(StackNavigationViewStyle())

    }
    
}

//struct Recipes_Previews: PreviewProvider {
//    static var previews: some View {
//        LostPets()
//            .environment(\.colorScheme, .light).environmentObject(SearchPartyAppState())
//    }
//}
