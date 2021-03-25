//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var Operators: [UIButton]! // [+,-,x,:,=]
    
    let brain = ElectronicBrain()
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // View actions
    @IBAction func operatorsTapped(_ sender: UIButton) {
        brain.operation(sender:sender)
        if let texte = brain.textView.text {
        print(texte)
        textView.text = texte
        }
    }
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        brain.addElements(sender: sender)
        if let texte = brain.textView.text {
        print(texte)
        textView.text = texte
        }
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        brain.buttonEqualTapped()
        if let texte = brain.textView.text {
        print(texte)
        textView.text = texte
        }
    }
    
}

