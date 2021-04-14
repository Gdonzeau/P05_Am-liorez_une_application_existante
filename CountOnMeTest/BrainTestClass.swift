//
//  BrainTestClass.swift
//  CountOnMeTest
//
//  Created by Guillaume Donzeau on 27/03/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe
// Mettre 3/4 lignes par test.

class BrainTestClass: XCTestCase {
    var brain:ElectronicBrain!
    
    override func setUp() { // Se lance avant chaque fonction test
        super.setUp()
            // Initialiser brain.
        brain = ElectronicBrain() // Remet tout à zéro. Nouvel objet
    }
    override class func tearDown() { // Se lance une fois que TOUS les tests sont faits.
            }
    override func tearDown() { // Se lance après chaque fonction test
        brain = nil
        super.tearDown()
    }
    override class func setUp() { // Tout premier
        
    }
    // #1
    func testGivenInstanceOfElectronicBrain_WhenAccessingIt_ThenItExists() { // To delete ?
        XCTAssertNotNil(brain)
    }
    // #2
    func testGivenElementsIsEmpty_WhenTappedNumbers_ThenElementsCountIsOne() { // To delete too, as if the next func is true, that means that count == 1 ?
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.elements.count,1)
    }
    // #3
    func testGivenElementsIsEmpty_WhenTappedNumbers_ThenFirstElementsIsNumberTapped() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.elements[0],"1")
    }
    // #4
    func testGivenElementsIsNOtEmpty_WhenTappedAC_ThenElementsIsEmpty() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.operationInCreation,"1")
        XCTAssertNotEqual(brain.elements.count,0)
        brain.AC()
        XCTAssertEqual(brain.elements.count,0)
        XCTAssertEqual(brain.operationInCreation,"")
    }
    // #5
    func testGivenElementsFirstIs1_WhenTappedNumbers_ThenFirstElementsIs1AndNumberTapped() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        XCTAssertEqual(brain.elements[0],"12")
    }
    // #6
    func testGivenNegativeElementInFirstPlace_WhenTappedNumbers_ThenFirstElementsIs1AndNumberTapped() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "-")
        brain.addElements(digit: "2")
        XCTAssertEqual(brain.elements[0],"-2")
    }
    // #7
    func testGivenFirstPlaceIsEmpty_WhenMultiplyingByNegtiveNumber_ThenItIsAccepted() {
        XCTAssertEqual(brain.operationIsNotEmpty,false)
        brain.operation(signOperator: "-")
        XCTAssertEqual(brain.operationIsNotEmpty,true)
        brain.addElements(digit: "2")
        brain.operation(signOperator: "x")
        XCTAssertEqual(brain.cantAddMinus,false)
        brain.operation(signOperator: "-")
        XCTAssertEqual(brain.cantAddMinus,true)
        brain.addElements(digit: "4")
        XCTAssertEqual(brain.cantAddMinus,true)
        brain.resolvingOperation()
    }
    // #8
    func testGivenElementsIsEmpty_WhenTappedOperator_ThenFirstElementsIsNil() {
        XCTAssertEqual(brain.elements.count,0)
        brain.operation(signOperator: "+")
        XCTAssertEqual(brain.elements.count,0)
    }
    // #9
    
    func testGivenErrorIsTrue_WhenTappedNumbers_ThenFirstElementsIsEmpty() {
        XCTAssertEqual(brain.error,false)
        brain.operationInCreation = "2 : -0"
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"Error")
        XCTAssertEqual(brain.error,true)
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.operationInCreation,"")
        XCTAssertEqual(brain.error,false)
        
    }
 
    // #10
    func testGivenAllElementsExistAndAreIntOrDouble_WhenEqualIsTaped_ThenResultIsGivenForAllOperators() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "-")
        brain.addElements(digit: "9")
        brain.operation(signOperator: "+")
        brain.addElements(digit: "6")
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation, "-9 + 6 = -3")
        XCTAssertEqual(brain.elements.last,"-3")
    }
    // #11
    func testGivenfirstElement_WhenDividingBy0_ThenDivideBy0IsTrue() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: ":")
        XCTAssertEqual(brain.operatorIsDivide,true)
        brain.addElements(digit: "0")
    }
    // #12
    func testGivenNothingIsWritten_WhenAddingOperator_ThenIsNotWritten() {
        XCTAssertEqual(brain.elements.count,0)
        brain.operation(signOperator: "+")
        XCTAssertEqual(brain.elements.count,0)
    }
    // #13
    func testGivenNotAllElementsExist_WhenEqualIsTaped_ThenExpressionDoesntHaveEnoughtElements() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: "+")
        brain.resolvingOperation()
        XCTAssertEqual(brain.expressionHasEnoughElement,false)
    }
    // #14
    func testGivenNotAllElementsExist_WhenEqualIsTaped_ThenExpresionIsNotCorrect() {
        XCTAssertEqual(brain.elements.count,0)
        XCTAssertEqual(brain.lastIsNotAnOperator,true)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: "+")
        brain.resolvingOperation()
        XCTAssertEqual(brain.lastIsNotAnOperator,false)
    }
    // #15
    func testGivenElementsExist_WhenDividingBy0_ThenErrorIsReturned() {
        XCTAssertFalse(brain.error) // *********************
        //XCTAssertTrue(brain.expressionIsNotDividedByZero)
        XCTAssertNotEqual(brain.operationInCreation,"Error")
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: ":")
        brain.operation(signOperator:"-")
        brain.addElements(digit: "0")
        brain.resolvingOperation()
        XCTAssertFalse(brain.expressionIsDividedByZero)
        //XCTAssertTrue(brain.error)
        XCTAssertEqual(brain.operationInCreation,"Error")
    }
    // #16
    func testGivenOperationIsFinished_WhenNumberIsTaped_ThenTextIsEmptyAndAddNumber() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "3")
        XCTAssertEqual(brain.elements[0],"3")
        brain.addElements(digit: "2")
        XCTAssertEqual(brain.elements[0],"32")
        brain.operation(signOperator: "+")
        brain.addElements(digit: "6")
        brain.resolvingOperation()
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.elements[0],"1")
    }
    // #17
    func testGivenOperationIsFinished_WhenOperatorIsTaped_ThenTextIsEmpty() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: "x")
        brain.addElements(digit: "6")
        brain.resolvingOperation()
        brain.operation(signOperator: "+")
        XCTAssertEqual(brain.operationInCreation,"")
    }
    // #18
    func testGivenOneElement_WhenEqualIsTaped_ThenNotEnoughElements() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.resolvingOperation()
        XCTAssertEqual(brain.expressionHasEnoughElement,false)
    }
    // #19
    func testGivenElementsAreReady_WhenOperatorIsDivide_ThenResultCanBeADouble() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "1")
        brain.operation(signOperator: ":")
        brain.addElements(digit: "2")
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"11 : 2 = 5.5")
        XCTAssertEqual(brain.elements.last,"5.5")
    }
    // #20
    func testGivenAdditionIsReady_WhenPressEqual_ThenRightResultIsGiven() {
        brain.operationInCreation = "2 + 3"
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"2 + 3 = 5")
        XCTAssertEqual(brain.elements.last,"5")
    }
    // #21
    func testGivenSoustractionIsReady_WhenPressEqual_ThenRightResultIsGiven() {
        brain.operationInCreation = "2 - 3"
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"2 - 3 = -1")
        XCTAssertEqual(brain.elements.last,"-1")
    }
    // #22
    func testGivenMultiplicationIsReady_WhenPressEqual_ThenRightResultIsGiven() {
        brain.operationInCreation = "2 x 3"
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"2 x 3 = 6")
        XCTAssertEqual(brain.elements.last,"6")
    }
    // #23
    func testGivenDivisionIsReady_WhenPressEqual_ThenRightResultIsGiven() {
        brain.operationInCreation = "4 : 2"
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"4 : 2 = 2")
        XCTAssertEqual(brain.elements.last,"2")
    }
}
