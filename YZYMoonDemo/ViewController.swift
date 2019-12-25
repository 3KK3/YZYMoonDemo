//
//  ViewController.swift
//  YZYMoonDemo
//
//  Created by 芝麻酱 on 2019/12/25.
//  Copyright © 2019 芝麻酱. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.hexString("#101124")
        
        let w: CGFloat = 300
        let moonView = PTMoonView(frame: CGRect(x: view.width / 2 - w / 2, y: 130, width: w , height: w),
                                  showBrightnessPanel: true,
                                  showHuePanel: true)
        view.addSubview(moonView)

        moonView.reload(bri: 0.3)
        moonView.reload(hue: 0.4)
        
        moonView.briChangeCompletion = { (bri) in
            print("bri : \(bri)")
        }
        
        moonView.hueChangeCompletion = { (hue) in
            print("hue : \(hue)")
        }
    }
}

