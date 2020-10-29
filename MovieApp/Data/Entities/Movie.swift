//
//  Movie.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation

struct Movie {
    
    var id : Int
    var title : String
    var overview : String
    var posterUrl : String
    var releaseDate : Date
    var genres : [String]?
    var voteAvg : Double
    var voteCount : Int
    var videos : [Video]?
    var displayedreview : Review?
}
