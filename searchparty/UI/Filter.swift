//
//  Filter.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/30/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI

struct Filter: View {
    
    @EnvironmentObject var searchPartyAppState: SearchPartyAppState

    var body: some View {
        Text("Filter!")
    }
}

struct Filter_Previews: PreviewProvider {
    static var previews: some View {
        Filter()
    }
}
