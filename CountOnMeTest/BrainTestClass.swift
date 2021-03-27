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
    
    func testGivenInstanceOfElectronicBrain_WhenAccessingIt_ThenItExists() {
        XCTAssertNotNil(brain)
    }
}
