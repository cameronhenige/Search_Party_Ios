//
//  ExistingImage.swift
//  searchparty
//
//  Created by Hannah Krolewski on 7/13/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import SwiftUI

struct SelectedImage: Identifiable {
    var name: String?
    var isExisting: Bool
    var image: UIImage?
    var id = UUID()

}
