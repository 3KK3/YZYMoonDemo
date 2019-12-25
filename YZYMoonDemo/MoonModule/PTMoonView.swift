//
//  PTMoonView.swift
//  PTBLEMeshDemo
//
//  Created by 芝麻酱 on 2019/12/24.
//  Copyright © 2019 芝麻酱. All rights reserved.
//
import UIKit
import SceneKit

protocol PTMoonViewCapable {
    
    /// 0...1
    func reload(bri value: CGFloat)
    /// 0...1
    func reload(hue value: CGFloat)
}

@objc
class PTMoonView: UIView, PTMoonViewCapable {
    
    typealias ChangeHandler = (CGFloat)->()

    var hueChangeCompletion: ChangeHandler?
    var briChangeCompletion: ChangeHandler?
    
    private let showBriPanel: Bool
    private let showHuePanel: Bool
    private let moonNode = SCNNode()
    private let lightNode = SCNNode()
    private let kRotateDistance: Float = 600 // 玄学距离
    private var startPanLocation = CGPoint.zero
    private var latestPanLocation = CGPoint.zero
    private var endPanVelocity = CGPoint.zero
    private let moonRadius: CGFloat
    private let panelRadius: CGFloat
    private var displayLink: CADisplayLink?
    
    private var currentBri: CGFloat = 0 {
        didSet {
            if currentBri > 1 { currentBri = 1.0 }
            if currentBri < 0 { currentBri = 0.0 }
            
            if let h = self.briChangeCompletion {
                h(currentBri)
            }
        }
    }
    private var currentHue: CGFloat = 0 {
        didSet {
            if currentHue > 1 { currentHue = 1.0 }
            if currentHue < 0 { currentHue = 0.0 }
            
            if let h = self.hueChangeCompletion {
                h(currentHue)
            }
        }
    }
    
    private lazy var briPanel: PTMoonPanelView = { [unowned self] in
        let panel = PTMoonPanelView(frame: CGRect(x: 0, y: 0, width: self.panelRadius * 2, height: self.panelRadius * 2),
                                    pointCounts: 11,
                                    settledColor: UIColor.hexString("#646464"),
                                    settledText: "暗",
                                    dazzlingColor: UIColor.hexString("#ffffff"),
                                    dazzlingText: "明",
                                    position: .top,
                                    intervalRadian: CGFloat(Double.pi / 30.0),
                                    fromSettletdClockwise: false)
        return panel
        }()
    private lazy var huePanel: PTMoonPanelView = { [unowned self] in
        let panel = PTMoonPanelView(frame: CGRect(x: 0, y: 0, width: self.panelRadius * 2, height: self.panelRadius * 2),
                                    pointCounts: 11,
                                    settledColor: UIColor.hexString("#646464"),
                                    settledText: "冷",
                                    dazzlingColor: UIColor.hexString("#ffce64"),
                                    dazzlingText: "暖",
                                    position: .left,
                                    intervalRadian: CGFloat(Double.pi / 30.0))
        return panel
        }()
    
    /// 球的半径会受制于view的bounds大小
    init(frame: CGRect,
         moonRadius: CGFloat = 35,
         panelRadius: CGFloat = 150,
         showBrightnessPanel: Bool = true,
         showHuePanel: Bool = false) {
        
        self.showBriPanel = showBrightnessPanel
        self.showHuePanel = showHuePanel
        self.moonRadius = moonRadius
        self.panelRadius = panelRadius
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        if showBriPanel {
            addSubview(briPanel)
            briPanel.center = CGPoint(x: width / 2, y: height / 2)
        }
        
        if showHuePanel {
            addSubview(huePanel)
            huePanel.center = CGPoint(x: width / 2, y: height / 2)
        }
        
        let sceneView = SCNView(frame: bounds)
        sceneView.backgroundColor = .clear
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = false
        sceneView.scene = SCNScene()
        addSubview(sceneView)
        
        moonNode.position = SCNVector3Make(0, 0, 0)
        let moonSphere = SCNSphere(radius: moonRadius)
        moonSphere.segmentCount = 1000
        moonSphere.firstMaterial?.diffuse.contents = UIImage(named: "bulb_monn.jpeg")
        moonNode.geometry = moonSphere
        sceneView.scene?.rootNode.addChildNode(moonNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.automaticallyAdjustsZRange = true
        cameraNode.position = SCNVector3Make(0, 0, Float(moonRadius * 3))
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        let omniLightNode = SCNNode()
        omniLightNode.position = SCNVector3Make(0, 0, kRotateDistance)
        let omniLight = SCNLight()
        omniLight.type = .ambient
        omniLight.color = UIColor.hexString("0x343434")
        omniLightNode.light = omniLight
        sceneView.scene?.rootNode.addChildNode(omniLightNode)
        
        lightNode.position = SCNVector3Make(0, 0, -kRotateDistance)
        let hueLight = SCNLight()
        hueLight.type = .omni
        hueLight.color = UIColor.white
        lightNode.light = hueLight
        sceneView.scene?.rootNode.addChildNode(lightNode)
        
        let panViewW: CGFloat = 250
        let panView = UIView(frame: CGRect(x: width / 2 -  panViewW / 2,
                                           y: height / 2 - panViewW / 2,
                                           width: panViewW,
                                           height: panViewW))
        panView.backgroundColor = .clear
        addSubview(panView)
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panGesAction))
        panView.addGestureRecognizer(panGes)
        
    }
    
    @objc private func panGesAction(panGes: UIPanGestureRecognizer) {
        
        let translation = panGes.translation(in: self)
        
        switch panGes.state {
        case .began:
            startPanLocation = translation
            latestPanLocation = CGPoint.zero
            refreshMoonPivot()
            stopTimer()
            
        case .changed:
            let horizTransformDistance = translation.x - startPanLocation.x
            let verticalTransformDistance = translation.y - startPanLocation.y
            
            refreshUI(moonTransformX: horizTransformDistance,
                      moonTransformY: verticalTransformDistance,
                      briChange: (horizTransformDistance - latestPanLocation.x),
                      hueChange: (verticalTransformDistance - latestPanLocation.y))
            
            latestPanLocation = CGPoint(x: horizTransformDistance, y: verticalTransformDistance)
            
        case .ended:
            endPanVelocity = panGes.velocity(in: self)
            startPanLocation = CGPoint(x: translation.x - startPanLocation.x,
                                       y: translation.y - startPanLocation.y)
            beginTimer()
            
        default:
            break
        }
    }
    
    private func beginTimer() {
        if displayLink != nil { return }
        displayLink = CADisplayLink(target: self, selector: #selector(timerAction))
        displayLink?.preferredFramesPerSecond = 0
        displayLink?.add(to: RunLoop.main, forMode: .default)
    }
    
    private func stopTimer() {
        if displayLink == nil { return }
        displayLink?.isPaused = true
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func timerAction() {
        let velocityDecreaseRatio: CGFloat = 0.8
        let newVelocity = CGPoint(x: endPanVelocity.x * velocityDecreaseRatio,
                                  y: endPanVelocity.y * velocityDecreaseRatio)
        
        let moveTime: CGFloat = 1 / 90.0
        let movePoint = CGPoint(x: newVelocity.x * moveTime, y: newVelocity.y * moveTime)
        
        if abs(movePoint.x) <= 1 && abs(movePoint.y) <= 1 {
            stopTimer()
            return
        }
        startPanLocation.x += movePoint.x
        startPanLocation.y += movePoint.y
        endPanVelocity = newVelocity
        
        refreshUI(moonTransformX: startPanLocation.x,
                  moonTransformY: startPanLocation.y,
                  briChange: movePoint.x,
                  hueChange: movePoint.y)
    }
    
    private func refreshUI(moonTransformX: CGFloat,
                           moonTransformY: CGFloat,
                           briChange: CGFloat,
                           hueChange: CGFloat) {
        
        currentBri -= briChange / 1000
        currentHue -= hueChange / 1000
        
        rotateMoon(x: moonTransformX, y: moonTransformY, rate: 0.8)
        
        briPanel.reload(value: currentBri)
        huePanel.reload(value: currentHue)
        rotateLightNode(with: Float(currentBri))
        lightNode.light?.color = UIColor.colorBetween(UIColor.hexString("#ffffff"),
                                                      endColor: UIColor.hexString("#ffce64"),
                                                      location: currentHue)
    }
    
    private func rotateMoon(x: CGFloat, y: CGFloat, rate: CGFloat) {
        let angle = sqrt(pow(x, 2) + pow(y, 2)) * CGFloat(Double.pi) / 180.0
        moonNode.rotation = SCNVector4Make(Float(y), Float(x), 0, Float(angle * rate))
    }
    
    private func refreshMoonPivot() {
        let matrix = moonNode.pivot
        let changeMatrix = SCNMatrix4Invert(moonNode.transform)
        moonNode.pivot = SCNMatrix4Mult(changeMatrix, matrix)
        moonNode.transform = SCNMatrix4Identity
    }
    
    /// value  1...0
    private func rotateLightNode(with value: Float) {
        //        // 对应的光源旋转角度是 0...pi
        let x = sinf(value * Float(Double.pi)) * kRotateDistance
        let z = -cos(value * Float(Double.pi)) * kRotateDistance
        lightNode.position = SCNVector3Make(x, 0, z)
    }
}

extension PTMoonView {
    func reload(bri value: CGFloat) {
        
        if !showBriPanel { return }
        
        currentBri = value
        briPanel.reload(value: value)
        rotateLightNode(with: Float(value))
    }
    
    func reload(hue value: CGFloat) {
        
        if !showHuePanel { return }
        
        currentHue = value
        huePanel.reload(value: value)
    }
}
