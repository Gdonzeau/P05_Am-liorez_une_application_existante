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
        let operateur = Notification.Name(rawValue: "messageErrorOperator")
        NotificationCenter.default.addObserver(self, selector: #selector(errorMessageOperator), name: operateur, object: nil)
        let expression = Notification.Name(rawValue: "messageErrorExpression")
        NotificationCenter.default.addObserver(self, selector: #selector(errorMessageExpression), name: expression, object: nil)
        let enough = Notification.Name(rawValue: "messageErrorEnoughtElements")
        NotificationCenter.default.addObserver(self, selector: #selector(errorMessageEnoughElements), name: enough, object: nil)
        let textComplete = Notification.Name(rawValue: "messageTextCompleted")
        NotificationCenter.default.addObserver(self, selector: #selector(actionTextComplete), name: textComplete, object: nil)
    }
    // View actions
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        brain.addElements(sender: sender)
        if let texte = brain.textView.text {
            print(texte)
            textView.text = texte
        }
    }
    
    @IBAction func operatorsTapped(_ sender: UIButton) {
        brain.operation(sender:sender)
        if let texte = brain.textView.text {
            print(texte)
            print("Taille")
            
            textView.font = textView.font?.withSize(40)
            
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
    
    @objc func errorMessageOperator() {
        print("Huston ?")
        let alertVC = UIAlertController(title: "Zéro!", message: "Un opérateur est déja mis !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    @objc func errorMessageExpression() {
        print("Huston ?")
        let alertVC = UIAlertController(title: "Zéro!", message: "Entrez une expression correcte !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
    @objc func errorMessageEnoughElements() {
        print("Huston ?")
        let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
    @objc func actionTextComplete() {
        textView.text = brain.textView.text
    }
    
}

