//
//  Model.swift
//  CountOnMe
//
//  Created by Guillaume Donzeau on 22/03/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class ElectronicBrain { // So were named first calculators
    var operationInCreation = "" {
        didSet {
            notifChangeText()
        }
    } // Changer le nom
    var error = false // Just try to divide by 0...
    var operandProb = false
    var resultIsInt = false
    var numberOfMultiplyOrDivide = 0
    //var resultat = false
    var elements: [String] {
        return operationInCreation.split(separator: " ").map { "\($0)" }
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
    var cantAddMinus: Bool { // You can add minus after operator +, x or :. Or at the beginning. Not after - to avoid a potential long queue. -- = +
        return elements.last != "+" && elements.last != "x" && elements.last != ":"
    }
    var cantAddMinusII: Bool { // You can add minus after operator +, x or :. Or at the beginning. Not after - to avoid a potential long queue. -- = +
        return operationInCreation != ""
    }
    var noOperatorToStart: Bool {
        return operationInCreation != ""
    }
    var rightElementIsNotZero : Bool {
        return true //elements[2] != "0"
    }
    var expressionHasResult: Bool {
        return operationInCreation.firstIndex(of: "=") != nil
    }
    func operation(signOperator:String?) { // taped an operator // Pas "sender mais operator
        
        if expressionHasResult {
            operationInCreation = ""
            return
        }
        if signOperator == "-" && (cantAddMinus == false || cantAddMinusII == false) {
            if let sign = signOperator {
            operationInCreation.append(" \(sign)") //Not space at the end, to be added to the number
            return
            }
        }
        if canAddOperator && noOperatorToStart {
            if let sign = signOperator {
                operationInCreation.append(" \(sign) ")
            }
            //notifChangeText()
        }
    }
    func addElements(sender:String?) { // Tapped number button
        if error || operandProb {
            operationInCreation = ""
            error = false
            operandProb = false
        }
        if expressionHasResult {
            operationInCreation = ""
            resultIsInt = false
        }
        /*
        if operationInCreation == "0" {
            operationInCreation = ""
        }
        */
        if let numberText = sender {
            operationInCreation.append(numberText)
        }
        //notifChangeText()
    }
    func AC() {
        operationInCreation = ""
    }
    func buttonEqualTapped() {
        guard expressionIsCorrect else { // chgmt
            return
        }
        guard expressionHasEnoughElement else { // chgmt
            return
        }
        guard rightElementIsNotZero else {
            return
        }
        // Create local copy of operations
        var operationsToReduce = elements // chgmt
        // Let's start with x and :
        //var counter = 0
        var left = 1.00
        var right = 1.00
        var operand = ""
        var noMultiplyOrDivide = false
        while noMultiplyOrDivide != true {
            print("On recommence")
            for index in 0 ..< operationsToReduce.count-1 {
              print(index)
                if operationsToReduce[index] == "x" || operationsToReduce[index] == ":" {
                    print("Signe trouvé")
                    if let firstElement = Double(operationsToReduce[index-1]) {
                        left = firstElement
                    }
                    operand = operationsToReduce[index]
                    if let secondElement = Double(operationsToReduce[index+1]) {
                        right = secondElement
                    }
                    let resultDouble = calculating(right: right, operand: operand, left: left)
                    print("Résultat : \(resultDouble)")
                    for _ in 0..<3 {
                        print("suppr : \(operationsToReduce[index-1])")
                    operationsToReduce.remove(at: index-1)
                    }
                    print("insertion : \(resultDouble) at \(index - 1)")
                    operationsToReduce.insert(String(resultDouble), at: index-1)
                    break
                }
            }
            for index in 0 ..< operationsToReduce.count {
                if operationsToReduce[index] == "x" || operationsToReduce[index] == ":" {
                    print("encore un...")
                    noMultiplyOrDivide = false
                    break
                } else {
                    print("Terminé")
                    noMultiplyOrDivide = true
                }
                
            }
        }
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            let resultDouble: Double
            let resultInt:Int
            
            resultDouble = calculating(right: right, operand: operand, left: left)
            if resultIsInt {
                resultInt = Int(resultDouble)
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(resultInt)", at: 0)
            } else {
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(resultDouble)", at: 0)
            }
        }
        if error || operandProb {
            operationInCreation = "Error"
            //notifChangeText()
        } else {
            // print("Réponse : \(result)")
            operationInCreation.append(" = \(operationsToReduce.first!)")
            //notifChangeText()
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
        if result/Double(Int(result)) == 1 || result == 0 {
            print("Le résultat \(Int(result)) est un entier")
            resultIsInt = true
            //resultat = false
            
        }
        return result
    }
    private func notifChangeText() {
        let name = Notification.Name(rawValue: "messageTextCompleted")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
