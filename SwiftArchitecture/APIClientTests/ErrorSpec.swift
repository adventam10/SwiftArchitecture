//
//  ErrorSpec.swift
//  APIClientTests
//
//  Created by am10 on 2019/09/07.
//  Copyright © 2019 am10. All rights reserved.
//

import Quick
import Nimble
@testable import APIClient

class ErrorSpec: QuickSpec {
    override func spec() {
        describe("localizedDescription") {
            context("network") {
                it("not nil") {
                    expect(APIError.network.localizedDescription).notTo(beNil())
                }
            }
            
            context("notFound") {
                it("not nil") {
                    expect(APIError.notFound.localizedDescription).notTo(beNil())
                }
            }
            
            context("invalidJSON") {
                it("not nil") {
                    expect(APIError.invalidJSON("invalid").localizedDescription).notTo(beNil())
                }
            }
        }
    }
}
