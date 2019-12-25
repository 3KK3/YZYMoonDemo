//
//  UIView+Extension.swift
//  phantomLab
//
//  Created by 芝麻酱 on 2019/11/12.
//  Copyright © 2019 cclion. All rights reserved.
//

import Foundation

extension UIView {
    /// x
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    /// height
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
        }
    }
    
    /// width
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    /// bottom
    var bottom: CGFloat {
        get {
            return frame.size.height + frame.origin.y
        }
    }
    
    /// right
    var right: CGFloat {
        get {
            return frame.size.width + frame.origin.x
        }
    }
    
    /// size
    var size: CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get {
            return center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y = newValue
            center = tempCenter;
        }
    }
}

/// 底部安全距离
var bottomSafeH: CGFloat {
    get {
        if  UIDevice.is_iPhone_Xr() ||
            UIDevice.is_iPhone_X() ||
            UIDevice.is_iPhone_XsMax() {
            return 34
        }
        return 0
    }
}

/// 电池条🔋高度
var statusBarH: CGFloat {
    get {
        if  UIDevice.is_iPhone_X() ||
            UIDevice.is_iPhone_Xr() ||
            UIDevice.is_iPhone_XsMax() {
            return 40
        }
        return 20
    }
}

/// 导航栏高度
var navBarH: CGFloat {
    return 44
}


