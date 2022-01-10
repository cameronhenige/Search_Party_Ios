//
//  MessageBeingSent.swift
//  searchparty
//
//  Created by Hannah Krolewski on 1/10/22.
//  Copyright © 2022 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct MessageBeingSent: Hashable, Codable, Identifiable {

@DocumentID var id: String?
var message: String?
var sender: String?
var senderName: String?
}
