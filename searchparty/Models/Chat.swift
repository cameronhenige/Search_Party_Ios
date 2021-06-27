//
//  Chat.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/16/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Chat: Hashable, Codable, Identifiable {

@DocumentID var id: String?
var created: Timestamp?
var message: String?
var sender: String?
var senderName: String?
}
