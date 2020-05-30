//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    var split: Int = 2
    var pct: String = "10%"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tipChanged(_ sender: UIButton) {
        billTextField.endEditing(true)
        sender.isSelected = true
        switch sender {
            case zeroPctButton:
                tenPctButton.isSelected = false
                twentyPctButton.isSelected = false
            case tenPctButton:
                zeroPctButton.isSelected = false
                twentyPctButton.isSelected = false
            case twentyPctButton:
                zeroPctButton.isSelected = false
                tenPctButton.isSelected = false
            default:
                fatalError("不明なpctボタン: \(sender)")
        }
        pct = sender.currentTitle!
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        billTextField.endEditing(true)
        split = Int(sender.value)
        splitNumberLabel.text = split.description
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        let totalBill = Float(billTextField.text!) ?? 0.0
        let percentVal = Float(pct.dropLast().description)! / 100.0
        let amount = totalBill * (1 + percentVal) / Float(split)
        
        let resultVC = storyboard?.instantiateViewController(identifier: "ResultsViewController") as! ResultsViewController
        resultVC.people = split
        resultVC.pct = pct
        resultVC.amount = String.init(format: "%.2f", amount)
        self.present(resultVC, animated: true, completion: nil)
    }
}

