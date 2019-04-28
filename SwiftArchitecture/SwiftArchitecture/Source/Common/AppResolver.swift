//
//  AppResolver.swift
//  
//
//  Created by makoto on 2019/04/28.
//

import Foundation
import DIKit

protocol AppResolver: Resolver {
    func provideAPIClient() -> APIClient
}

final class AppResolverImpl: AppResolver {
    let apiClient: APIClient = APIClient()
    
    func provideAPIClient() -> APIClient{
        return apiClient
    }
    
}
