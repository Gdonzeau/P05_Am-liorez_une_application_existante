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
        let textComplete = Notification.Name(rawValue: "messageTextCompleted")
        NotificationCenter.default.addObserver(self, selector: #selector(actionTextComplete), name: textComplete, object: nil)
    }
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        let message = sender.title(for: .normal)
        brain.addElements(sender: message)
    }
    @IBAction func operatorsTapped(_ sender: UIButton) {
        let message = sender.title(for: .normal)
        brain.operation(sender:message)
    }
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        brain.buttonEqualTapped()
    }
    @objc func actionTextComplete() {
        textView.text = brain.textView
    }
}

