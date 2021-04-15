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
        didSet { // Each time the operation is changed, we send notification
            notifChangeText()
        }
    }
    var error = false // Just try to divide by 0...
    var resultIsInt = false

    var elements: [String] { // each space means that there is a new element
        return operationInCreation.split(separator: " ").map { "\($0)" }
    }

    var expressionHasEnoughElement: Bool { // Are there minimum 3 elements ?
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
        return operationInCreation.contains(": 0") || operationInCreation.contains(": -0")
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
        if operatorIsDivide { // To not divide by O avoiding Error
            if let check = digit {
                if check == "0" {
                    divideBy0 = true
                }
            }
        }
        if error { // || operandProb {
            operationInCreation = ""
            error = false
            return
            //operandProb = false
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
            error = true
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
        var operandIndex = 1 // Default operator's index is 1
        if let index = operationsToReduce.firstIndex(where: { element -> Bool in
            return element == "x" || element == ":" // But prioritary operators can be founded at other indexes
        }) {
            operandIndex = index
        }
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
        for _ in 0..<3 { // Let's delete these three elements
            operationToReduce.remove(at: operandIndex - 1)
        }
        operationToReduce.insert(String(result), at: operandIndex - 1) // and let's replace them by the result
        return operationToReduce
    }
    private func resultIsDoubleOrInt(operationToReduce:[String]) {
        // Let's verify if there are numbers after the point by dividing the Double by its own value Int
        var operationsToReduce = operationToReduce
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
    private func notifChangeText() { // Each time the text is changed, let's send a notification to refresh the text
        let name = Notification.Name(rawValue: "messageTextCompleted")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
