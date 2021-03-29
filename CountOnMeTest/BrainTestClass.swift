//
//  BrainTestClass.swift
//  CountOnMeTest
//
//  Created by Guillaume Donzeau on 27/03/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class BrainTestClass: XCTestCase {
    var brain = ElectronicBrain()
    
    override func setUp() {
        super.setUp()
    }
    func testGivenInstanceOfElectronicBrain_WhenAccessingIt_ThenItExists() { // To delete ?
        XCTAssertNotNil(brain)
    }
    func testGivenElementsIsEmpty_WhenTappedNumbers_ThenElementsCountIsOne() { // To delete too, as if the next func is true, that means that count == 1
        brain.addElements(sender: "1")
        XCTAssert(brain.elements.count == 1)
    }
    func testGivenElementsIsEmpty_WhenTappedNumbers_ThenFirstElementsIsNumberTapped() {
        brain.addElements(sender: "1")
        XCTAssert(brain.elements[0] == "1")
    }
    func testGivenElementsFirstIs1_WhenTappedNumbers_ThenFirstElementsIs1AndNumberTapped() {
        brain.addElements(sender: "1")
        brain.addElements(sender: "2")
        XCTAssert(brain.elements[0] == "12")
    }
    func testGivenElementsIsEmpty_WhenTappedOperator_ThenFirstElementsIsNil() {
        brain.operation(sender: "+")
        XCTAssert(brain.elements.count == 0)
    }
    func testGivenErrorIsTrue_WhenTappedNumbers_ThenFirstElementsIsEmpty() {
        brain.error = true
        brain.addElements(sender: "1")
        XCTAssert(brain.error == false)
    }
    func testGivenAllElementsExist_WhenEqualIsTaped_ThenResultIsGivenForAllOperators() {
        brain.addElements(sender: "1")
        brain.addElements(sender: "2")
        brain.operation(sender: "+")
        brain.addElements(sender: "6")
        brain.buttonEqualTapped()
        var left = Double()
        var right = Double()
        var operand = String()
        if let leftPart = Double(brain.elements[0]) {
            left = leftPart
        }
        if let rightPart = Double(brain.elements[2]) {
            right = rightPart
        }
        let operandSign = brain.elements[1]
        operand = operandSign
        var result = brain.calculating(right: right, operand: operand, left: left)
        XCTAssert(result == 18)
        
        operand = "-"
        result = brain.calculating(right: right, operand: operand, left: left)
        XCTAssert(result == 6)
        
        operand = ":"
        result = brain.calculating(right: right, operand: operand, left: left)
        XCTAssert(result == 2)
        
        operand = "x"
        result = brain.calculating(right: right, operand: operand, left: left)
        XCTAssert(result == 72)
    }
    func testGivenNotAllElementsExist_WhenEqualIsTaped_ThenExpressionDoesntHaveEnoughtElements() {
        brain.addElements(sender: "1")
        brain.addElements(sender: "2")
        brain.operation(sender: "+")
        brain.buttonEqualTapped()
        XCTAssert(brain.expressionHasEnoughElement == false)
    }
    func testGivenNotAllElementsExist_WhenEqualIsTaped_ThenExpresionIsNotCorrect() {
        brain.addElements(sender: "1")
        brain.addElements(sender: "2")
        brain.operation(sender: "+")
        brain.buttonEqualTapped()
        XCTAssert(brain.expressionIsCorrect == false)
    }
    func testGivenElementsExist_WhenDividingBy0_ThenErrorIsReturned() {
        brain.addElements(sender: "1")
        brain.addElements(sender: "2")
        brain.operation(sender: ":")
        brain.addElements(sender: "0")
        brain.buttonEqualTapped()
        XCTAssert(brain.error == true)
        XCTAssert(brain.textView == "Error")
    }
    func testGivenOperationIsFinished_WhenNumberIsTaped_ThenTextIsEmptyAndAddNumber() {
        brain.addElements(sender: "1")
        brain.addElements(sender: "2")
        brain.operation(sender: "+")
        brain.addElements(sender: "6")
        brain.buttonEqualTapped()
        brain.addElements(sender: "1")
        XCTAssert(brain.elements[0] == "1")
    }
    func testGivenOperationIsFinished_WhenOperatorIsTaped_ThenTextIsEmpty() {
        brain.addElements(sender: "1")
        brain.addElements(sender: "2")
        brain.operation(sender: "+")
        brain.addElements(sender: "6")
        brain.buttonEqualTapped()
        brain.operation(sender: "+")
        XCTAssert(brain.textView == "")
    }
    func testGivenOneElement_WhenEqualIsTaped_ThenNotEnoughElements() {
        brain.addElements(sender: "1")
        brain.addElements(sender: "2")
        //brain.operation(sender: "+")
        brain.buttonEqualTapped()
        XCTAssert(brain.expressionHasEnoughElement == false)
    }
}
