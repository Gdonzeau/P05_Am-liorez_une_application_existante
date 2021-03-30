//
//  Model.swift
//  CountOnMe
//
//  Created by Guillaume Donzeau on 22/03/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class ElectronicBrain { // So were named first calculators
    var textView = ""
    var error = false // Just try to divide by 0...
    var operandProb = false
    var elements: [String] { //
        
        return textView.split(separator: " ").map { "\($0)" }
    }
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != ":"
    }
    var expressionHasEnoughElement: Bool {
        return elements.count >= 3
    }
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != ":"
    }
    var noOperatorToStart: Bool {
        return textView != ""
    }
    var expressionHasResult: Bool {
        return textView.firstIndex(of: "=") != nil
    }
    func operation(sender:String?) { // taped an operator
        
        if expressionHasResult {
            textView = ""
            return
        }
        if canAddOperator && noOperatorToStart {
            if let sign = sender {
                textView.append(" \(sign) ")
            }
            notifChangeText()
        }
    }
    func addElements(sender:String?) { // Tapped number button
        if error || operandProb {
            textView = ""
            error = false
            operandProb = false
        }
        if expressionHasResult {
            textView = ""
        }
        if let numberText = sender {
            textView.append(numberText)
        }
        notifChangeText()
    }
    func buttonEqualTapped() {
        guard expressionIsCorrect else { // chgmt
            return
        }
        guard expressionHasEnoughElement else { // chgmt
            return
        }
        // Create local copy of operations
        var operationsToReduce = elements // chgmt
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            let result: Double
            
            result = calculating(right: right, operand: operand, left: left)
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(result)", at: 0)
        }
        if error || operandProb {
            textView = "Error"
            notifChangeText()
        } else {
            // print("Réponse : \(result)")
            textView.append(" = \(operationsToReduce.first!)")
            notifChangeText()
        }
    }
    func calculating (right:Double, operand:String, left:Double)->Double {
        var result = Double()
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "x": result = left * right
        default: // If not +, - or x so only : can be taped
            if right != 0 {
                result = left / right
            } else {
                print("Impossible de diviser par zéro")
                error = true
                result = 0
            }
        }
        return result
    }
    private func notifChangeText() {
        let name = Notification.Name(rawValue: "messageTextCompleted")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
