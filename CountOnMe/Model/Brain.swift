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
    var operatorIsDivide : Bool {
        return elements.last == ":"
    }
    /*
     var elementIsZero : Bool {
     return elements.last == "0"
     }
     */
    var expressionHasResult: Bool {
        return operationInCreation.firstIndex(of: "=") != nil
    }
    // Test closures
    /*
     var var01 = 2
     var var02 = 3
     
     func test () -> Int { () -> Int in let var03 = self.var01 + self.var02
     return var03
     }
     */
    func operation(signOperator:String?) { // taped an operator 
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
    func buttonEqualTapped_SecondVersion() {
        guard expressionIsCorrect else { // chgmt
            return
        }
        guard expressionHasEnoughElement else { // chgmt
            return
        }
        // Create local copy of operations
        var operationsToReduce = elements // chgmt
        var left = 1.00
        var right = 1.00
        var operand = ""
        var noMultiplyOrDivide = false
        
        while noMultiplyOrDivide != true {
            var operandIndex = 1
            if let indexTest = operationsToReduce.firstIndex { element -> Bool in // On trouve x ou : dans elements //First index cherche dans le tableau // Retourne le premier index où la condition est vraie.
                return element == "x" || element == ":"
            } {
                print("Il y a des signes prioritaires")
                // On trouve des symboles "multiplier" ou "diviser"
                operandIndex = indexTest //
                if let firstElement = Double(operationsToReduce[operandIndex-1]) {
                    left = firstElement
                }
                operand = operationsToReduce[operandIndex]
                if let secondElement = Double(operationsToReduce[operandIndex+1]) {
                    right = secondElement
                }
                let resultDouble = calculating(right: right, operand: operand, left: left)
                print("Résultat : \(resultDouble)")
                for _ in 0..<3 {
                    print("suppr : \(operationsToReduce[operandIndex - 1])")
                    operationsToReduce.remove(at: operandIndex-1)
                }
                print("insertion : \(resultDouble) at \(operandIndex - 1)")
                operationsToReduce.insert(String(resultDouble), at: operandIndex-1)
                break
                
            }
            
            else {
                print("il n'y en a plus")
                noMultiplyOrDivide = true
            }
        }
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
        // Let's start with x and :
        var left = 1.00
        var right = 1.00
        var operand = ""
        var noMultiplyOrDivide = false
        
        while noMultiplyOrDivide != true { // All operations x and : first
            print("On recommence")
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
                        print("suppr : \(operationsToReduce[index - 1])")
                        operationsToReduce.remove(at: index-1)
                    }
                    print("insertion : \(resultDouble) at \(index - 1)")
                    operationsToReduce.insert(String(resultDouble), at: index-1)
                    break
                }
            }
        }
        if operationsToReduce.count == 1 {
            var number = 0.0
            var numberInt = 0
            if let extract = Double(operationsToReduce[0]) {
                number = extract
                if number/Double(Int(number)) == 1 || number == 0 {
                    numberInt = Int(number)
                    operationsToReduce[0] = String(numberInt)
                }
            }
        }
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            
            var operandIndex = 1
            if let indexTest = operationsToReduce.firstIndex { element -> Bool in // On trouve x dans elements //First index cherche dans le tableau // Retourne le premier index où la condition est vraie.
                return element == "x" || element == ":"
            } {
                operandIndex = indexTest //
            }
            let left = Double(operationsToReduce[0])! // Guard let et pas !
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            let resultDouble: Double
            let resultInt:Int
            
            resultDouble = calculating(right: right, operand: operand, left: left)
            if resultIsInt {
                resultInt = Int(resultDouble)
                operationsToReduce = Array(operationsToReduce.dropFirst(3)) // On remplace avec le principe du remove en ayant l'index.
                operationsToReduce.insert("\(resultInt)", at: 0)
                print ("résultat entier : \(resultInt)")
            } else {
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(resultDouble)", at: 0)
                print ("résultat double : \(resultDouble)")
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
    /*
     func doubleOrInt () {
     
     }
     */
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
