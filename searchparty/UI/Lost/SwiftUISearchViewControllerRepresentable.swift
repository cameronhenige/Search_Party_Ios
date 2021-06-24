//
//  SwiftUISearchViewControllerRepresentable.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/11/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import SwiftUI

struct SwiftUISearchViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = LocationViewController
    
    
    func makeUIViewController(context: Context) -> LocationViewController {
        return LocationViewController()
    }
    
    func updateUIViewController(_ uiViewController: LocationViewController, context: Context) {
        
    }
    
}
