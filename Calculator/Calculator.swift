//
//  Calculate.swift
//  Calculator
//
//  Created by Jane Madsen on 2/10/23.
//

import UIKit

public enum MathOperators {
    case plus, minus, multiply, divide, equal
}

class Calculator {
    var viewController: ViewController
    var currentValue = "0"
    var decimalPressed = false
    var cachedValue = 0.0
    var previousOperator = MathOperators.equal
    var pressedEqual = false
    var clearAllDisplayed = true
    
    init(viewController: ViewController, currentValue: String = "0", decimalPressed: Bool = false, cachedValue: Double = 0.0, previousOperator: MathOperators = MathOperators.equal, pressedEqual: Bool = false, clearAllDisplayed: Bool = true) {
        self.viewController = viewController
        self.currentValue = currentValue
        self.decimalPressed = decimalPressed
        self.cachedValue = cachedValue
        self.previousOperator = previousOperator
        self.pressedEqual = pressedEqual
        self.clearAllDisplayed = clearAllDisplayed
    }
    
    // Adds a number to currentValue (unless value is already 0, in which case adds new number), then call updateCalculatorView to display it
    func addDigitToCalculator(_ digit: String) {
        resetCheck()
        
        if currentValue == "0" {
            currentValue = digit
        } else {
            currentValue += digit}
        viewController.updateCalculatorView()
        
    }
    
    // When pressing a number or . button, checks to see if equal was the last input--if so, starts a fresh equation.
    fileprivate func resetCheck() {
        if pressedEqual == true {
            currentValue = "0"
            cachedValue = 0
            pressedEqual = false
        }
    }
    
    // Upon being called, this function uses whichever operator was previously pressed to calculate the new value, and then displays that value
   func performNextOperation(newOperator: MathOperators) {
        // Check to make sure the last thing you pushed wasn't =; if it was, don't perform the previous operation again
        if pressedEqual == true && newOperator != .equal {
            pressedEqual = false
            previousOperator = newOperator
            currentValue = "0"
            return
        }
        
        // Perform the operation you last queued up
        switch previousOperator {
        case .equal:
            cachedValue = Double(currentValue) ?? 0
        case .plus:
            cachedValue += Double(currentValue) ?? 0
        case .minus:
            cachedValue -= Double(currentValue) ?? 0
        case .multiply:
            cachedValue *= Double(currentValue) ?? 0
        case .divide:
            cachedValue /= Double(currentValue) ?? 0
        }
        
        // If you pressed equal, hold off on assigning a previous operator until you press something else, and remember that equal was the most recent button so that you handle a new operator being pressed differently, or can clear and begin a new calculation altogether by pressing a number button
        if newOperator == .equal {
            pressedEqual = true
            
            // Otherwise, store the button you just pushed for the next time you're ready to run the operation
        } else {
            previousOperator = newOperator
            currentValue = "0"
        }
        
       viewController.updateCalculatorView(with: String(cachedValue))
       viewController.setClearButton(showClearAll: false)

    }
    
}
