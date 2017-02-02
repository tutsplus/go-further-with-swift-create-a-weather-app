//
//  DrawingCanvas.swift
//  TutsplusWeather
//
//  Created by Markus Mühlberger on 02/02/2017.
//  Copyright © 2017 Markus Mühlberger. All rights reserved.
//

import UIKit

@IBDesignable
class DrawingCanvas : UIView {
    @IBInspectable
    public var strokeWidth : CGFloat = 5.0
    
    @IBInspectable
    public var strokeColor : UIColor = .white
    
    var canvas : UIImage?
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            addLine(from: touch.previousLocation(in: self), to: touch.location(in: self))
        }
    }
    
    func addLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        canvas?.draw(in: bounds)
        
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(.round)
        context?.setLineWidth(strokeWidth)
        strokeColor.setStroke()
        
        context?.strokePath()
        
        canvas = UIGraphicsGetImageFromCurrentImageContext()
        layer.contents = canvas?.cgImage
        
        UIGraphicsEndImageContext()
    }
}
