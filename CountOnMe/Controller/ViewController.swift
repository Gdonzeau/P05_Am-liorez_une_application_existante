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
    let brain = ElectronicBrain()
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let textComplete = Notification.Name(rawValue: "messageTextCompleted")
        NotificationCenter.default.addObserver(self, selector: #selector(actionTextComplete), name: textComplete, object: nil)
    }
    // View actions
    @IBAction func AC(_ sender: UIButton) {
        brain.AC()
    }
    @IBAction func tappedNumberButton(_ digit: UIButton) {
        let message = digit.title(for: .normal)
        brain.addElements(digit: message)
    }
    @IBAction func operatorsTapped(_ signOperator: UIButton) {
        let message = signOperator.title(for: .normal)
        brain.operation(signOperator:message)
    }
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        //brain.buttonEqualTapped_SecondVersion()
        brain.resolvingOperation()
        
    }
    @objc func actionTextComplete() {
        textView.text = brain.operationInCreation
    }
}

