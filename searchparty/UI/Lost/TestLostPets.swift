//
//  TestLostPets.swift
//  searchparty
//
//  Created by Hannah Krolewski on 1/3/22.
//  Copyright © 2022 Filip Molcik. All rights reserved.
//

import SwiftUI

struct TestLostPets: View {
    var body: some View {
        NavigationView {
        
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<10) {
                        Text("Item \($0)")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .frame(width: 200, height: 200)
                            .background(Color.red)
                    }
                }
            }.navigationTitle("SwiftUI")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Press Me") {
                            print("Pressed")
                        }
                    }
                }
        }
    }
}

struct TestLostPets_Previews: PreviewProvider {
    static var previews: some View {
        TestLostPets()
    }
}
