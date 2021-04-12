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
    
    var expressionHasEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var lastIsNotAnOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != ":"
    }
    
    var cantAddMinus: Bool { // You can add minus after operator +, x or :. Or at the beginning. Not after - to avoid a potential long queue. -- = +
        return elements.last != "+" && elements.last != "x" && elements.last != ":"
    }
    
    var operationIsNotEmpty: Bool {
        return operationInCreation != ""
    }
    
    var operatorIsDivide : Bool {
        return elements.last == ":"
    }
    
    var expressionHasResult: Bool {
        return operationInCreation.firstIndex(of: "=") != nil
    }
    
    var expressionIsDividedByZero: Bool {
        print("OPE: \(operationInCreation)")
        return operationInCreation.contains(": 0") || operationInCreation.contains(": -0") // Espace ou non ?
    }
    
    func operation(signOperator:String?) { // taped an operator 
        if expressionHasResult {
            operationInCreation = ""
            return
        }
        if signOperator == "-" && (cantAddMinus == false || operationIsNotEmpty == false) {
            if let sign = signOperator {
                operationInCreation.append("\(sign)") //Not space at the end, to be added to the number
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
    func resolvingOperation() {
        
        guard lastIsNotAnOperator else { // chgmt
            return
        }
        guard expressionHasEnoughElement else { // chgmt
            return
        }
        if expressionIsDividedByZero {
            print("division par 0")
            operationInCreation = "Error"
            return
        }
        // Create local copy of operations
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            operationsToReduce = reducingOperation(operationsToReduce: operationsToReduce)
        }
        resultIsDoubleOrInt(operationToReduce: operationsToReduce)
    }
    private func reducingOperation(operationsToReduce:[String]) -> [String] {
        var operationToReduce = operationsToReduce
        var operandIndex = 1
        if let index = operationsToReduce.firstIndex(where: { element -> Bool in
            return element == "x" || element == ":"
        }) {
            operandIndex = index
        }// else { // Potentiellement = 1 ou par défaut = 1.
        guard let left = Double(operationsToReduce[operandIndex - 1]), let right = Double(operationsToReduce[operandIndex + 1]) else {
            return operationToReduce
        }
        let operand = operationsToReduce[operandIndex]
        var result:Double
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        case "x": result = left * right
        case ":": result = left / right
        default:
            result = 0.0
            break
        }
        for _ in 0..<3 {
            print("suppr : \(operationToReduce[operandIndex - 1])")
            operationToReduce.remove(at: operandIndex - 1)
        }
        print("insertion : \(result) at \(operandIndex - 1)")
        operationToReduce.insert(String(result), at: operandIndex - 1)
        return operationToReduce
    }
    private func resultIsDoubleOrInt(operationToReduce:[String]) {
        var operationsToReduce = operationToReduce
        print("Int ou Double ?")
        var number = 0.0
        var numberInt = 0
        if let extract = Double(operationsToReduce[0]) {
            number = extract
            if number/Double(Int(number)) == 1 || number == 0 {
                numberInt = Int(number)
                operationsToReduce[0] = String(numberInt)
                operationInCreation.append(" = \(String(numberInt))")
            } else {
                operationInCreation.append(" = \(String(number))")
            }
        }
    }
    private func notifChangeText() {
        let name = Notification.Name(rawValue: "messageTextCompleted")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
