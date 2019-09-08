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
            context("empty") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = []
                it ("true") {
                    expect(viewModel.isAllCheck()).to(beFalse())
                }
            }
            
            context("selected one") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = [.hokkaido]
                it ("false") {
                    expect(viewModel.isAllCheck()).to(beFalse())
                }
            }
            
            context("selected all") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = Area.allCases
                it ("true") {
                    expect(viewModel.isAllCheck()).to(beTrue())
                }
            }
        }
        
        describe("setupSelectedAreaTypesWithAreaType method") {
            context("deselect hokkaido") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = Area.allCases
                viewModel.setupSelectedAreaTypes(areaType: .hokkaido)
                it ("not contain hokkaido") {
                    expect(viewModel.selectedAreaTypes.value).notTo(contain(.hokkaido))
                    expect(viewModel.selectedAreaTypes.value).to(haveCount(Area.allCases.count - 1))
                }
            }
            
            context("select hokkaido") {
                let viewModel = makeAreaFilterViewModel()
                let selectedAreaTypes: [Area] = [.kinki, .kanto, .kyushu]
                viewModel.selectedAreaTypes.value = selectedAreaTypes
                viewModel.setupSelectedAreaTypes(areaType: .hokkaido)
                it ("contain hokkaido") {
                    expect(viewModel.selectedAreaTypes.value).to(contain(.hokkaido))
                    expect(viewModel.selectedAreaTypes.value).to(haveCount(selectedAreaTypes.count + 1))
                }
            }
        }
        
        describe("setupSelectedAreaTypesWithIsAllCheck method") {
            context("isAllCheck is true") {
                context("when selected all") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = Area.allCases
                    it ("selected all") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: true)
                        expect(viewModel.selectedAreaTypes.value).to(haveCount(Area.allCases.count))
                        expect(viewModel.selectedAreaTypes.value).to(equal(Area.allCases))
                    }
                }
                
                context("when selected none") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = []
                    it ("selected all") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: true)
                        expect(viewModel.selectedAreaTypes.value).to(haveCount(Area.allCases.count))
                        expect(viewModel.selectedAreaTypes.value).to(equal(Area.allCases))
                    }
                }
                
                context("when selected something") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = [.hokkaido, .tohoku, .kanto]
                    it ("selected all") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: true)
                        expect(viewModel.selectedAreaTypes.value).to(haveCount(Area.allCases.count))
                        expect(viewModel.selectedAreaTypes.value).to(equal(Area.allCases))
                    }
                }
            }
            
            context("isAllCheck is false") {
                context("when selected all") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = Area.allCases
                    it ("selected none") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: false)
                        expect(viewModel.selectedAreaTypes.value).to(beEmpty())
                    }
                }
                
                context("when selected none") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = []
                    it ("selected none") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: false)
                        expect(viewModel.selectedAreaTypes.value).to(beEmpty())
                    }
                }
                
                context("when selected something") {
                    let viewModel = makeAreaFilterViewModel()
                    viewModel.selectedAreaTypes.value = [.hokkaido, .tohoku, .kanto]
                    it ("selected none") {
                        viewModel.setupSelectedAreaTypes(isAllCheck: false)
                        expect(viewModel.selectedAreaTypes.value).to(beEmpty())
                    }
                }
            }
        }
        
        describe("makeCellViewModelWithIndex method") {
            context("deselect target") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = []
                it ("on target") {
                    let cell = viewModel.makeCellViewModel(index: Area.kinki.rawValue)
                    expect(cell.title).to(equal(Area.kinki.getName()))
                    expect(cell.isCheck).to(beFalse())
                }
            }
            
            context("select target") {
                let viewModel = makeAreaFilterViewModel()
                viewModel.selectedAreaTypes.value = [.kinki]
                it ("on target") {
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

