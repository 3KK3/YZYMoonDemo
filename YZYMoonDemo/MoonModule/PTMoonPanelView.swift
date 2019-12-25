//
//  PTMoonPanelView.swift
//  PTBLEMeshDemo
//
//  Created by 芝麻酱 on 2019/12/19.
//  Copyright © 2019 芝麻酱. All rights reserved.
//

import UIKit

protocol PTMoonPanelCapable {
    /// value: 0...1
    func reload(value: CGFloat)
}

@objc
class PTMoonPanelView: UIView, PTMoonPanelCapable {
    
    /// 圆心朝向
    enum position: Int {
        case top, bottom, left, right
    }
    
    private let pointCounts: Int
    private let settledColor: UIColor
    private let settledText: String
    private let dazzlingColor: UIColor
    private let dazzlingText: String
    private let position: position
    private let intervalRadian: CGFloat
    private let fromSettledClockwise: Bool
    
    private let settledImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
    private let settledLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
    private let dazzlingImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
    private let dazzlingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
    
    private var points = [CAShapeLayer]()
    private let kPointWidth: CGFloat = 5
    private let kIndicatorPointWidth: CGFloat = 12
    private let indicatePoint = UIView()
    
    /// 构造仪表盘
    /// - Parameters:
    ///   - pointCounts: 点的数量，包含边上的大○点
    ///   - settledColor: 顶边颜色
    ///   - settledText: 顶边文案
    ///   - dazzlingColor: 另一个顶边颜色   顺时针方向
    ///   - dazzlingText: 另一个顶边文案
    ///   - position: 圆弧所在位置
    ///   - intervalRadian: 点间隔弧度
    
    init(frame: CGRect,
         pointCounts: Int,
         settledColor: UIColor,
         settledText: String,
         dazzlingColor: UIColor,
         dazzlingText: String,
         position: position = .bottom,
         intervalRadian: CGFloat = CGFloat(Double.pi / 10),
         fromSettletdClockwise: Bool = true) {
        
        self.pointCounts = pointCounts
        self.settledColor = settledColor
        self.settledText = settledText
        self.dazzlingColor = dazzlingColor
        self.dazzlingText = dazzlingText
        self.position = position
        self.intervalRadian = intervalRadian
        self.fromSettledClockwise = fromSettletdClockwise
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        for index in 0..<pointCounts {
            
            let p = fromSettledClockwise ?
                path(endAngle: startAngle + intervalRadian * CGFloat(index)) :
                path(endAngle: startAngle - intervalRadian * CGFloat(index))
            
            if index == 0 {
                settledImgView.center = p.currentPoint
                indicatePoint.center = p.currentPoint
                continue
            }
            
            if index == (pointCounts - 1) {
                dazzlingImgView.center = p.currentPoint
                continue
            }
            
            let pointLayer = CAShapeLayer()
            pointLayer.frame = CGRect(x: 0, y: 0, width: kPointWidth, height: kPointWidth)
            pointLayer.cornerRadius = pointLayer.frame.size.width / 2
            pointLayer.backgroundColor = settledColor.cgColor
            pointLayer.position = p.currentPoint
            layer.addSublayer(pointLayer)
            points.append(pointLayer)
        }
        
        settledImgView.image = UIImage(named: "icon_masterTune_top")
        addSubview(settledImgView)
        
        dazzlingImgView.image = UIImage(named: "icon_masterTune_top")
        addSubview(dazzlingImgView)
        
        settledLabel.text = settledText
        settledLabel.font = UIFont.systemFont(ofSize: 11)
        settledLabel.textColor = .white
        addSubview(settledLabel)
        
        dazzlingLabel.textColor = .white
        dazzlingLabel.font = UIFont.systemFont(ofSize: 11)
        dazzlingLabel.text = dazzlingText
        addSubview(dazzlingLabel)
        
        
        let padding: CGFloat = 5
        
        switch self.position {
        case .top:
            if fromSettledClockwise {
                settledLabel.center = CGPoint(x: settledImgView.x - padding - settledLabel.width / 2,
                                              y: settledImgView.centerY)
                dazzlingLabel.center = CGPoint(x: dazzlingImgView.right + padding + dazzlingLabel.width / 2,
                                               y: dazzlingImgView.centerY)
            } else {
                settledLabel.center = CGPoint(x: settledImgView.right + padding + settledLabel.width / 2,
                                              y: settledImgView.centerY)
                dazzlingLabel.center = CGPoint(x: dazzlingImgView.x - padding - dazzlingLabel.width / 2,
                                               y: dazzlingImgView.centerY)
            }
            
        case .right:
            settledLabel.center = CGPoint(x: settledImgView.right + padding + settledLabel.width / 2,
                                          y: settledImgView.centerY)
            dazzlingLabel.center = CGPoint(x: dazzlingImgView.right + padding + dazzlingLabel.width / 2,
                                           y: dazzlingImgView.centerY)
            
        case .left:
            settledLabel.center = CGPoint(x: settledImgView.x - padding - settledLabel.width / 2,
                                          y: settledImgView.centerY)
            dazzlingLabel.center = CGPoint(x: dazzlingImgView.x - padding - dazzlingLabel.width / 2,
                                           y: dazzlingImgView.centerY)
        case .bottom:
            if fromSettledClockwise {
                settledLabel.center = CGPoint(x: settledImgView.right + padding + settledLabel.width / 2,
                                              y: settledImgView.centerY)
                dazzlingLabel.center = CGPoint(x: dazzlingImgView.x - padding - dazzlingLabel.width / 2,
                                               y: dazzlingImgView.centerY)
            } else {
                settledLabel.center = CGPoint(x: settledImgView.x - padding - settledLabel.width / 2,
                                              y: settledImgView.centerY)
                dazzlingLabel.center = CGPoint(x: dazzlingImgView.right + padding + dazzlingLabel.width / 2,
                                               y: dazzlingImgView.centerY)
            }
        }
        
        indicatePoint.backgroundColor = settledColor
        indicatePoint.bounds = CGRect(x: 0, y: 0, width: kIndicatorPointWidth, height: kIndicatorPointWidth)
        indicatePoint.layer.cornerRadius = kIndicatorPointWidth / 2
        addSubview(indicatePoint)
    }
    
    private func path(endAngle: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: CGPoint(x: width / 2.0, y: height / 2.0),
                                radius: min(width / 2.0, height / 2.0) - kIndicatorPointWidth / 2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: fromSettledClockwise)
        return path
    }
    
    private var startAngle: CGFloat {
        get {
            let startAngle: CGFloat
            // 全部角度
            let totalAngle = CGFloat(pointCounts - 1) * intervalRadian
            
            switch self.position {
            case .top:
                if fromSettledClockwise {
                    // 起始角度是270度开始  逆时针偏移一半
                    startAngle = CGFloat(Double.pi / 2 * 3) - (totalAngle / 2)
                } else {
                    startAngle = CGFloat(Double.pi / 2 * 3) + (totalAngle / 2)
                }
                
            case .left:
                if fromSettledClockwise {
                    // 起始角度是180度开始  逆时针偏移一半
                    startAngle = CGFloat(Double.pi) - (totalAngle / 2)
                } else {
                    startAngle = CGFloat(Double.pi) + (totalAngle / 2)
                }
                
            case .bottom:
                if fromSettledClockwise {
                    // 起始角度是90度开始  逆时针偏移一半
                    startAngle = CGFloat(Double.pi / 2) - (totalAngle / 2)
                } else {
                    startAngle = CGFloat(Double.pi / 2) + (totalAngle / 2)
                }
                
            case .right:
                if fromSettledClockwise {
                    // 起始角度是0度开始  逆时针偏移一半
                    startAngle =  -(totalAngle / 2)
                } else {
                    startAngle = totalAngle / 2
                }
            }
            
            return startAngle
        }
    }
}

extension PTMoonPanelView {
    
    func reload(value: CGFloat) {
        var checkValue: CGFloat = value
        
        if checkValue > 1 { checkValue = 1.0 }
        if checkValue < 0 { checkValue = 0.0 }
        
        let endAngle = fromSettledClockwise ?
            startAngle + CGFloat(pointCounts - 1) * intervalRadian * checkValue :
            startAngle - CGFloat(pointCounts - 1) * intervalRadian * checkValue
        
        let p = path(endAngle: endAngle)
        
        //        let x = width / 2.0 + width / 2.0 * cos(endAngle)
        //        let y = width / 2.0 + width / 2.0 * sin(endAngle)
        indicatePoint.center = p.currentPoint
        indicatePoint.backgroundColor = UIColor.colorBetween(settledColor,
                                                             endColor: dazzlingColor,
                                                             location: checkValue)
        
        for (index, point) in points.enumerated() {
            
            if p.cgPath.contains(CGPoint(x: floor(point.position.x), y: floor(point.position.y))) ||
                p.cgPath.contains(CGPoint(x: ceil(point.position.x), y: ceil(point.position.y))) {
                
                let location = CGFloat(index) / CGFloat(pointCounts)
                point.backgroundColor = UIColor.colorBetween(settledColor,
                                                             endColor: dazzlingColor,
                                                             location: location).cgColor
            } else {
                point.backgroundColor = settledColor.cgColor
            }
        }
    }
}
