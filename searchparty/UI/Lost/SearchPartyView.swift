//
//  SearchPartyView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/21/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import MapKit
import BottomSheet

struct SearchPartyView: View {
    
    
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState
    
    var lostPet: LostPet
    
    @StateObject var searchPartyViewModel = SearchPartyViewModel()
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    enum CustomBottomSheetPosition: CGFloat, CaseIterable {
        case top = 0.975, middle = 0.4, bottom = 0.2
    }
    
    @State private var bottomSheetPosition: CustomBottomSheetPosition = .bottom
    
    @State var currentLocation: CLLocationCoordinate2D?
    
    @State var name = ""
        
    @State var map = MKMapView()
    
    var SearchingButtonText: some View {
        if(searchPartyViewModel.isSearching) {
            return Text("Stop")
        } else {
            return Text("Search")
        }
    }
    
    var body: some View {
        
        NavigationLink(destination: AddHouseLocation(), isActive: $searchPartyViewModel.isOnAddHomeScreen) {
            
        }
        
        
        let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        }()
        VStack {
            
            ZStack(alignment: .top) {
                
                
                
                SearchPartyMapView(map: self.$map, name: self.$name, isSearching: $searchPartyViewModel.isSearching, coordinate: self.$currentLocation, searchPartyUsers: $searchPartyViewModel.searchPartyUsers, listOfPrivateGeoHashes: $searchPartyViewModel.listOfPrivateGeoHashes).edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    HStack {
                        Spacer()
                    Button(action: {
                        self.searchPartyAppState.isOnSearchParty = false
                    }) {
                        Text("X")
                    }.buttonStyle(PrimaryButtonStyle()).frame(width: 30, alignment: .trailing)
                    }.padding(.leading).padding(.top).padding(.trailing)
                    

                    //Image("dog").resizable().frame(width: 30, height: 30, alignment: .topTrailing)
                    if(searchPartyViewModel.listOfDays.count > 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            ZStack {
                                LazyHStack {
                                        DateText(text: "All", isSelected: searchPartyViewModel.selectedDay == nil).onTapGesture {
                                            searchPartyViewModel.selectedDay = nil
                                        }

                                    ForEach(searchPartyViewModel.listOfDays, id: \.self) { day in
                                        
                                        DateText(text: String(taskDateFormat.string(from: day)), isSelected: searchPartyViewModel.selectedDay == day).onTapGesture {
                                            searchPartyViewModel.selectedDay = day
                                        }
                                        
                                    }
                                    
                                }.background(Color.white)
                                
                            }.frame(height: 50).clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous)).padding()
                        }.flipsForRightToLeftLayoutDirection(true)
                        .environment(\.layoutDirection, .rightToLeft)
                    }
                    
                    if(searchPartyViewModel.isInsideOfAPrivateGeoHash){
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color.white)
                            Text("Leave the privacy square to start searching").foregroundColor(Color.red)
                            
                            
                        }.frame(height: 50, alignment: .top).padding().padding(.top)
                    }
                }
            }
        }.bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, hasBottomPosition: false, content: {
            VStack {
                
                HStack {
                    Image("cat").resizable()
                        .frame(width: 100.0, height: 100.0)
                    
                    Text(lostPet.name)
                    Spacer()
                    Button(action: {
                        searchPartyViewModel.startUpdatingLocationButtonAction()
                        print("here")
                    }) {

                        SearchingButtonText
                        
                    }.buttonStyle(PrimaryButtonStyle()).frame(width: 150)
                    
                }
                
                Button(action: {
                    //todo contact searchPartyViewModel.startUpdatingLocationButtonAction()
                }) {
                    
                    Text("Contact Owner")
                    
                }.buttonStyle(PrimaryButtonStyle())
                
                ScrollView {
                    Text("People Searching").padding(.vertical)
                    
                    ForEach(searchPartyViewModel.searchPartyUsers) { user in
                        Text(String("User"))
                        
                        Text(String(user.name ?? "Private")).foregroundColor(Color(UIColor(hexString: user.color!)))
                        
                    }.frame(maxWidth: .infinity)
                    
                }
                
            }.padding(.horizontal)
            
            
        }).onAppear() {
            self.searchPartyViewModel.fetchData(lostPet: lostPet)
        }
        
        
    }
    
    
    struct DateText: View {
        var text: String
        var isSelected: Bool

        var body: some View {
            
            if(isSelected){
                Text(text).foregroundColor(.white).rotation3DEffect(Angle(degrees: 180), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0))).padding().background(Constant.color.tintColor)

            }else {
                Text(text).rotation3DEffect(Angle(degrees: 180), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0))).padding()

            }
        }
    }
    
    
    
    
}

struct SearchPartyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPartyView(lostPet: LostPet(id: "TestContent", name: "Fido", sex: "TestContent", age: 3, chatSize: 3, breed: "TestContent", type: "TestContent", description: "TestContent", uniqueMarkings: "TestContent", temperament: "TestContent", healthCondition: "TestContent", generalImages: ["TestContent"], lostDateTime: nil, lostLocation: "TestContent", lostLocationDescription: "TestContent", ownerName: "TestContent", ownerEmail: "TestContent", ownerPhoneNumber: "TestContent", ownerOtherContactMethod: "TestContent", ownerPreferredContactMethod: "TestContent", foundPetDescription: "TestContent", foundPet: true, Owners: ["TestContent"]))
    }
}
