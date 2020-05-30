//
//  ViewController.swift
//  Calculator
//
//  Created by Angela Yu on 10/09/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    private var calculator = CalculatorLogic()
    
    private var isCalcMethodButtonTapped = false
    
    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                fatalError("cannot convert display label to number")
            }
            return number
        }
        set {
            if newValue == floor(newValue) {
                displayLabel.text = String(Int(newValue))
            } else {
                displayLabel.text = String(newValue)
            }
        }
    }
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        guard let calcMethod = sender.currentTitle else {
            fatalError("no text button")
        }
        if let result = calculator.calculate(number: displayValue, symbol: calcMethod) {
            displayValue = result
            isCalcMethodButtonTapped = false
        } else {
            isCalcMethodButtonTapped = true
        }
    }

    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        guard let numValue = sender.currentTitle else {
            preconditionFailure("no text button")
        }
        
        guard let text = displayLabel.text else {
            preconditionFailure("no displayLabel text")
        }
        
        if numValue  == "." {
            if text.contains(".") {
                return
            } else {
                displayLabel.text = text + numValue
            }
        } else if text == "0" || isCalcMethodButtonTapped {
            displayLabel.text = numValue
        } else {
            displayLabel.text = text + numValue
        }
    }

}

