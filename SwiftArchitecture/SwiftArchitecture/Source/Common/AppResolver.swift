//
//  AppResolver.swift
//  
//
//  Created by am10 on 2019/04/28.
//

import Foundation
import DIKit
import APIClient

protocol AppResolver: Resolver {
    func provideResolver() -> AppResolver
    func provideAPIClient() -> WeatherAPIClient
}

final class AppResolverImpl: AppResolver {
    private let apiClient: WeatherAPIClient = DefaultAPIClient()
    
    func provideResolver() -> AppResolver {
        return self
    }
    
    func provideAPIClient() -> WeatherAPIClient {
        return apiClient
    }
}
