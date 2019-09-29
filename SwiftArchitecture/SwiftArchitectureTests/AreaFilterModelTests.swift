//
//  AreaFilterModelTests.swift
//  SwiftArchitectureTests
//
//  Created by makoto on 2019/09/29.
//  Copyright © 2019 am10. All rights reserved.
//

import XCTest
@testable import SwiftArchitecture

final class AreaFilterModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsAllCheck() {
        let model = AreaFilterModel()
        
        // when selectedAreaTypes is empty
        model.selectedAreaTypes = []
        XCTAssertFalse(model.isAllCheck)
        
        // when all areas selected
        model.selectedAreaTypes = AreaFilterModel.Area.allCases
        XCTAssertTrue(model.isAllCheck)
        
        // when some areas selected
        model.selectedAreaTypes = [.hokkaido, .chubu]
        XCTAssertFalse(model.isAllCheck)
    }
    
    func testSelectAll() {
        let model = AreaFilterModel()
        model.selectedAreaTypes = [.hokkaido]
        model.selectAll()
        XCTAssertEqual(model.selectedAreaTypes.count, AreaFilterModel.Area.allCases.count)
    }
    
    func testDeselectAll() {
        let model = AreaFilterModel()
        model.selectedAreaTypes = [.hokkaido]
        model.deselectAll()
        XCTAssertTrue(model.selectedAreaTypes.isEmpty)
    }
}
