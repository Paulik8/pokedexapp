//
//  ErrorHandler.swift
//  pokedexapp
//
//  Created by Paulik on 08/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import Foundation

struct ErrorHandler {
    
    let baseResponse = "Please try again"
    
    func handleAuthError(error: Error?) -> String {
        guard let code = error?._code else { return baseResponse }
        switch code {
        case 17011:
            return "There is no such user"
        case 17009:
            return "Wrong password"
        default:
            return baseResponse
        }
    }
    
}
