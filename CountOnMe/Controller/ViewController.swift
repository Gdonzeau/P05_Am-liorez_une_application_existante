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
        /*
        let operateur = Notification.Name(rawValue: "messageErrorOperator")
        NotificationCenter.default.addObserver(self, selector: #selector(errorMessageOperator), name: operateur, object: nil)
        let expression = Notification.Name(rawValue: "messageErrorExpression")
        NotificationCenter.default.addObserver(self, selector: #selector(errorMessageExpression), name: expression, object: nil)
        let enough = Notification.Name(rawValue: "messageErrorEnoughtElements")
        NotificationCenter.default.addObserver(self, selector: #selector(errorMessageEnoughElements), name: enough, object: nil)
        */
        let textComplete = Notification.Name(rawValue: "messageTextCompleted")
        NotificationCenter.default.addObserver(self, selector: #selector(actionTextComplete), name: textComplete, object: nil)
        /*
        let operatorStarting = Notification.Name(rawValue: "messageErrorStartingOperator")
        NotificationCenter.default.addObserver(self, selector: #selector(errorMessageOperatorStarting), name: operatorStarting, object: nil)
 */
    }
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        brain.addElements(sender: sender)
    }
    @IBAction func operatorsTapped(_ sender: UIButton) {
        brain.operation(sender:sender)
    }
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        brain.buttonEqualTapped()
    }
    /*
    @objc func errorMessageOperator() {
        erreur(message: "Un opérateur est déja mis !")
    }
    @objc func errorMessageExpression() {
        erreur(message: "Entrez une expression correcte !")
    }
    @objc func errorMessageEnoughElements() {
        erreur(message: "Démarrez un nouveau calcul !")
    }
    @objc func errorMessageOperatorStarting() {
        erreur(message: "Pas d'opérateur au départ")
    }
    */
    @objc func actionTextComplete() {
        textView.text = brain.textView.text
    }
    /*
    func erreur(message:String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    */
}

