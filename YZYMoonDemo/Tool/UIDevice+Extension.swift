//
//  UIDevice+Extension.swift
//  phantomLab
//
//  Created by 芝麻酱 on 2019/11/12.
//  Copyright © 2019 cclion. All rights reserved.
//

import Foundation

extension UIDevice {
    
    /// iPhone 5
    @objc static func  is_4Inch_screen() -> Bool {
        if UIScreen.main.bounds.height == 568 &&
            UIScreen.main.bounds.width == 320 {
            return true
        }
        return false
    }
    
    /// iPhone 8
    @objc static func  is_4_7Inch_screen() -> Bool {
        if UIScreen.main.bounds.height == 667 &&
            UIScreen.main.bounds.width == 375 {
            return true
        }
        return false
    }
    
    /// iPhone8 Plus
    @objc static func  is_5_5Inch_screen() -> Bool {
        if UIScreen.main.bounds.height == 736 &&
            UIScreen.main.bounds.width == 414 {
            return true
        }
        return false
    }
    
    @objc static func is_iPhone_X() -> Bool {
        if UIScreen.main.bounds.height == 812 &&
            UIScreen.main.bounds.width == 375 {
            return true
        }
        return false
    }
    
    @objc static func  is_iPhone_Xr() -> Bool {
        if UIScreen.main.bounds.height == 896 &&
            UIScreen.main.bounds.width == 414 {
            return true
        }
        return false
    }
    
    @objc static func  is_iPhone_XsMax() -> Bool {
        if UIScreen.main.bounds.height == 896 &&
            UIScreen.main.bounds.width == 414 {
            return true
        }
        return false
    }
}
