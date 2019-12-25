//
//  UIColor+Extension.swift
//  YPFinance
//
//  Created by ZMJ on 2019/7/1.
//  Copyright © 2019 YeePBank. All rights reserved.
//

import UIKit

@objc
extension UIColor {
    
    class func hexString(_ hex:String) -> UIColor {
        return hexString(hex, alpha: CGFloat(1.0))
    }
    
    class func hexString(_ hex:String,alpha: CGFloat) -> UIColor {
        
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[index..<cString.endIndex])
        }
        
        if ((cString.hasPrefix("0x") || cString.hasPrefix("0X")) && cString.count > 6) {
            let index = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString[index..<cString.endIndex])
        }
        
        if (cString.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString[cString.startIndex..<rIndex])
        
        let otherString = String(cString[rIndex..<cString.endIndex])
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = String(otherString[otherString.startIndex..<gIndex])
        
        let bString = String(cString.suffix(2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    class func colorBetween(_ startColor: UIColor, endColor: UIColor, location: CGFloat) -> UIColor {
        
        guard let firstColorComponents: [CGFloat] = startColor.cgColor.components else {return UIColor.purple}
        guard let endColorComponents: [CGFloat] = endColor.cgColor.components else {return UIColor.purple}
        if firstColorComponents.count < 4 { return UIColor.purple }
        if endColorComponents.count < 4 { return UIColor.purple }

        let r = firstColorComponents.first! + (endColorComponents.first! - firstColorComponents.first!) * location
        
        let g = firstColorComponents[1] + (endColorComponents[1] - firstColorComponents[1]) * location
        
        let b = firstColorComponents[2] + (endColorComponents[2] - firstColorComponents[2]) * location
        
        let a = firstColorComponents.last! + (endColorComponents.last! - firstColorComponents.last!) * location
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

func RandomColor() -> UIColor {
    // 浅色
    let r = arc4random_uniform(125)
    let g = arc4random_uniform(125)
    let b = arc4random_uniform(125)
    return UIColor.init(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: 0.6)
}
