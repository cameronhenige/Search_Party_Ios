//
//  PetView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/26/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI

struct PetView: View {
    
    @EnvironmentObject var viewRouter: SearchPartyAppState

    var body: some View {
        if let pet = viewRouter.selectedLostPet {
            Text(pet.name)
        } else {
            EmptyView()
        }
    }
}

struct PetView_Previews: PreviewProvider {
    static var previews: some View {
        PetView()
    }
}
