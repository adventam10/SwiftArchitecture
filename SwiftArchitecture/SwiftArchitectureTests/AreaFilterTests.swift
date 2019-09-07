//
//  AreaFilterTests.swift
//  SwiftArchitectureTests
//
//  Created by am10 on 2019/04/28.
//  Copyright © 2019 am10. All rights reserved.
//

import XCTest
@testable import SwiftArchitecture

class AreaFilterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsAllCheck() {
        let viewModel = AreaFilterViewModel(dependency: AreaFilterViewModel.Dependency(selectedAreaTypes: []))
        XCTAssertTrue(viewModel.isAllCheck())
        viewModel.selectedAreaTypes.value.removeLast()
        XCTAssertFalse(viewModel.isAllCheck())
        viewModel.selectedAreaTypes.value = [.hokkaido, .tohoku, .kanto, .chubu, .kinki, .chugoku, .shikoku, .kyushu]
        XCTAssertTrue(viewModel.isAllCheck())
    }

    func testAllCheckAction() {
        let viewModel = AreaFilterViewModel(dependency: AreaFilterViewModel.Dependency(selectedAreaTypes: []))
        let all: [Area] = [.hokkaido, .tohoku, .kanto, .chubu, .kinki, .chugoku, .shikoku, .kyushu]
        viewModel.setupSelectedAreaTypes(isAllCheck: true)
        XCTAssertEqual(viewModel.selectedAreaTypes.value, all)
        viewModel.setupSelectedAreaTypes(isAllCheck: false)
        XCTAssertTrue(viewModel.selectedAreaTypes.value.isEmpty)
    }
}
