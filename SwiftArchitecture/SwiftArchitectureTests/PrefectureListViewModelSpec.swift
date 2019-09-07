//
//  PrefectureListViewModelSpec.swift
//  SwiftArchitectureTests
//
//  Created by am10 on 2019/09/07.
//  Copyright © 2019 am10. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftArchitecture

class PrefectureListViewModelSpec: QuickSpec {
    let resolver = AppResolverImpl()
    
    override func spec() {
        describe("cityDataList") {
            let viewModel = makePrefectureListViewModel()
            it ("count is 47") {
                expect(viewModel.cityDataList).to(haveCount(47))
            }
        }
        
        describe("setupFavoriteListWithCityId method") {
            
        }
        
        describe("setupTableDataList method") {
//            context("isFavoriteFilter is true") {
//                context("filtered by hokkaido") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = [.hokkaido]
//                    viewModel.setupTableDataList()
//                    it ("count is 1") {
//                        expect(viewModel.tableDataList.value).to(haveCount(1))
//                    }
//                }
//
//                context("filtered by tohoku") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = [.tohoku]
//                    viewModel.setupTableDataList()
//                    it ("count is 6") {
//                        expect(viewModel.tableDataList.value).to(haveCount(6))
//                    }
//                }
//
//                context("filtered by kanto") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = [.kanto]
//                    viewModel.setupTableDataList()
//                    it ("count is 7") {
//                        expect(viewModel.tableDataList.value).to(haveCount(7))
//                    }
//                }
//
//                context("filtered by chubu") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = [.chubu]
//                    viewModel.setupTableDataList()
//                    it ("count is 10") {
//                        expect(viewModel.tableDataList.value).to(haveCount(10))
//                    }
//                }
//
//                context("filtered by kinki") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = [.kinki]
//                    viewModel.setupTableDataList()
//                    it ("count is 6") {
//                        expect(viewModel.tableDataList.value).to(haveCount(6))
//                    }
//                }
//
//                context("filtered by chugoku") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = [.chugoku]
//                    viewModel.setupTableDataList()
//                    it ("count is 5") {
//                        expect(viewModel.tableDataList.value).to(haveCount(5))
//                    }
//                }
//
//                context("filtered by shikoku") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = [.shikoku]
//                    viewModel.setupTableDataList()
//                    it ("count is 4") {
//                        expect(viewModel.tableDataList.value).to(haveCount(4))
//                    }
//                }
//
//                context("filtered by kyushu") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = [.kyushu]
//                    viewModel.setupTableDataList()
//                    it ("count is 8") {
//                        expect(viewModel.tableDataList.value).to(haveCount(8))
//                    }
//                }
//
//                context("filtered by kinki and kyushu") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = [.kinki, .kyushu]
//                    viewModel.setupTableDataList()
//                    it ("count is 15") {
//                        expect(viewModel.tableDataList.value).to(haveCount(15))
//                    }
//                }
//
//                context("filtered by selected all") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = Area.allCases
//                    viewModel.setupTableDataList()
//                    it ("count is 47") {
//                        expect(viewModel.tableDataList.value).to(haveCount(47))
//                    }
//                }
//
//                context("filtered by selected none") {
//                    let viewModel = makePrefectureListViewModel()
//                    viewModel.isFavoriteFilter.value = true
//                    viewModel.selectedAreaTypes.value = []
//                    viewModel.setupTableDataList()
//                    it ("is empty") {
//                        expect(viewModel.tableDataList.value).to(beEmpty())
//                    }
//                }
//            }
        
            context("isFavoriteFilter is false") {
                context("filtered by hokkaido") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = [.hokkaido]
                    viewModel.setupTableDataList()
                    it ("count is 1") {
                        expect(viewModel.tableDataList.value).to(haveCount(1))
                    }
                }
                
                context("filtered by tohoku") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = [.tohoku]
                    viewModel.setupTableDataList()
                    it ("count is 6") {
                        expect(viewModel.tableDataList.value).to(haveCount(6))
                    }
                }
                
                context("filtered by kanto") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = [.kanto]
                    viewModel.setupTableDataList()
                    it ("count is 7") {
                        expect(viewModel.tableDataList.value).to(haveCount(7))
                    }
                }
                
                context("filtered by chubu") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = [.chubu]
                    viewModel.setupTableDataList()
                    it ("count is 10") {
                        expect(viewModel.tableDataList.value).to(haveCount(10))
                    }
                }
                
                context("filtered by kinki") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = [.kinki]
                    viewModel.setupTableDataList()
                    it ("count is 6") {
                        expect(viewModel.tableDataList.value).to(haveCount(6))
                    }
                }
                
                context("filtered by chugoku") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = [.chugoku]
                    viewModel.setupTableDataList()
                    it ("count is 5") {
                        expect(viewModel.tableDataList.value).to(haveCount(5))
                    }
                }
                
                context("filtered by shikoku") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = [.shikoku]
                    viewModel.setupTableDataList()
                    it ("count is 4") {
                        expect(viewModel.tableDataList.value).to(haveCount(4))
                    }
                }
                
                context("filtered by kyushu") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = [.kyushu]
                    viewModel.setupTableDataList()
                    it ("count is 8") {
                        expect(viewModel.tableDataList.value).to(haveCount(8))
                    }
                }
                
                context("filtered by kinki and kyushu") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = [.kinki, .kyushu]
                    viewModel.setupTableDataList()
                    it ("count is 15") {
                        expect(viewModel.tableDataList.value).to(haveCount(14))
                    }
                }
                
                context("filtered by selected all") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = Area.allCases
                    viewModel.setupTableDataList()
                    it ("count is 47") {
                        expect(viewModel.tableDataList.value).to(haveCount(47))
                    }
                }
                
                context("filtered by selected none") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.isFavoriteFilter.value = false
                    viewModel.selectedAreaTypes.value = []
                    viewModel.setupTableDataList()
                    it ("count is 47") {
                        expect(viewModel.tableDataList.value).to(haveCount(47))
                    }
                }
            }
        }
        
        describe("makeCellViewModelWithIndex method") {
            context("not favorite target") {
                let viewModel = makePrefectureListViewModel()
                viewModel.selectedAreaTypes.value = Area.allCases
                viewModel.isFavoriteFilter.value = false
                viewModel.setupTableDataList()
                it ("on target") {
                    let cell = viewModel.makeCellViewModel(index: 5)
                    expect(cell.cityName).to(equal("yamagata"))
                    expect(cell.isFavorite).to(beFalse())
                }
            }
            
//            context("favorite target") {
//                let viewModel = makePrefectureListViewModel()
//                viewModel.selectedAreaTypes.value = Area.allCases
//                viewModel.isFavoriteFilter.value = false
//                viewModel.setupTableDataList()
//                it ("on target") {
//                    let cell = viewModel.makeCellViewModel(index: 5)
//                    expect(cell.cityName).to(equal("yamagata"))
//                    expect(cell.isFavorite).to(beTrue())
//                }
//            }
        }
    }
    
    private func makePrefectureListViewModel() -> PrefectureListViewModel {
        return resolver.resolvePrefectureListViewModel()
    }
}
