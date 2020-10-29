//
//  GenreResponse.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation

struct GenreResponse : Codable {
    
    var id : Int
    var name : String
    
    func toEntity() -> Genre {
        
        return Genre(id: id, name: name)
    }
}
