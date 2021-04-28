//
//  AddLostPet.swift
//  searchparty
//
//  Created by Hannah Krolewski on 4/24/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import Combine

struct AddLostPet: View {

    @State var petName = ""
    @State var petAge = ""
    @State var petBreed = ""

    @State private var petType = 0
    var petTypes = ["Dog", "Cat", "Bird", "Other"]
    
    @State private var petSex = 0
    var petSexes = ["Male", "Female"]

    
    var body: some View {
        Form {
            
                Section(header: Text("Let's get some information about your lost pet.")) {
                    TextField("Pet Name", text: $petName)
                    
                    Picker(selection: $petType, label: Text("Pet Type")) {
                        ForEach(0 ..< petTypes.count) {
                            Text(self.petTypes[$0])
                        }
                    }
                    
                    Picker(selection: $petSex, label: Text("Sex")) {
                        ForEach(0 ..< petSexes.count) {
                            Text(self.petSexes[$0])
                        }
                    }

                    
                    TextField("Approximate Age", text: $petAge)
                        .keyboardType(.numberPad)
                        .onReceive(Just(petAge)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.petAge = filtered
                            }
                    }
                    
                    TextField("Breed", text: $petBreed)

                }
        
                
        }.navigationTitle("Add Lost Pet").navigationBarColor(Constant.color.tintColor.uiColor())

        }
    
}

struct AddLostPet_Previews: PreviewProvider {
    static var previews: some View {
        AddLostPet()
    }
}
