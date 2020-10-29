//
//  MovieReviewListViewModel.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 29/10/20.
//

import Foundation
import RxSwift
import RxRelay

class MovieReviewListViewModel {
    
    let disposeBag = DisposeBag()
    var repository : MovieRepository
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    var selectedMovie = BehaviorRelay<Movie?>(value: nil)
    var meta = BehaviorRelay<Meta?>(value: nil)
    var reviews = BehaviorRelay<[Review]>(value: [])
    
    init(repository : MovieRepository = MovieRepository()) {
        self.repository = repository
    }
    
    func getReviews(error: @escaping (String) -> ()) {
        
        if self.isLoading.value {
            return
        }
        
        let movieId = self.selectedMovie.value?.id ?? 0
        var page = 0
        
        if let meta = self.meta.value {
            
            if meta.page == meta.totalPages {
                return;
            }
            
            page = meta.page + 1
        } else {
            page = 1
        }
        
        self.isLoading.accept(true)
        
        self.repository.getReviews(movieId: movieId, page: page)
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { (meta, data) in
                
                self.meta.accept(meta)
                
                if meta.page == 1 {
                    self.reviews.accept(data)
                } else {
                    self.reviews.acceptAppending(data)
                }
                
                self.isLoading.accept(false)
            },
            onError: { err in
                error(err.localizedDescription)
                self.isLoading.accept(false)
            }).disposed(by: self.disposeBag)
        
    }
    
}
