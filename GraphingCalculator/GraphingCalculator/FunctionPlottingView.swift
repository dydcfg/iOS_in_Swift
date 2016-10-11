//
//  FunctionPlottingView.swift
//  GraphingCalculator
//
//  Created by Daniel Hauagge on 9/15/16.
//  Copyright © 2016 CS2048 Instructor. All rights reserved.
//

import UIKit

// f(x) = x**2

//func f(x: Double) {
//    return x * x
//}

protocol FunctionPlottingViewDelegate {
    func functionToPlot() -> (Double -> Double)?
}

@IBDesignable
class FunctionPlottingView: UIView {
    @IBInspectable var axisColor : UIColor! = UIColor.blueColor()
    
    var delegate : FunctionPlottingViewDelegate?
    
    var initFlag : Bool? = false
    
    var transPara: CGAffineTransform = CGAffineTransformIdentity
    
    var crosshairLocation : CGPoint? = CGPoint(x:100.0, y:100.0)
    
    func drawCrosshair(rect: CGRect) {
        if crosshairLocation == nil {
            return
        }
        
        let f = self.delegate!.functionToPlot()
        
        if f == nil {
            return
        }
        
        let path = UIBezierPath()
        
        let pattern: [CGFloat] = [15.0, 5.0]
        path.setLineDash(pattern, count: 2, phase: 0.0)
        
        let scaleZoom = transPara.a
        let scale = scaleZoom*(rect.width / 2)
        let shift = CGPoint(x: rect.midX, y: rect.midY)
        
        let yVal:CGFloat = CGFloat(f!(Double((crosshairLocation!.x-shift.x-transPara.tx)/scale)))*(-scale)+shift.y+transPara.ty
        
        if !yVal.isNormal{
            return
        }
    
        //print(transPara.tx,transPara.ty)
        
        // X axis
        path.moveToPoint(CGPoint(x: 0, y: yVal))
        path.addLineToPoint(CGPoint(x: rect.maxX, y: yVal))
        UIColor.lightGrayColor().setStroke()
        
        // Y axis
        path.moveToPoint(CGPoint(x: crosshairLocation!.x, y: 0))
        path.addLineToPoint(CGPoint(x: crosshairLocation!.x, y: rect.maxY))
        UIColor.lightGrayColor().setStroke()
        
        //path.applyTransform(transPara)
        
        path.stroke()
        
        let label = NSString(format: "x = %.4f, y = %.4f", (crosshairLocation!.x-shift.x-transPara.tx)/scale, (yVal-shift.y-transPara.ty)/(-scale))
        label.drawAtPoint(CGPoint(x:crosshairLocation!.x, y:yVal), withAttributes: nil)
    }
    
    func drawAxis(rect: CGRect) {
        let path = UIBezierPath()
        
        let scale = transPara.a
        
        // X axis
        path.moveToPoint(CGPoint(x: -transPara.tx/scale, y: rect.midY/scale))
        path.addLineToPoint(CGPoint(x: (rect.maxX-transPara.tx)/scale, y: rect.midY/scale))
        axisColor.setStroke()
        
        // Y axis
        path.moveToPoint(CGPoint(x: rect.midX/scale, y: -transPara.ty/scale))
        path.addLineToPoint(CGPoint(x: rect.midX/scale, y: (rect.maxY-transPara.ty)/scale))
        path.applyTransform(transPara)
        axisColor.setStroke()
        
        path.stroke()
    }
    
    func drawFunction(rect: CGRect) {
        if delegate == nil {
            return
        }
        
        let f = self.delegate!.functionToPlot()
        if f == nil {
            return
        }
        
        var prevPnt : CGPoint?
        var pnt = CGPoint()
        let path = UIBezierPath()
        for var x = -1.0; x <= 1.0; x += 0.01 {
            // Convert coordinates
            let scale = rect.width / 2
            let scaleZoom = transPara.a
            let shift = CGPoint(x: rect.midX/scaleZoom, y: rect.midY/scaleZoom)
            
            pnt.x = CGFloat((x-Double(transPara.tx/scale))/Double(scaleZoom))
            pnt.y = CGFloat(f!((x-Double(transPara.tx/scale))/Double(scaleZoom)))
            
            if !pnt.y.isNormal {
                path.stroke()
                continue
            }
            
            pnt.x *= scale
            pnt.y *= -scale
            
            pnt.x += shift.x
            pnt.y += shift.y
            
            if prevPnt != nil {
                path.addLineToPoint(pnt)
            } else {
                path.moveToPoint(pnt)
            }
            
            prevPnt = pnt
        }
        UIColor.redColor().setStroke()
        path.lineWidth = 2
        path.applyTransform(transPara)
        path.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        print(transPara.a,transPara.b,transPara.c,transPara.d)
        drawAxis(rect)
        drawFunction(rect)
        drawCrosshair(rect)
    }
}
