//
//  UINavigationControllerExtension.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/19/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        //appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIConfiguration.colorPrimary]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIConfiguration.colorPrimary]
        //appearance.backgroundColor = UIConfiguration.colorPrimary
        
        navigationBar.standardAppearance = appearance
    }
}
