//
//  CalculatorBrain.swift
//  BMI-Calculator-LayoutPractice
//
//  Created by 高桑駿 on 2020/03/19.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    
    func getBMIValue() -> String {
        return String.init(format: "%.2f", bmi?.value ?? 0)
    }
    
    func getAdvice() -> String {
        return bmi?.advice ?? ""
    }
    
    func getColor() -> UIColor {
        return bmi?.color ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    mutating func calculateBMI(height: Float, weight: Float) -> Void {
        let bmiValue = weight / (height * height)
        if bmiValue < 18.5 {
            self.bmi = BMI(value: bmiValue, advice: "Eat more pies!", color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        } else if bmiValue < 24.9 {
            self.bmi = BMI(value: bmiValue, advice: "Eat more pies!", color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        } else {
            self.bmi = BMI(value: bmiValue, advice: "Eat less pies!", color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        }
    }
}

