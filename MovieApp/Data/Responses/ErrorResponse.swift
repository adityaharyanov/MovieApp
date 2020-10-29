//
//  ErrorResponse.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation

struct ErrorResponse : Error, Codable {
    
    var statusCode : Int
    var statusMessage : String
    var isSuccess : Bool
    
    enum CodingKeys:String, CodingKey {
        
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case isSuccess = "success"
    }
    
}
