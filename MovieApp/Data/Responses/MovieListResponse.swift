//
//  Response.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation

class MovieListResponse : Codable {
    
    var page : Int
    var totalResults : Int
    var totalPages : Int
    var results : [MovieResponse]
    
    enum CodingKeys :String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
    
    func toEntity() -> (Meta, [Movie]) {
        
        let meta = Meta(page: page, totalResults: totalResults, totalPages: totalPages)
        let data = results.map({ $0.toEntity() })
        
        return (meta, data)
    }
    
}
