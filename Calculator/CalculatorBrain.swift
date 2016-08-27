//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Daniel on 5/3/16.
//  Copyright © 2016 Daniel. All rights reserved.
//
//Only on evaluation should I see what M equals



import Foundation

class CalculatorBrain
{
    private var accumulator = 0.0
    private var allOperations = ""
    private var savedProgram = [AnyObject]()
    var description : String {
        get {
            var tempString = ""
            for op in internalProgram {
                if let operand = op as? Double  {
                    tempString += operand % 1 == 0 ? String(format: "%.0f", operand) : String(operand)
                }
                else if let operation = op as? String {
                    if let varible = operations[operation] {
                        switch (varible) {
                        case .BinaryOperation(_): break//Figure out how to display binary operation
                        default: break
                        }
                        if (operation != "=") {
                            //If unary operation && isPartial then just put it right before teh last entry
                            //else if unary && !isPartial put it at the beginning
                            tempString += operation
                        }
                    }
                }
            }
            return tempString
        }
    }

    //Array of strings / doubles.  Doubles are operands and Strings are operations
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double)
    {
        if pending == nil {clear()}
        accumulator = operand
        internalProgram.append(operand)
        //description += String(operand)
    }
    
    func setOperand(variableName: String)
    {
        if pending == nil {clear()}
        if ((variableValues[variableName]) == nil) { //If variable isn't set then set to 0
            variableValues[variableName] = 0.0
        }
        internalProgram.append(variableName)//Set internal program to variable
        accumulator = variableValues[variableName]!

    }
    
    //var variableValues = Dictionary<String,Double>
    var variableValues = [String:Double]() { // Use to just create an empty one
        didSet {//load and run program if we update variables
            program = internalProgram
        }
        
    }
    //Dictionary of types of operations
    private var operations: Dictionary<String,Operation> = [ //Use if I want to define in code
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "cos" : Operation.UnaryOperation(cos),
        "√" : Operation.UnaryOperation(sqrt),
        "±" : Operation.UnaryOperation({ -$0 }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "=" : Operation.Equals,
        "C" : Operation.Clear,
        //"→M" : Operation.Equals
        //"M" : Operation.Variable("M")

    ]
    
    //Anytime I put in a variable and press = it should store that equation in memory
    //When I asssign a variable it puts that number in for the remembered equation and evaluates
    
    //defines a type so a constant is a type which takes a double as an argument
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> (Double))
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
    }

    
    func performOperation(symbol: String)
    {
        print((internalProgram))
        //if (symbol != "=") {description += symbol}
        //else {description += String(accumulator)}
        print("des: \(description)")
        if let operation = operations[symbol] {
            //if(symbol == "=") {allOperations = ""}
            //allOperations += symbol
            switch operation {
            case .Constant(let value):
                if pending == nil {Operation.Clear}
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                clear()
            }
        }
        internalProgram.append(symbol)

    }
    
    private func clear()
    {
        accumulator = 0
        pending = nil
        internalProgram.removeAll()
    }
    
    var isPartialResult: Bool {
        get {
            if ((pending) != nil) {return true}
            else {return false}
        }
    }

    
    private func executePendingBinaryOperation()
    {
        if pending != nil
        {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
        
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    typealias PropertyList = AnyObject

    var program : PropertyList {
        get {
            return internalProgram
        }
        
        set { //Setting this runs teh program
            //Goes through array of operands and operations and executes perform operation for each
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        if operations[operation] != nil {
                            performOperation(operation)
                        } else {
                            setOperand(operation)
                        }
                    }
                }
            }
        }
    }

    
    var result: Double {
            return accumulator
    }
    
}