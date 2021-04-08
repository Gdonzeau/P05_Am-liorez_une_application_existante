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
    var elements: [String] {
        return operationInCreation.split(separator: " ").map { "\($0)" }
    }
    /*
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != ":"
    }
    */
    var expressionHasEnoughElement: Bool {
        return elements.count >= 3
    }
    /*
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != ":"
    }
    */
    var lastIsNotAnOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != ":"
    }
    var cantAddMinus: Bool { // You can add minus after operator +, x or :. Or at the beginning. Not after - to avoid a potential long queue. -- = +
        return elements.last != "+" && elements.last != "x" && elements.last != ":"
    }
    /*
    var cantAddMinusII: Bool {
        return operationInCreation != ""
    }
    */
    var operationIsNotEmpty: Bool {
        return operationInCreation != ""
    }
    /*
    var noOperatorToStart: Bool {
        return operationInCreation != ""
    }
    */
    var operatorIsDivide : Bool {
        return elements.last == ":"
    }
    var expressionHasResult: Bool {
        return operationInCreation.firstIndex(of: "=") != nil
    }
    func operation(signOperator:String?) { // taped an operator 
        if expressionHasResult {
            operationInCreation = ""
            return
        }
        if signOperator == "-" && (cantAddMinus == false || operationIsNotEmpty == false) {
            if let sign = signOperator {
                operationInCreation.append(" \(sign)") //Not space at the end, to be added to the number
                return
            }
        }
        if lastIsNotAnOperator && operationIsNotEmpty {
            if let sign = signOperator {
                operationInCreation.append(" \(sign) ")
            }
        }
    }
    func addElements(digit:String?) { // Tapped number button
        var divideBy0 = false
        if operatorIsDivide {
            print("Nous avons un divisé")
            if let check = digit {
                if check == "0" {
                    print(operatorIsDivide)
                    print("don't divide by 0")
                    divideBy0 = true
                }
            }
        }
        if error || operandProb {
            operationInCreation = ""
            error = false
            operandProb = false
        }
        if expressionHasResult {
            operationInCreation = ""
            resultIsInt = false
        }
        if let numberText = digit {
            var textWritten = ""
            if divideBy0 {
                textWritten = ""
            } else {
                textWritten = numberText
            }
            operationInCreation.append(textWritten)
        }
    }
    func AC() {
        operationInCreation = ""
    }
    func buttonEqualTapped() {
        guard lastIsNotAnOperator else { // chgmt
            return
        }
        guard expressionHasEnoughElement else { // chgmt
            return
        }
        // Create local copy of operations
        var operationsToReduce = elements // chgmt
        while operationsToReduce.count > 1 {
            // On trouve x ou : dans elements //First index cherche dans le tableau
            // Retourne le premier index où la condition est vraie.
            if let indexTest = operationsToReduce.firstIndex(where: { element -> Bool in
                return element == "x" || element == ":"
            }) {
                print("Il y a des signes prioritaires")
              //  onCalcule(indexTest: indexTest,operationsToReduce: operationsToReduce)
                // On trouve des symboles "multiplier" ou "diviser"
                let operation = onCalcule(indexTest: indexTest,operationsToReduce: operationsToReduce)
                for _ in 0..<3 {
                    print("suppr : \(operationsToReduce[indexTest - 1])")
                    operationsToReduce.remove(at: indexTest-1)
                }
                print("insertion : \(operation) at \(indexTest - 1)")
                operationsToReduce.insert(String(operation), at: indexTest-1)
            }
            print("fini")
            if let indexTest = operationsToReduce.firstIndex(where: { element -> Bool in
                return element == "+" || element == "-"
            }) {
                print("Il y a des signes non prioritaires")
               // onCalcule(indexTest: indexTest,operationsToReduce: operationsToReduce)
                // On trouve des symboles "plus" ou "moins"
                let operation = onCalcule(indexTest: indexTest,operationsToReduce: operationsToReduce)
                for _ in 0..<3 {
                    print("suppr : \(operationsToReduce[indexTest - 1])")
                    operationsToReduce.remove(at: indexTest-1)
                }
                print("insertion : \(operation) at \(indexTest - 1)")
                operationsToReduce.insert(String(operation), at: indexTest-1)
            }
        }
       // Int or Double ?
            var number = 0.0
            var numberInt = 0
            if let extract = Double(operationsToReduce[0]) {
                number = extract
                if number/Double(Int(number)) == 1 || number == 0 {
                    numberInt = Int(number)
                    operationsToReduce[0] = String(numberInt)
                }
            }
        if error || operandProb {
            operationInCreation = "Error"
        } else {
            operationInCreation.append(" = \(operationsToReduce.first!)")
        }
    }
    private func onCalcule(indexTest:Int, operationsToReduce:[String])-> Double {
        let operandIndex = indexTest //
        let opeToReduce = operationsToReduce
        var left = 0.0
        var right = 0.0
        
        if let firstElement = Double(opeToReduce[operandIndex-1]) {
            left = firstElement
        }
        let operand = opeToReduce[operandIndex]
        if let secondElement = Double(opeToReduce[operandIndex+1]) {
            right = secondElement
        }
        let resultDouble = calculating(right: right, operand: operand, left: left)
        return resultDouble
    }
    func calculating (right:Double, operand:String, left:Double)->Double {
        var result = Double()
        resultIsInt = false
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
        }
        return result
    }
    private func notifChangeText() {
        let name = Notification.Name(rawValue: "messageTextCompleted")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
