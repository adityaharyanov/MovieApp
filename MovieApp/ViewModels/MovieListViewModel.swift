//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation
import RxSwift
import RxRelay

class MovieListViewModel {
    
    let disposeBag = DisposeBag()
    var repository : MovieRepository
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    var selectedGenre = BehaviorRelay<Genre?>(value: nil)
    var meta = BehaviorRelay<Meta?>(value: nil)
    var movies = BehaviorRelay<[Movie]>(value: [])
    
    init(repository : MovieRepository = MovieRepository()) {
        self.repository = repository
        
//        self.selectedGenre
//            .observeOn(MainScheduler.instance)
//            .filter({ $0 != nil })
//            .flatMap({ self.getMovies(completion: <#T##() -> ()#>, error: <#T##(String) -> ()#>) })
//            .subscribe(onNext: {value in
//                self.get
//            })
    }
    
    func getMovies(error: @escaping (String) -> ()) {
        
        if self.isLoading.value {
            return
        }
        
        let genreId = self.selectedGenre.value?.id ?? 0
        var page = 0
        
        if let meta = self.meta.value {
            page = meta.page + 1
        } else {
            page = 1
        }
        
        self.isLoading.accept(true)
        
        self.repository.getMovies(genreId: genreId, page: page)
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { (meta, data) in
                
                self.meta.accept(meta)
                
                if meta.page == 1 {
                    self.movies.accept(data)
                } else {
                    self.movies.acceptAppending(data)
                }
                
                self.isLoading.accept(false)
            },
            onError: { err in
                error(err.localizedDescription)
                self.isLoading.accept(false)
            }).disposed(by: self.disposeBag)
        
    }
    
}
