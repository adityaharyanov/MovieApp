//
//  ReviewResponse.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation

struct ReviewResponse : Codable {
    
    var id : String
    var author : String
    var content : String
    var url : String
    
    func toEntity() -> Review {
        return Review(id: id, author: author, content: content, url: url)
    }
    
}
