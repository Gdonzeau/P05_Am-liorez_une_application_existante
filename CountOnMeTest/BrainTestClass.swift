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
    
    // MARK: - Checking Filling
    
    // #1
    func testGivenInstanceOfElectronicBrain_WhenAccessingIt_ThenItExists() {
        XCTAssertNotNil(brain)
    }
    // #2
    func testGivenElementsIsEmpty_WhenTappedNumbers_ThenElementsCountIsOne() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.elements.count,1)
        XCTAssertEqual(brain.elements[0],"1")
    }
    // #3
    func testGivenElementsIsNOtEmpty_WhenTappedAC_ThenElementsIsEmpty() {
        brain.operationInCreation = "2 + 3"
        XCTAssertEqual(brain.elements.count,3)
        brain.AC()
        XCTAssertEqual(brain.elements.count,0)
        XCTAssertEqual(brain.operationInCreation,"")
    }
    // #4
    func testGivenElementsFirstIs1_WhenTappedNumbers_ThenFirstElementsIs1AndNumberTapped() {
        brain.operationInCreation = "1"
        XCTAssertEqual(brain.elements[0],"1")
        brain.addElements(digit: "2")
        XCTAssertEqual(brain.elements[0],"12")
    }
    // #5
    func testGivenNegativeElementInFirstPlace_WhenTappedNumbers_ThenFirstElementsIs1AndNumberTapped() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "-")
        brain.addElements(digit: "2")
        XCTAssertEqual(brain.elements[0],"-2")
    }
    
    // MARK: - Checking basic operations
    
    // #6
    func testGivenAdditionIsReady_WhenPressEqual_ThenRightResultIsGiven() {
        brain.operationInCreation = "2 + 3"
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"2 + 3 = 5")
        XCTAssertEqual(brain.elements.last,"5")
    }
    // #7
    func testGivenSoustractionIsReady_WhenPressEqual_ThenRightResultIsGiven() {
        brain.operationInCreation = "2 - 3"
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"2 - 3 = -1")
        XCTAssertEqual(brain.elements.last,"-1")
    }
    // #8
    func testGivenMultiplicationIsReady_WhenPressEqual_ThenRightResultIsGiven() {
        brain.operationInCreation = "2 x 3"
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"2 x 3 = 6")
        XCTAssertEqual(brain.elements.last,"6")
    }
    // #9
    func testGivenDivisionIsReady_WhenPressEqual_ThenRightResultIsGiven() {
        brain.operationInCreation = "4 : 2"
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"4 : 2 = 2")
        XCTAssertEqual(brain.elements.last,"2")
    }
    
    // MARK: - Minus, Negative and Dividing by Zero
    
    // #10
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
        XCTAssertEqual(brain.elements.last,"8")
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
    // #11
    func testGivenfirstElement_WhenDividingBy0_ThenIgnored() {
        XCTAssertEqual(brain.elements.count,0)
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: ":")
        XCTAssertEqual(brain.operatorIsDivide,true)
        brain.addElements(digit: "0")
        XCTAssertEqual(brain.elements.last,":")
    }
    // #15
    func testGivenElementsExist_WhenDividingBy0_ThenErrorIsReturned() {
        XCTAssertFalse(brain.error) // *********************
        XCTAssertNotEqual(brain.operationInCreation,"Error")
        brain.addElements(digit: "1")
        brain.addElements(digit: "2")
        brain.operation(signOperator: ":")
        brain.operation(signOperator:"-")
        brain.addElements(digit: "0")
        brain.resolvingOperation()
        XCTAssertFalse(brain.expressionIsDividedByZero)
        XCTAssertEqual(brain.operationInCreation,"Error")
    }
    
    // MARK: - Checking that operation is right
    
    // #13
    func testGivenNotAllElementsExist_WhenEqualIsTaped_ThenExpressionDoesntHaveEnoughtElements() {
        brain.operationInCreation = "12 + "
        brain.resolvingOperation()
        XCTAssertEqual(brain.expressionHasEnoughElement,false)
        XCTAssertEqual(brain.lastIsNotAnOperator,false)
    }
    // #18
    func testGivenOneElement_WhenEqualIsTaped_ThenNotEnoughElements() {
        XCTAssertEqual(brain.elements.count,0)
        brain.operationInCreation = "12"
        brain.resolvingOperation()
        XCTAssertEqual(brain.expressionHasEnoughElement,false)
    }
    
    // MARK: -
    
    // #16
    func testGivenOperationIsFinished_WhenNumberIsTaped_ThenTextIsEmptyAndAddNumber() {
        brain.operationInCreation = "32 + 6 = 38"
        brain.addElements(digit: "1")
        XCTAssertEqual(brain.elements[0],"1")
    }
    // #17
    func testGivenOperationIsFinished_WhenOperatorIsTaped_ThenTextIsEmpty() {
        brain.operationInCreation = "12 x 6 = 72"
        XCTAssertEqual(brain.operationInCreation,"12 x 6 = 72")
        brain.operation(signOperator: "+")
        XCTAssertEqual(brain.operationInCreation,"")
    }
    
    // #19
    func testGivenElementsAreReady_WhenOperatorIsDivide_ThenResultCanBeADouble() {
        XCTAssertEqual(brain.elements.count,0)
        brain.operationInCreation = "11 : 2"
        XCTAssertEqual(brain.operationInCreation,"11 : 2")
        brain.resolvingOperation()
        XCTAssertEqual(brain.operationInCreation,"11 : 2 = 5.5")
        XCTAssertEqual(brain.elements.last,"5.5")
    }
}
