//
//  Operator.swift
//  CalculatorSecondTry
//
//  Created by Erik Alfredsson on 2014-06-10.
//  Copyright (c) 2014 Erik Alfredsson. All rights reserved.
//

import UIKit

class Operator: NSObject {
   
    var currentOperation = String()
    
    var firstValue = Double()
    var secondValue = Double()
    var hasValidInput = Bool()
    var firstSlotIsEmpty = Bool()
    var inputOnCurrent = Bool()
    var hasDecimal = Bool()
    
    func clearAll() {
        hasValidInput = false
        hasDecimal = false
        firstValue = 0
        secondValue = 0
        firstSlotIsEmpty = true
        inputOnCurrent = false
    }
    
    func clear() {
        secondValue = 0
        inputOnCurrent = false
        hasValidInput = false
        hasDecimal = false
    }
    
    func saveCurrentValue(value: Double) {
        if firstSlotIsEmpty {
            firstValue = value
        }else {
            secondValue = value
        }
    }
    
    func currentSlotIsEmpty() -> Bool {
        if !inputOnCurrent {
            return true
        }else {
            return false
        }
    }
    
    func changeInputSlot() {
        firstSlotIsEmpty = false
    }
    
    func getReadyForNewInput() {
        inputOnCurrent = false
        hasValidInput = false
        hasDecimal = false
    }
    
    func shouldCalculate() -> Bool {
        if !firstSlotIsEmpty&&inputOnCurrent {
            return true
        }else {
            return false
        }
    }
    
    func solve() -> String {
        var result = Double()
        switch currentOperation {
        case "X":
            result = firstValue * secondValue
        case "-":
            result = firstValue - secondValue
        case "/":
            result = firstValue / secondValue
        case "%":
            result = firstValue % secondValue
        default:
            result = firstValue + secondValue
            
        }
        
        firstValue = result
        inputOnCurrent = false
        
        return formatResult(result)
    }
    
    func formatResult(unformatted: NSNumber) -> String {
        var numberFormatter = NSNumberFormatter()
        numberFormatter.maximumFractionDigits = 6
        numberFormatter.decimalSeparator = "."
        
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
        
        var formatted = numberFormatter.stringFromNumber(unformatted)
                
        if formatted.hasPrefix(".") {
            formatted = "0"+formatted
        }
        
        return formatted
    }
}
