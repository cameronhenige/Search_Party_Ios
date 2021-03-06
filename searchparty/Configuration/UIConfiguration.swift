//
//  UIConfiguration.swift
//  FirebaseStarterSwiftUIApp
//
//  Created by Duy Bui on 8/15/20.
//  Copyright © 2020 iOS App Templates. All rights reserved.
//

import SwiftUI
import UIKit

class UIConfiguration {
    // Fonts
    static let titleFont = UIFont(name: "Arial Rounded MT Bold", size: 28)!
    static let smallFont = UIFont(name: "Avenir-Medium", size: 12)!

    static let subtitleFont = UIFont(name: "Avenir-Medium", size: 16)!
    static let buttonFont = UIFont(name: "Avenir-Heavy", size: 20)!
    
    // Color
    static let white: UIColor = .white

    static let backgroundColor: UIColor = .white
    static let tintColor = UIColor(hexString: "#284b63")
    static let subtitleColor = UIColor(hexString: "#464646")
    static let buttonColor = UIColor(hexString: "#414665")
    static let buttonBorderColor = UIColor(hexString: "#B0B3C6")
    
    
    static let colorPrimary = UIColor(hexString: "#284b63")
    static let colorPrimaryDark = UIColor(hexString: "#284b63")
    static let colorAccent = UIColor(hexString: "#d5905e")
    static let colorPrimaryDarker = UIColor(hexString: "#1d3647")
    static let colorPrimaryTrans = UIColor(hexString: "#33284b63")
    static let colorPrimaryDarkTrans = UIColor(hexString: "#28284b63")
}
