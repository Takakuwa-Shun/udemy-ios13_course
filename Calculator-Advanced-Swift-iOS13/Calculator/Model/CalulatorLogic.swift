//
//  calulator.swift
//  Calculator
//
//  Created by 高桑駿 on 2020/04/25.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import Foundation

struct CalculatorLogic {
    
    private var intermediateCalculation: (n1: Double, calcMethod: String)?
    
    mutating func calculate(number: Double, symbol: String) -> Double? {
        switch symbol {
        case "+/-":
            return number * -1
        case "AC":
            return 0
        case "%":
            return number * 0.01
        case "=":
            return performTwoNumCalculation(n2: number)
        default:
            intermediateCalculation = (n1: number, calcMethod: symbol)
            return nil
        }
    }
    
    private mutating func performTwoNumCalculation(n2: Double) -> Double {
        guard let n1 = intermediateCalculation?.n1, let operation = intermediateCalculation?.calcMethod else {
            return n2
        }
        intermediateCalculation = nil
        
        switch operation {
        case "÷":
            return n1 / n2
        case "×":
            return n1 * n2
        case "-":
            return n1 - n2
        case "+":
            return n1 + n2
        default:
            preconditionFailure("undefinded method: \(operation)")
        }
    }
}
