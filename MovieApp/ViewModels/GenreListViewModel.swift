//
//  GenreListViewModel.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation
import RxSwift
import RxRelay

class GenreListViewModel {
    
    let disposeBag = DisposeBag()
    var repository : MovieRepository
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    var genres = BehaviorRelay<[Genre]>(value: [])
    
    init(repository : MovieRepository = MovieRepository()) {
        self.repository = repository
    }
    
    func getGenres(error: @escaping (String) -> ()) {
        
        
        self.isLoading.accept(true)
        
        self.repository.getGenres()
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { values in
                
                if let genres = values {
                    self.genres.accept(genres)
                }
                
                self.isLoading.accept(false)
            },
            onError: { err in
                error(err.localizedDescription)
                self.isLoading.accept(false)
            }).disposed(by: self.disposeBag)
    }
}
