//
//  WindDirectionView.swift
//  TutsplusWeather
//
//  Created by Markus Mühlberger on 02/02/2017.
//  Copyright © 2017 Markus Mühlberger. All rights reserved.
//

import UIKit

@IBDesignable
class WindDirectionView : UIControl {
    @IBInspectable
    public var windDirection : CGFloat {
        get {
            return self.windLayer.windDirection
        }
        set {
            self.windLayer.windDirection = newValue
        }
    }
    
    var windLayer : WindDirectionLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }
    
    private func sharedInitialization() {
        windLayer = WindDirectionLayer()
        windLayer.bounds = layer.bounds
        windLayer.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
        self.layer.addSublayer(windLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        windLayer.bounds = layer.bounds
        windLayer.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
        windLayer.layoutSublayers()
    }
}

class WindDirectionLayer : CALayer {
    public var windDirection : CGFloat = 0.0 {
        didSet {
            preparePaths()
            directionLayer.transform = CATransform3DMakeRotation(windDirection/180 * CGFloat.pi, 0, 0, 1)
        }
    }
    
    lazy var borderLayer : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 5
        layer.fillColor = nil
        return layer
    }()
    
    lazy var directionLayer : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 0
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()
    
    override init() {
        super.init()
        sharedInitialization()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        sharedInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }
    
    func sharedInitialization() {
        self.addSublayer(borderLayer)
        self.addSublayer(directionLayer)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        if borderLayer.bounds != bounds {
            let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
            borderLayer.bounds = bounds
            borderLayer.position = center
            directionLayer.bounds = bounds
            directionLayer.position = center
            preparePaths()
        }
    }
    
    func preparePaths() {
        borderLayer.path = UIBezierPath(arcCenter: borderLayer.position,
                                        radius: (bounds.width - 10) / 2.0,
                                        startAngle: 0,
                                        endAngle: 2.0 * CGFloat.pi,
                                        clockwise: true).cgPath
        let path = CGMutablePath()
        path.move(to: CGPoint(x: directionLayer.bounds.midX + 0.1 * directionLayer.bounds.width, y: 0.75 * directionLayer.bounds.width))
        path.addLine(to: CGPoint(x: directionLayer.bounds.midX, y: 0.25 * directionLayer.bounds.width))
        path.addLine(to: CGPoint(x: directionLayer.bounds.midX - 0.1 * directionLayer.bounds.width, y: 0.75 * directionLayer.bounds.width))
        path.addLine(to: CGPoint(x: directionLayer.bounds.midX, y: 0.65 * directionLayer.bounds.width))
        directionLayer.path = path
    }
}
