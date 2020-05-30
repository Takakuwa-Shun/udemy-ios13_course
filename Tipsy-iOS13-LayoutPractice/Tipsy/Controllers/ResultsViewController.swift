//
//  ResultsViewController.swift
//  Tipsy
//
//  Created by 高桑駿 on 2020/03/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    var amount: String?
    var people: Int?
    var pct: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = amount
        settingsLabel.text = "Split between \(people!) people, with \(pct!) tip."
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
