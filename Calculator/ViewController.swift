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
    var currentOperator: mathOperators = .none
    
    
    enum mathOperators {
        case plus, minus, multiply, divide, none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    fileprivate func cacheValue() {
        switch currentOperator {
        case .none:
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
        
        currentValue = "0"
        calculatorValue.text = String(cachedValue)
        clearButtonPressIncrement = 0
        clearButtonOutlet.titleLabel!.text = "Clear"

    }
    
    fileprivate func updateCalculatorView() {
        calculatorValue.text = currentValue
    }
    
    fileprivate func addDigitToCalculator(_ digit: String) {
        if currentValue == "0" {
            currentValue = digit
        } else {
            currentValue += digit}
        updateCalculatorView()
        
    }
    
    @IBAction func numButton(_ sender: UIButton) {
        
        guard let digit = sender.titleLabel?.text else {
            return
        }
        addDigitToCalculator(digit)
        
    }
    
    @IBAction func decimalButton(_ sender: Any) {
        if decimalPressed == false {
            currentValue += "."
        }
        
        decimalPressed = true
    }
    
    fileprivate func operatorPress(_ inputOperator: mathOperators) {
        if inputOperator == .none {
            let tempStoreCurrentValue = currentValue
            cacheValue()
            currentValue = tempStoreCurrentValue
            return
        }
        cacheValue()
        currentOperator = inputOperator
    }
    
    @IBAction func plusButton(_ sender: Any) {
        operatorPress(.plus)
    }
    
    @IBAction func minusButton(_ sender: Any) {
        operatorPress(.minus)
    }
    
    @IBAction func timesButton(_ sender: Any) {
        operatorPress(.multiply)
    }
    
    @IBAction func divideButton(_ sender: Any) {
        operatorPress(.divide)
    }
    
    @IBAction func equalButton(_ sender: Any) {
        operatorPress(.none)
    }
    
    var clearButtonPressIncrement: Int = 0
    
    @IBAction func clearButtonPress(_ sender: Any) {
        if clearButtonPressIncrement == 0 && cachedValue != 0 {
            currentValue = "0"
            decimalPressed = false
            updateCalculatorView()
            clearButtonOutlet.setTitle("Clear All", for: .normal)
            clearButtonPressIncrement += 1
        } else if clearButtonPressIncrement == 1 && cachedValue != 0 {
            cachedValue = 0
            clearButtonPressIncrement = 0
            clearButtonOutlet.setTitle("Clear", for: .normal)
        }
    }
    
}

