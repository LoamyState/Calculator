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
    
    var calculator: Calculator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator = Calculator(viewController: self)
    }
    
    
    
    // Called whenever a number button is pressed, passes the number selected to the addDigitToCalculator function
    @IBAction func numButton(_ sender: UIButton) {
        guard let digit = sender.titleLabel?.text else {
            return
        }
        calculator.addDigitToCalculator(digit)
        setClearButton(showClearAll: false)
    }
    
    // Called whenever the . button is pressed
    @IBAction func decimalButton(_ sender: Any) {
        if calculator.decimalPressed == false {
            calculator.currentValue += "."
        }
        
        calculator.decimalPressed = true
        setClearButton(showClearAll: false)
    }
    

    
    // Functions for whenever +, -, X, ÷, or = are pressed
    @IBAction func plusButton(_ sender: Any) {
        calculator.performNextOperation(newOperator: .plus)
    }
    
    @IBAction func minusButton(_ sender: Any) {
        calculator.performNextOperation(newOperator: .minus)
    }
    
    @IBAction func timesButton(_ sender: Any) {
        calculator.performNextOperation(newOperator: .multiply)
    }
    
    @IBAction func divideButton(_ sender: Any) {
        calculator.performNextOperation(newOperator: .divide)
    }
    
    @IBAction func equalButton(_ sender: Any) {
        calculator.performNextOperation(newOperator: .equal)
    }
    
    
    @IBAction func positiveNegativePress(_ sender: Any) {
        if calculator.currentValue.hasPrefix("-") {
            calculator.currentValue.replace("-", with: "")
        } else {
            calculator.currentValue = "-\(calculator.currentValue)"
        }
        updateCalculatorView()
    }
    
    
    @IBAction func percentButtonPress(_ sender: Any) {
        if calculator.previousOperator != .equal {
            calculator.currentValue = String(calculator.cachedValue * ((Double(calculator.currentValue) ?? 0) / 100))
            updateCalculatorView()
        } else {
            calculator.currentValue = String((Double(calculatorValue.text ?? "0") ?? 0) / 100)
            updateCalculatorView()
        }

    }
    
    // The clear button should initially say "AC", say "Clear" while the user is performing calculations, say "AC" after being pressed, and then stay on "AC" and do nothing if pressed again.
    @IBAction func clearButtonPress(_ sender: Any) {
        //First press -- clears current value
        
        if !calculator.clearAllDisplayed {
            calculator.currentValue = "0"
            calculator.decimalPressed = false
            updateCalculatorView()
            setClearButton(showClearAll: true)
            
            //second press -- clears cached value and operators
        } else if calculator.clearAllDisplayed {
            calculator.cachedValue = 0
            calculator.previousOperator = .equal
        }
    }

    
    func setClearButton(showClearAll: Bool) {
        if showClearAll {
            calculator.clearAllDisplayed = true
            clearButtonOutlet.setTitle("AC", for: .normal)
        } else {
            calculator.clearAllDisplayed = false
            clearButtonOutlet.setTitle("Clear", for: .normal)
        }
    }
    
    
    // Called whenever the Calculator's label needs to be updated
    func updateCalculatorView(with customValue: String? = nil) {
        if let customValue {
            calculatorValue.text = customValue
        } else {
            calculatorValue.text = calculator.currentValue
        }
    }
    
}

