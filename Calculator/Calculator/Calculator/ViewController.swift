//
//  ViewController.swift
//  Calculator
//
//  Created by 向仁楷 on 16/9/18.
//  Copyright © 2016年 reven. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet var resultString: UILabel!
    @IBOutlet var buttons: [UIButton]!
    var ans: Float!
    var curVal: Float!
    var operatorType: Int!
    var deciState: Bool!
    var deciCount: Int!
    var tmpString: String!
    var lastButtonTag: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for x in buttons {
            x.addTarget(self, action: #selector(ViewController.buttonClicked(_:)), for: .touchUpInside)
        }
        ans=0.0
        curVal=0.0
        operatorType=1
        resultString.text="0"
        tmpString=""
        deciState=false
        deciCount=1
        lastButtonTag=0
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func printTmp(_ x: String) {
        resultString.text=x
    }
    
    func printIt(_ x: Float) {
        if floor(x) == x{
            resultString.text=String(Int(x))
        }
        else{
            resultString.text=String(x)
        }
    }
    
    func appendDig(_ dig: Int) {
        if curVal==0.0 && deciState==false && dig==0 {
            return
        }
        
        tmpString=tmpString+String(dig)
        
        if deciState==true {
            deciCount=deciCount*10
            curVal=curVal+Float(dig)/Float(deciCount)
        }
        else{
            curVal=curVal*10+Float(dig)
        }
        
        if (curVal != 0.0) && (operatorType == -1) && (tmpString[tmpString.characters.startIndex] != "-") {
            tmpString="-"+tmpString
        }
        
        printTmp(tmpString)
        
    }
    
    func evalIt() {
        ans=ans+Float(operatorType)*curVal
        
        printIt(ans)
    }
    
    func addDecimal() {
        
        if deciState==true{
            return
        }
        
        if tmpString.characters.count==0{
            tmpString="0"
        }
        
        tmpString=tmpString+"."
        deciState=true
        
        printTmp(tmpString)
        
    }
    
    func allClear() {
        ans=0.0
        curVal=0.0
        operatorType=1
        resultString.text="0"
        tmpString=""
        deciState=false
        deciCount=1
        lastButtonTag=0
    }
    
    // Button click handler
    func buttonClicked(_ sender: UIButton) {
        
        print(sender.tag)
        
        if sender.tag<10 {
            if lastButtonTag==10 {
                allClear()
            }
            
            if lastButtonTag==13 || lastButtonTag==14 {
                curVal=0.0
                tmpString=""
                deciState=false
                deciCount=1
            }
            
            appendDig(sender.tag)
        }
        if sender.tag==10 {
            evalIt()
        }
        if sender.tag==11 {
            addDecimal()
        }
        if sender.tag==12 {
            allClear()
        }
        if sender.tag==13 {
            evalIt()
            operatorType = 1
            tmpString=""
            curVal=0.0
        }
        if sender.tag==14 {
            evalIt()
            operatorType = -1
            tmpString=""
            curVal=0.0
        }
        lastButtonTag=sender.tag
    }

}

