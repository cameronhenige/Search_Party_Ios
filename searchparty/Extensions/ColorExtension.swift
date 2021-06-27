//
//  ColorExtension.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/7/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    static func generateRandomColor() -> UIColor {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
            
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
            
        }
}
