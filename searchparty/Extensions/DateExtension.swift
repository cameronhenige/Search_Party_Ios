//
//  DateExtension.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/9/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation

extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}
