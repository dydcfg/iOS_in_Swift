//
//  FunctionPlottingView.swift
//  GraphingCalculator
//
//  Created by Daniel Hauagge on 9/17/16.
//  Copyright © 2016 CS2048 Instructor. All rights reserved.
//

import UIKit

func f(x : Double) -> Double { // (Double -> Double)
    return x * x
}

protocol FunctionPlottingViewDelegate {
    func functionToPlot() -> (Double -> Double)?
}

class FunctionPlottingView: UIView {
    
    var delegate : FunctionPlottingViewDelegate?
    
    var crosshairLoc : CGPoint? = CGPoint(x: 50, y: 50)
    
    func drawCrosshair(rect: CGRect) {
        if crosshairLoc == nil {
            return
        }
        
        let path = UIBezierPath()
        
        // X Axis
        path.moveToPoint(CGPoint(x: 0, y: crosshairLoc!.y))
        path.addLineToPoint(CGPoint(x: rect.maxX, y:crosshairLoc!.y))
        
        // Y Axis
        path.moveToPoint(CGPoint(x: crosshairLoc!.x, y: 0))
        path.addLineToPoint(CGPoint(x: crosshairLoc!.x, y:rect.maxY))
        
        UIColor.lightGrayColor().setStroke()
        path.stroke() // <- Does the actual drawing!!!
        
        let label = NSString(format: "(x:%.1f, y:%.1f)", crosshairLoc!.x, crosshairLoc!.y)
        label.drawAtPoint(crosshairLoc!, withAttributes: nil)
    }
    
    func drawFunction(rect: CGRect) {
        if delegate == nil {
            return
        }
        
        let f = delegate?.functionToPlot()
        if f == nil {
            return
        }
        
        let scale = rect.width / 2.0
        var prevP : CGPoint?
        let path = UIBezierPath()
        for var x = -1.0; x <= 1.0; x += 0.01 {
            let y = f!(x)
            
            var p = CGPoint(x:x, y:y)
            p.x *= scale
            p.y *= -scale
            
            p.x += rect.midX
            p.y += rect.midY
            
            if prevP == nil {
                path.moveToPoint(p)
            } else {
                path.addLineToPoint(p)
            }
            prevP = p
        }
        UIColor.redColor().setStroke()
        path.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        
        // X Axis
        path.moveToPoint(CGPoint(x: 0.0, y: rect.midY))
        path.addLineToPoint(CGPoint(x: rect.maxX, y:rect.midY))
        UIColor.blueColor().setStroke()
        
        // Y Axis
        path.moveToPoint(CGPoint(x: rect.midX, y: 0))
        path.addLineToPoint(CGPoint(x: rect.midX, y:rect.maxY))
        UIColor.blueColor().setStroke()
        
        path.stroke() // <- Does the actual drawing!!!
        
        // Draw the function
        drawFunction(rect)
        drawCrosshair(rect)
    }
}
