//
//  ViewController.swift
//  Calculator
//
//  Created by Daniel on 5/3/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    @IBOutlet weak var descriptionOfOperations: UILabel!
    
    private var userInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
            if (digit == "." && textCurrentlyInDisplay.rangeOfString(".") != nil) {
                display.text = textCurrentlyInDisplay
            }
            
        } else {
            display.text = digit
        }
        userInTheMiddleOfTyping = true
    }
    private var displayValue: Double {
        get {return Double(display.text!)!}
        set {display.text = String(newValue)}
    }
    
    private var brain = CalculatorBrain()
    
    var savedProgram : CalculatorBrain.PropertyList?
    
    
    @IBAction func setVariable() {
        //savedProgram = brain.program
        //savedProgram = brain.program //Saved teh program
        userInTheMiddleOfTyping = false
        brain.variableValues["M"] = displayValue
        displayValue = brain.result
    }
    
    @IBAction func addVariable() {
//        if savedProgram != nil {
//            brain.program = savedProgram!
//            displayValue = brain.result
//            
//        }
        //This must act like pressing a digit
        brain.setOperand("M")
        displayValue = brain.result
    }
    
    
    @IBAction func performOperation(sender: UIButton) {
        if userInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            if (brain.isPartialResult) {
                descriptionOfOperations.text! = brain.description + "..."
            }
                //            else if (userInTheMiddleOfTyping){
                //                descriptionOfOperations.text! = brain.description
                //            }
            else if (brain.result != 0){
                descriptionOfOperations.text! = brain.description + "="
                
            }
            else {
                descriptionOfOperations.text! = ""
            }
        }
        displayValue = brain.result
    }
}