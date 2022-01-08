//
//  IosUtil.swift
//  searchparty
//
//  Created by Hannah Krolewski on 1/7/22.
//  Copyright © 2022 Filip Molcik. All rights reserved.
//

import UIKit
import SwiftUI

class IosUtil {
    
    class func sendEmail(email: String) {
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    class func sendMessage(phoneNumber: String) {
        let rawPhoneNumber = phoneNumber.filter("0123456789.".contains)
        let sms: String = "sms:" + rawPhoneNumber
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    class func callPhone(phoneNumber: String) {
        let rawPhoneNumber = phoneNumber.filter("0123456789.".contains)
        let sms: String = "tel://" + rawPhoneNumber
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
}
