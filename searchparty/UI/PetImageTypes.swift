//
//  PetImageTypes.swift
//  searchparty
//
//  Created by Hannah Krolewski on 7/6/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation

public class PetImageTypes {
    

public func getPetImageType(petType: String?) -> String? {
    if(petType == "Dog"){
    return "dog"
    }else if petType == "Cat" {
        return "cat"

    }else if petType == "Bird" {
        return "bird"
    }else {
        return "marker"
    }
}
}
