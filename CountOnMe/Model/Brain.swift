//
//  Model.swift
//  CountOnMe
//
//  Created by Guillaume Donzeau on 22/03/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

class ElectronicBrain {
    var textView = UITextView()
    //var operationTxt = ""
    var error = false
    
    var elements: [String] { //
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    //var expressionCalcul = ""
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != ":"
    }
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != ":" && textView.text != ""
    }
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    func operation(sender:UIButton) { // taped an operator
        
        if expressionHaveResult {
            textView.text = ""
            return
        }
        if canAddOperator {
            if let sign = sender.title(for: .normal) {
                textView.text.append(" \(sign) ")
            }
        } else {
            print("pas possible")
            // Notification pas forcément nécessaire. Le bouton qui ne fonctionne pas peut être suffisant et 
            let name = Notification.Name(rawValue: "messageErrorOperator")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            // Notification d'alerte
            /*
             let alertVC = UIAlertController(title: "Zéro!", message: "Un opérateur est déja mis !", preferredStyle: .alert)
             alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
             self.present(alertVC, animated: true, completion: nil)
             */
        }
    }
    func addElements(sender:UIButton) { // Tapped number button
        if error {
            textView.text = ""
            error = false
        }
        
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if expressionHaveResult {
            textView.text = ""
        }
        textView.text.append(numberText)
    }
    
    func buttonEqualTapped() {
        guard expressionIsCorrect else { // chgmt
            let name = Notification.Name(rawValue: "messageError")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            return
        }
        
        guard expressionHaveEnoughElement else { // chgmt
            let name = Notification.Name(rawValue: "messageError")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements // chgmt
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            guard let left = Int(operationsToReduce[0]) else {
                let name = Notification.Name(rawValue: "messageError")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
                return
            }
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "x": result = left * right
            case ":":
                if right != 0 {
                    result = left / right
                } else {
                    print("Impossible de diviser par zéro")
                    error = true
                    result = 0
                }
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        if error {
            textView.text = "Error"
        } else {
           // print("Réponse : \(result)")
            textView.text.append(" = \(operationsToReduce.first!)")
        }
    }
}
