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
    func testGivenElementsIsEmpty_WhenTappedNumbers_ThenElementsCountIsOne() { // To delete too, as if the next func is true, that means that count == 1 ?
        XCTAssertNotEqual(brain.elements.count,1)
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.elements.count,1)
    }
    func testGivenElementsIsEmpty_WhenTappedNumbers_ThenFirstElementsIsNumberTapped() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.elements[0],"1")
    }
    func testGivenElementsIsNOtEmpty_WhenTappedAC_ThenElementsIsEmpty() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.operationInCreation,"1")
        XCTAssertNotEqual(brain.elements.count,0)
        brain.AC()
        XCTAssertEqual(brain.elements.count,0)
        XCTAssertEqual(brain.operationInCreation,"")
    }
    func testGivenElementsFirstIs1_WhenTappedNumbers_ThenFirstElementsIs1AndNumberTapped() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        XCTAssertEqual(brain.elements[0],"12")
    }
    func testGivenNegativeElementInFirstPlace_WhenTappedNumbers_ThenFirstElementsIs1AndNumberTapped() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "-")
        brain.addElements(digit: "2")
        XCTAssertEqual(brain.elements[0],"-2")
    }
    
    func testGivenFirstPlaceIsEmpty_WhenMultiplyingByNegtiveNumber_ThenItIsAccepted() {
        XCTAssertEqual(brain.cantAddMinusII,false)
        brain.operation(signOperator: "-")
        XCTAssertEqual(brain.cantAddMinusII,true)
        brain.addElements(digit: "2")
        brain.operation(signOperator: "x")
        XCTAssertEqual(brain.cantAddMinus,false)
        brain.operation(signOperator: "-")
        XCTAssertEqual(brain.cantAddMinus,true)
        brain.addElements(digit: "4")
        XCTAssertEqual(brain.cantAddMinus,true)
        brain.buttonEqualTapped()
        XCTAssertEqual(brain.operationInCreation," -2 x  -4 = 8")
        
    }
    
    func testGivenElementsIsEmpty_WhenTappedOperator_ThenFirstElementsIsNil() {
        XCTAssertEqual(brain.elements.count,0)
        brain.operation(signOperator: "+")
        XCTAssertEqual(brain.elements.count,0)
    }
    func testGivenErrorIsTrue_WhenTappedNumbers_ThenFirstElementsIsEmpty() {
        brain.error = true
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.error,false)
    }
    func testGivenAllElementsExistAndAreIntOrDouble_WhenEqualIsTaped_ThenResultIsGivenForAllOperators() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "-")
        brain.addElements(digit: "9")
        brain.operation(signOperator: "+")
        brain.addElements(digit: "6")
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
        XCTAssertEqual(result,-3)
        
        operand = "-"
        result = brain.calculating(right: right, operand: operand, left: left)
        XCTAssertEqual(result,-15)
        
        operand = ":"
        result = brain.calculating(right: right, operand: operand, left: left)
        XCTAssertEqual(result,-1.5)
        
        operand = "x"
        result = brain.calculating(right: right, operand: operand, left: left)
        XCTAssertEqual(result,-54)
        /*
        left = -6.5
        //operand = "-"
        result = brain.calculating(right: right, operand: operand, left: left)
        XCTAssertEqual(result,-39)
        */
    }
    
    func testGivenfirstElement_WhenDividingBy0_ThenDivideBy0IsTrue() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: ":")
        XCTAssertEqual(brain.operatorIsDivide,true)
        brain.addElements(digit: "0")
    }
    func testGivenNotAllElementsExist_WhenEqualIsTaped_ThenExpressionDoesntHaveEnoughtElements() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: "+")
        brain.buttonEqualTapped()
        XCTAssertEqual(brain.expressionHasEnoughElement,false)
    }
    func testGivenNotAllElementsExist_WhenEqualIsTaped_ThenExpresionIsNotCorrect() {
        XCTAssertTrue(brain.elements.count == 0)
        XCTAssertTrue(brain.expressionIsCorrect == true)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: "+")
        brain.buttonEqualTapped()
        XCTAssertTrue(brain.expressionIsCorrect == false)
    }
    func testGivenElementsExist_WhenDividingBy0_ThenErrorIsReturned() {
        XCTAssertFalse(brain.error == true)
        XCTAssertFalse(brain.operationInCreation == "Error")
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: ":")
        brain.operation(signOperator:"-")
        brain.addElements(digit: "0")
        brain.buttonEqualTapped()
        XCTAssertTrue(brain.error == true)
        XCTAssertTrue(brain.operationInCreation == "Error")
    }
    func testGivenOperationIsFinished_WhenNumberIsTaped_ThenTextIsEmptyAndAddNumber() {
        XCTAssertTrue(brain.elements.count == 0)
        brain.addElements(digit: "3")
        XCTAssertTrue(brain.elements[0] == "3")
        brain.addElements(digit: "2")
        XCTAssertTrue(brain.elements[0] == "32")
        brain.operation(signOperator: "+")
        brain.addElements(digit: "6")
        brain.buttonEqualTapped()
        brain.addElements(digit: "1")
        XCTAssertTrue(brain.elements[0] == "1")
    }
    func testGivenOperationIsFinished_WhenOperatorIsTaped_ThenTextIsEmpty() {
        XCTAssertTrue(brain.elements.count == 0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: "+")
        brain.addElements(digit: "6")
        brain.buttonEqualTapped()
        brain.operation(signOperator: "+")
        XCTAssertTrue(brain.operationInCreation == "")
    }
    func testGivenOneElement_WhenEqualIsTaped_ThenNotEnoughElements() {
        XCTAssertTrue(brain.elements.count == 0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.buttonEqualTapped()
        XCTAssert(brain.expressionHasEnoughElement == false)
    }
}
