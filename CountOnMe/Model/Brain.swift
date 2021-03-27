//
//  Model.swift
//  CountOnMe
//
//  Created by Guillaume Donzeau on 22/03/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

class ElectronicBrain { // So were named first calculators
    var textView = UITextView()
    var error = false // Just try to divide by 0...
    var operandProb = false
    
    var elements: [String] { //
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != ":"
    }
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != ":"// && textView.text != ""
    }
    var noOperatorToStart: Bool {
        return textView.text != ""
    }
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    func operation(sender:UIButton) { // taped an operator
        
        if expressionHaveResult {
            textView.text = ""
            return
        }
        
        if canAddOperator && noOperatorToStart {
            if let sign = sender.title(for: .normal) {
                textView.text.append(" \(sign) ")
            }
            notifChangeText()
        }
        /*
         else {
            if noOperatorToStart {
                print("pas possible")
                let name = Notification.Name(rawValue: "messageErrorOperator")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
            } else {
                let name = Notification.Name(rawValue: "messageErrorStartingOperator")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
            }
        }
 */
    }
    func addElements(sender:UIButton) { // Tapped number button
        if error || operandProb {
            textView.text = ""
            error = false
            operandProb = false
        }
        
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if expressionHaveResult {
            textView.text = ""
        }
        textView.text.append(numberText)
        notifChangeText()
    }
    
    func buttonEqualTapped() {
        guard expressionIsCorrect else { // chgmt
            /*
            let name = Notification.Name(rawValue: "messageErrorExpression")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            */
            return
        }
        
        guard expressionHaveEnoughElement else { // chgmt
            /*
            let name = Notification.Name(rawValue: "messageErrorEnoughtElements")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            */
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements // chgmt
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            guard let left = Int(operationsToReduce[0]) else {
                
                print("Mé non")
                /*
                let name = Notification.Name(rawValue: "messageError")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
                */
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
            default:
                operandProb = true
                result = 0 // Initializing to avoid error even if it won't be seen
                /*
                let name = Notification.Name(rawValue: "messageErrorExpression")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
                */
                textView.text = ""
                notifChangeText()
            //fatalError("Unknown operator !")
            }
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(result)", at: 0)
        }
        if error || operandProb {
            textView.text = "Error"
            notifChangeText()
        } else {
            // print("Réponse : \(result)")
            textView.text.append(" = \(operationsToReduce.first!)")
            notifChangeText()
        }
    }
    func notifChangeText() {
        let name = Notification.Name(rawValue: "messageTextCompleted")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
