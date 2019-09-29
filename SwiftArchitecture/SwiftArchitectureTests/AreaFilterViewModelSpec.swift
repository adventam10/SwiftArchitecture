//
//  AreaFilterViewModelSpec.swift
//  SwiftArchitectureTests
//
//  Created by am10 on 2019/09/07.
//  Copyright © 2019 am10. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftArchitecture

class AreaFilterViewModelSpec: QuickSpec {
    let resolver = TestResolver()
    override func spec() {
        describe("isAllCheck method") {
            context("when selectedAreaTypes is empty") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = []
                it ("returns true") {
                    expect(viewModel.isAllCheck()).to(beFalse())
                }
            }
            
            context("when selected one") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = [.hokkaido]
                it ("returns false") {
                    expect(viewModel.isAllCheck()).to(beFalse())
                }
            }
            
            context("when selected all") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = Area.allCases
                it ("returns true") {
                    expect(viewModel.isAllCheck()).to(beTrue())
                }
            }
        }
        
        describe("setupSelectedAreaTypesWithAreaType method") {
            context("when deselected hokkaido") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = Area.allCases
                viewModel.setupSelectedAreaTypes(areaType: .hokkaido)
                it ("returns selectedAreaTypes excludes hokkaido") {
                    expect(viewModel.selectedAreaTypes.value).notTo(contain(.hokkaido))
                    expect(viewModel.selectedAreaTypes.value).to(haveCount(Area.allCases.count - 1))
                }
            }
            
            context("when selected hokkaido") {
                let viewModel = makeAreaFilterViewModel()
                let selectedAreaTypes: [Area] = [.kinki, .kanto, .kyushu]
                viewModel.selectedAreaTypes.value = selectedAreaTypes
                viewModel.setupSelectedAreaTypes(areaType: .hokkaido)
                it ("returns selectedAreaTypes contains hokkaido") {
                    expect(viewModel.selectedAreaTypes.value).to(contain(.hokkaido))
                    expect(viewModel.selectedAreaTypes.value).to(haveCount(selectedAreaTypes.count + 1))
                }
            }
        }
        
        describe("setupSelectedAreaTypesWithIsAllCheck method") {
            context("when isAllCheck is true") {
                context("when selected all") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = Area.allCases
                    it ("returns selectedAreaTypes contains all areas") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: true)
                        expect(viewModel.selectedAreaTypes.value).to(haveCount(Area.allCases.count))
                        expect(viewModel.selectedAreaTypes.value).to(equal(Area.allCases))
                    }
                }
                
                context("when selected none") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = []
                    it ("returns selectedAreaTypes contains all areas") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: true)
                        expect(viewModel.selectedAreaTypes.value).to(haveCount(Area.allCases.count))
                        expect(viewModel.selectedAreaTypes.value).to(equal(Area.allCases))
                    }
                }
                
                context("when selected something") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = [.hokkaido, .tohoku, .kanto]
                    it ("returns selectedAreaTypes contains all areas") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: true)
                        expect(viewModel.selectedAreaTypes.value).to(haveCount(Area.allCases.count))
                        expect(viewModel.selectedAreaTypes.value).to(equal(Area.allCases))
                    }
                }
            }
            
            context("when isAllCheck is false") {
                context("when selected all") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = Area.allCases
                    it ("returns selectedAreaTypes is empty") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: false)
                        expect(viewModel.selectedAreaTypes.value).to(beEmpty())
                    }
                }
                
                context("when selected none") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = []
                    it ("returns selectedAreaTypes is empty") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: false)
                        expect(viewModel.selectedAreaTypes.value).to(beEmpty())
                    }
                }
                
                context("when selected something") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = [.hokkaido, .tohoku, .kanto]
                    it ("returns selectedAreaTypes is empty") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: false)
                        expect(viewModel.selectedAreaTypes.value).to(beEmpty())
                    }
                }
            }
        }
        
        describe("makeCellViewModelWithIndex method") {
            context("when deselected target") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = []
                it ("returns the target") {
                    let cell = viewModel.makeCellViewModel(index: Area.kinki.rawValue)
                    expect(cell.title).to(equal(Area.kinki.getName()))
                    expect(cell.isCheck).to(beFalse())
                }
            }
            
            context("when selects target") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = [.kinki]
                it ("returns the target") {
                    let cell = viewModel.makeCellViewModel(index: Area.kinki.rawValue)
                    expect(cell.title).to(equal(Area.kinki.getName()))
                    expect(cell.isCheck).to(beTrue())
                }
            }
        }
    }
    
    private func makeAreaFilterViewModel() -> AreaFilterViewModel {
        return resolver.resolveAreaFilterViewModel(selectedAreaTypes: [])
    }
}

