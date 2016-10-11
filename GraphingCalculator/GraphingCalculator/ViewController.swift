//
//  ViewController.swift
//  GraphingCalculator
//
//  Created by Daniel Hauagge on 9/15/16.
//  Copyright © 2016 CS2048 Instructor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, FunctionPlottingViewDelegate {

    @IBOutlet weak var functionEntryTextField: UITextField!
    @IBOutlet weak var functionPlottingView: FunctionPlottingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        functionEntryTextField.delegate = self
        functionPlottingView.delegate = self
    }

    // MARK: - Text Field Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        functionEntryTextField.resignFirstResponder()
        functionPlottingView.setNeedsDisplay()
        return false
    }
    
    func functionToPlot() -> (Double -> Double)? {
        if functionEntryTextField.text == nil {
            return nil
        }
        
        var parsedExpr : NSExpression?
        do {
            try TryCatch.tryBlock {
                parsedExpr = NSExpression(format: self.functionEntryTextField.text!)
            }
        } catch {
            return nil
        }

        return { (x: Double) -> Double in
            let variables = ["x": x]
            let y = parsedExpr!.expressionValueWithObject(variables, context: nil)!.doubleValue
            return y
        }
    }
    
    @IBAction func pinchGestureTriggered(sender: UIPinchGestureRecognizer) {
        functionPlottingView.transPara = CGAffineTransformScale(functionPlottingView.transPara, sender.scale, sender.scale)
        sender.scale=1.0
        functionPlottingView.setNeedsDisplay()
    }
    @IBAction func panGestureTriggered(sender: UIPanGestureRecognizer) {
        let point = sender.translationInView(self.view)
        functionPlottingView.transPara = CGAffineTransformTranslate(functionPlottingView.transPara, point.x, point.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        functionPlottingView.setNeedsDisplay()
        
    }

    @IBAction func tapGestureTriggered(sender: UITapGestureRecognizer) {
        print("user tapped view")
        functionPlottingView.crosshairLocation = sender.locationInView(functionPlottingView)
        functionPlottingView.setNeedsDisplay()
    }
    
    @IBAction func longTapGestureTriggered(sender: UILongPressGestureRecognizer) {
        functionPlottingView.crosshairLocation = nil
        functionPlottingView.setNeedsDisplay()
    }

}

