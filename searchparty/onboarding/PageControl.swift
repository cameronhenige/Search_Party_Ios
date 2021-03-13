//
//  PageControl.swift
//  SearchPartyIos
//
//  Created by Hannah Krolewski on 3/10/21.
//

import Foundation
import UIKit
import SwiftUI

struct PageControl: UIViewRepresentable {
    
    var numberOfPages: Int
    
    @Binding var currentPageIndex: Int
    
    func makeUIView(context: Context) -> UIPageControl {
           let control = UIPageControl()
           control.numberOfPages = numberOfPages
        control.currentPageIndicatorTintColor = UIColor(named: "primaryColor")
           control.pageIndicatorTintColor = UIColor.gray

           return control
       }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPageIndex
    }
    
}
