//
//  errorModel.swift
//  PopularMovies
//
//  Created by ORIEUX Bastien on 10/3/19.
//  Copyright © 2019 Privalia. All rights reserved.
//

import Foundation

public struct errorModel : Codable {
    var statusCode : Int
    var statusMessage : String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
}
