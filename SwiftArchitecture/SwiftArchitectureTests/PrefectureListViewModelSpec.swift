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
    let resolver = TestResolver()
    override func spec() {
        describe("cityDataList") {
            let viewModel = makePrefectureListViewModel()
            it ("count is 47") {
                expect(viewModel.cityDataList).to(haveCount(47))
            }
        }
        
        describe("setupFavoriteListWithCityId method") {
            context("when unregistered osaka") {
                context("when registered something") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .aomori, .iwate])
                    viewModel.setupFavoriteList(cityId: CityId.osaka.rawValue)
                    it ("contain osaka") {
                        expect(viewModel.favoriteCityIds.value).to(contain(CityId.osaka.rawValue))
                        expect(viewModel.favoriteCityIds.value).to(haveCount(4))
                    }
                }
                
                context("when registered none") {
                    let viewModel = makePrefectureListViewModel()
                    viewModel.favoriteCityIds.value = []
                    viewModel.setupFavoriteList(cityId: CityId.osaka.rawValue)
                    it ("contain osaka") {
                        expect(viewModel.favoriteCityIds.value).to(contain(CityId.osaka.rawValue))
                        expect(viewModel.favoriteCityIds.value).to(haveCount(1))
                    }
                }
            }
            
            context("when registered osaka") {
                let viewModel = makePrefectureListViewModel()
                viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .aomori, .iwate, .osaka])
                viewModel.setupFavoriteList(cityId: CityId.osaka.rawValue)
                it ("not contain osaka") {
                    expect(viewModel.favoriteCityIds.value).notTo(contain(CityId.osaka.rawValue))
                    expect(viewModel.favoriteCityIds.value).to(haveCount(3))
                }
            }
        }
        
        describe("setupTableDataList method") {
            context("isFavoriteFilter is true") {
                context("filtered by hokkaido") {
                    context("when unregistered hokkaido") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.hokkaido]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.aomori, .osaka])
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered hokkaido") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.hokkaido]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .aomori, .osaka])
                        viewModel.setupTableDataList()
                        it ("count is 1") {
                            expect(viewModel.tableDataList.value).to(haveCount(1))
                        }
                    }
                }

                context("filtered by tohoku") {
                    context("when unregistered tohoku") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.tohoku]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered aomori and akita") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.tohoku]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.aomori, .akita, .hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("count is 2") {
                            expect(viewModel.tableDataList.value).to(haveCount(2))
                        }
                    }
                }

                context("filtered by kanto") {
                    context("when unregistered kanto") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.kanto]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered tokyo and chiba") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.kanto]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.tokyo, .chiba, .hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("count is 2") {
                            expect(viewModel.tableDataList.value).to(haveCount(2))
                        }
                    }
                }

                context("filtered by chubu") {
                    context("when unregistered chubu") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.chubu]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered nagano and gifu") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.chubu]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.nagano, .gifu, .hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("count is 2") {
                            expect(viewModel.tableDataList.value).to(haveCount(2))
                        }
                    }
                }

                context("filtered by kinki") {
                    context("when unregistered kinki") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.kinki]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .aichi])
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered osaka and kyoto") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.kinki]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.osaka, .kyoto, .hokkaido, .aichi])
                        viewModel.setupTableDataList()
                        it ("count is 2") {
                            expect(viewModel.tableDataList.value).to(haveCount(2))
                        }
                    }
                }

                context("filtered by chugoku") {
                    context("when unregistered chugoku") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.chugoku]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered okayama and shimane") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.chugoku]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.okayama, .shimane, .hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("count is 2") {
                            expect(viewModel.tableDataList.value).to(haveCount(2))
                        }
                    }
                }

                context("filtered by shikoku") {
                    context("when unregistered shikoku") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.shikoku]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered ehime and kagawa") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.shikoku]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.ehime, .kagawa, .hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("count is 2") {
                            expect(viewModel.tableDataList.value).to(haveCount(2))
                        }
                    }
                }

                context("filtered by kyushu") {
                    context("when unregistered kyushu") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.kyushu]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered kagoshima and saga") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.kyushu]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.kagoshima, .saga, .hokkaido, .osaka])
                        viewModel.setupTableDataList()
                        it ("count is 2") {
                            expect(viewModel.tableDataList.value).to(haveCount(2))
                        }
                    }
                }

                context("filtered by kinki and kyushu") {
                    context("when unregistered kinki and kyushu") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.kinki, .kyushu]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.hokkaido, .shimane, .ehime])
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered kagoshima and osaka") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = [.kinki, .kyushu]
                        viewModel.favoriteCityIds.value = CityId.cityIds([.kagoshima, .osaka, .hokkaido, .shimane, .ehime])
                        viewModel.setupTableDataList()
                        it ("count is 2") {
                            expect(viewModel.tableDataList.value).to(haveCount(2))
                        }
                    }
                }

                context("filtered by selected all") {
                    context("when registered none") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = Area.allCases
                        viewModel.favoriteCityIds.value = []
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered kagoshima and osaka") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = Area.allCases
                        viewModel.favoriteCityIds.value = CityId.cityIds([.kagoshima, .osaka])
                        viewModel.setupTableDataList()
                        it ("count is 2") {
                            expect(viewModel.tableDataList.value).to(haveCount(2))
                        }
                    }
                }

                context("filtered by selected none") {
                    context("when registered none") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = []
                        viewModel.favoriteCityIds.value = []
                        viewModel.setupTableDataList()
                        it ("empty") {
                            expect(viewModel.tableDataList.value).to(beEmpty())
                        }
                    }
                    
                    context("when registered kagoshima and osaka") {
                        let viewModel = makePrefectureListViewModel()
                        viewModel.isFavoriteFilter.value = true
                        viewModel.selectedAreaTypes.value = []
                        viewModel.favoriteCityIds.value = CityId.cityIds([.kagoshima, .osaka])
                        viewModel.setupTableDataList()
                        it ("count is 2") {
                            expect(viewModel.tableDataList.value).to(haveCount(2))
                        }
                    }
                }
            }
        
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
                viewModel.favoriteCityIds.value = []
                viewModel.isFavoriteFilter.value = false
                viewModel.setupTableDataList()
                it ("on target") {
                    let cell = viewModel.makeCellViewModel(index: 5)
                    expect(cell.cityName).to(equal("yamagata"))
                    expect(cell.isFavorite).to(beFalse())
                }
            }
            
            context("favorite target") {
                let viewModel = makePrefectureListViewModel()
                viewModel.selectedAreaTypes.value = Area.allCases
                viewModel.favoriteCityIds.value = CityId.cityIds([.yamagata])
                viewModel.isFavoriteFilter.value = false
                viewModel.setupTableDataList()
                it ("on target") {
                    let cell = viewModel.makeCellViewModel(index: 5)
                    expect(cell.cityName).to(equal("yamagata"))
                    expect(cell.isFavorite).to(beTrue())
                }
            }
        }
    }
    
    private func makePrefectureListViewModel() -> PrefectureListViewModel {
        return resolver.resolvePrefectureListViewModel()
    }
}
