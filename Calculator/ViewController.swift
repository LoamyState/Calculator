//
//  ViewController.swift
//  Calculator
//
//  Created by Jane Madsen on 1/23/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var calculatorValue: UILabel!
    
    @IBOutlet var clearButtonOutlet: UIButton!
    
    var currentValue: String = "0"
    var decimalPressed: Bool = false
    var cachedValue: Double = 0.0
    var previousOperator: MathOperators = .equal
    var pressedEqual = false
    var clearAllDisplayed: Bool = true
    
    enum MathOperators {
        case plus, minus, multiply, divide, equal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

 
    
    // Called whenever the Calculator's label needs to be updated
    fileprivate func updateCalculatorView(with customValue: String? = nil) {
        if let customValue {
            calculatorValue.text = customValue
        } else {
            calculatorValue.text = currentValue
        }
    }
    

    
    // Called whenever a number button is pressed, passes the number selected to the addDigitToCalculator function
    @IBAction func numButton(_ sender: UIButton) {
        resetCheck()
        
        guard let digit = sender.titleLabel?.text else {
            return
        }
        addDigitToCalculator(digit)
        setClearButton(showClearAll: false)
    }
    
    
    // Adds a number to valueToDisplay (unless value is already 0, in which case adds new number), then call updateCalculatorView to display it
    fileprivate func addDigitToCalculator(_ digit: String) {
        resetCheck()
        
        if currentValue == "0" {
            currentValue = digit
        } else {
            currentValue += digit}
        updateCalculatorView()
        
    }
    
    // When pressing a number or . button, checks to see if equal was the last input--if so, starts a fresh equation.
    fileprivate func resetCheck() {
        if pressedEqual == true {
            currentValue = "0"
            cachedValue = 0
            pressedEqual = false
        }
    }
    
    // Called whenever the . button is pressed
    @IBAction func decimalButton(_ sender: Any) {
        if decimalPressed == false {
            currentValue += "."
        }
        
        decimalPressed = true
        setClearButton(showClearAll: false)
    }
    

    
    // Functions for whenever +, -, X, ÷, or = are pressed
    @IBAction func plusButton(_ sender: Any) {
        performNextOperation(newOperator: .plus)
    }
    
    @IBAction func minusButton(_ sender: Any) {
        performNextOperation(newOperator: .minus)
    }
    
    @IBAction func timesButton(_ sender: Any) {
        performNextOperation(newOperator: .multiply)
    }
    
    @IBAction func divideButton(_ sender: Any) {
        performNextOperation(newOperator: .divide)
    }
    
    @IBAction func equalButton(_ sender: Any) {
        performNextOperation(newOperator: .equal)
    }
    

    
    // Upon being called, this function uses whichever operator was previously pressed to calculate the new value, and then displays that value
    fileprivate func performNextOperation(newOperator: MathOperators) {
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
        
        updateCalculatorView(with: String(cachedValue))
        setClearButton(showClearAll: false)

    }
    
    
    @IBAction func positiveNegativePress(_ sender: Any) {
        if currentValue.hasPrefix("-") {
            currentValue.replace("-", with: "")
        } else {
            currentValue = "-\(currentValue)"
        }
        updateCalculatorView()
    }
    
    
    @IBAction func percentButtonPress(_ sender: Any) {
        if previousOperator != .equal {
            currentValue = String(cachedValue * ((Double(currentValue) ?? 0) / 100))
            updateCalculatorView()
        } else {
            currentValue = String((Double(calculatorValue.text ?? "0") ?? 0) / 100)
            updateCalculatorView()
        }

    }
    
    // The clear button should initially say "AC", say "Clear" while the user is performing calculations, say "AC" after being pressed, and then stay on "AC" and do nothing if pressed again.
    @IBAction func clearButtonPress(_ sender: Any) {
        //First press -- clears current value
        
        currentValue = "0"
        decimalPressed = false
        updateCalculatorView()
        setClearButton(showClearAll: true)
            
        //Second press -- clears cached values
        if clearAllDisplayed {
            cachedValue = 0
            previousOperator = .equal
        }
    }
    
    fileprivate func setClearButton(showClearAll: Bool) {
        if showClearAll {
            clearAllDisplayed = true
            clearButtonOutlet.setTitle("AC", for: .normal)
        } else {
            clearAllDisplayed = false
            clearButtonOutlet.setTitle("Clear", for: .normal)
        }
    }
    
}

