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
        
        let moonView = PTMoonView(frame: CGRect(x: 0, y: 130, width: view.width , height: view.width),
                                  moonRadius: view.width / 2,
                                  panelRadius: view.width / 2,
                                  showBrightnessPanel: true,
                                  showHuePanel: true)
        view.addSubview(moonView)

        moonView.reload(bri: 0.5)
        moonView.reload(hue: 0.4)
        
        moonView.briChangeCompletion = { (bri) in
            print("bri : \(bri)")
        }
        
        moonView.hueChangeCompletion = { (hue) in
            print("hue : \(hue)")
        }
    }
}

