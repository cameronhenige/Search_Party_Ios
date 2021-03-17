//
//  Error+Extension.swift
//  SwiftUIAuthentication
//
//  Created by Alfian Losari on 24/03/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation

extension NSError: Identifiable {
    public var id: Int { code }
}

extension LostPet
{
    func getLostLocationDescription() -> String? {
        if let desc = lostLocationDescription {
            return "Lost near \(desc)"
        }else{
            return nil
        }
    }
    
    func getLostDate() -> String? {
        if let desc = lostDateTime {
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .short
            
            return "Lost on \(formatter1.string(from: desc.dateValue()))"
        }else{
            return nil
        }
    }
}

extension SPUser
{
    func getRadiusFromUser() -> Double {
        if(filterDistance != nil) {
            return Double(filterDistance!)
        }else{
            return Constant.distances.RADIUS_TWO_MILE
        }
    }
}
