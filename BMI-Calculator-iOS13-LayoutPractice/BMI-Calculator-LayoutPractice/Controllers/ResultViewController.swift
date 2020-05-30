//
//  ResultViewController.swift
//  BMI-Calculator-LayoutPractice
//
//  Created by 高桑駿 on 2020/03/19.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    var advice: String?
    var bmi: String?
    var backgroundColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        bmiLabel.text = bmi
        commentLabel.text = advice
        backgroundImage.backgroundColor = backgroundColor
    }

    @IBAction func recalculateTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
