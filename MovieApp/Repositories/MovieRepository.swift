//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation
import RxSwift

class MovieRepository {
    
    var apiService : ApiService
    
    init(apiService : ApiService = ApiService()) {
        self.apiService = apiService
    }
    
    func getGenres() -> Observable<[Genre]?> {
        
        return apiService.getGenres()
            .map({
                $0.map({
                    $0.map({ $0.toEntity() })
                })
            })
        
    }
    
    func getMovies(genreId:Int, page: Int) -> Observable<(Meta, [Movie])> {
        
        return apiService.getMovies(genreId: genreId, page: page)
            .map({
                $0.toEntity()
            })
    }
    
    func getMovie(movieId:Int) -> Observable<Movie?> {
        
        return apiService.getMovie(movieId: movieId)
            .map({ $0.toEntity() })
    }
    
    func getReviews(movieId:Int, page: Int) -> Observable<(Meta, [Review])> {
        
        return apiService.getReviews(movieId: movieId, page: page)
            .map({ $0.toEntity() })
    }
    
}

