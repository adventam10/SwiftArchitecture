//
//  AppResolver.swift
//  
//
//  Created by makoto on 2019/04/28.
//

import Foundation
import DIKit

protocol AppResolver: Resolver {
    func provideResolver() -> AppResolver
    func provideAPIClient() -> APIClient
}

final class AppResolverImpl: AppResolver {
    private let apiClient: APIClient = APIClient()
    
    func provideResolver() -> AppResolver {
        return self
    }
    
    func provideAPIClient() -> APIClient{
        return apiClient
    }
}
