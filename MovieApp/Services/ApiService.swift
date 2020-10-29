//
//  ApiService.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation
import Alamofire
import RxSwift

class ApiService {
        
    private let baseUrl = App.baseUrl
    private let apiKey = App.apiKey
    
    func getGenres() -> Observable<[GenreResponse]?>{
        let urlSegment = "/genre/movie/list?api_key=\(self.apiKey)"
        
        return self.get(type: [String:[GenreResponse]].self, urlSegment: urlSegment)
            .map({
                $0.values.first
            })
    }
    
    func getMovies(genreId: Int, page:Int) -> Observable<MovieListResponse>{
        let urlSegment = "/discover/movie?api_key=\(self.apiKey)&with_genres=\(genreId)&page=\(page)"
        
        return self.get(type: MovieListResponse.self, urlSegment: urlSegment)
    }
    
    func getMovie(movieId: Int) -> Observable<MovieResponse>{
        let urlSegment = "/movie/\(movieId)?api_key=\(self.apiKey)&append_to_response=videos,reviews"
        
        return self.get(type: MovieResponse.self, urlSegment: urlSegment)
    }
    
    func getReviews(movieId: Int, page:Int) -> Observable<ReviewListResponse>{
        let urlSegment = "/movie/\(movieId)/reviews?api_key=\(self.apiKey)&page=\(page)"
        
        return self.get(type: ReviewListResponse.self, urlSegment: urlSegment)
    }
    
    
    private func get<T : Codable>(type : T.Type, urlSegment: String) -> Observable<T> {
        
        let url = "\(self.baseUrl)\(urlSegment)"
        
        return Observable<T>.create { (observer) -> Disposable in
            AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .validate()
                .responseJSON { (response) in
                    
                    let decoder = JSONDecoder()
                    
                    switch response.result {
                    case .success(let result) :
                        do {
                            
                            let result = try decoder.decode(T.self, from: response.data!)
                            observer.onNext(result)
                            observer.onCompleted()
                        } catch (let err) {
                            observer.onError(err)
                        }
                       
                    case .failure(let error):
                        if let responseData = response.data {
                            do {
                                
                                let errorReponse =  try decoder.decode(ErrorResponse.self, from: response.data!)
                                observer.onError(errorReponse)
                            } catch (let err) {
                                observer.onError(err)
                            }
                        }
                        else{
                            observer.onError(error)
                        }
                    }
                }
                return Disposables.create()
        }
    }
}
