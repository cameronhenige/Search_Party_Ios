//
//  FirebaseUtil.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/15/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

public class FirebaseUtil {
    static let LOST = "Lost"
    static let GENERAL_IMAGES = "generalImages"

func getCurrentTimeInMillis()->Int64{
    return Int64(NSDate().timeIntervalSince1970*1000)
}
    
    func getAddPetImageReference(imageName: String, lostPetId: String)-> StorageReference {
        let addLostPetUrl = "\(FirebaseUtil.LOST)/\(lostPetId)/\(FirebaseUtil.GENERAL_IMAGES)/\(imageName)"
        return Storage.storage().reference().child(addLostPetUrl)
    }

}
