//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation
import RxSwift
import RxRelay

class MovieDetailViewModel {
    
    
    let disposeBag = DisposeBag()
    var repository : MovieRepository
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    var movie : Movie?
    
    var posterUrl = BehaviorRelay<String>(value: "")
    var title = BehaviorRelay<String>(value: "")
    var releaseDate = BehaviorRelay<String>(value: "")
    var rateAvg = BehaviorRelay<String>(value: "")
    var rateTotal = BehaviorRelay<String>(value: "")
    var overview = BehaviorRelay<String>(value: "")
    var displayedReviewContent = BehaviorRelay<String>(value: "")
    var displayedReviewAuthor = BehaviorRelay<String>(value: "")
    
    var genres = BehaviorRelay<[String]>(value: [])
    
    var trailerVideos = BehaviorRelay<[Video]>(value: [])
    
    
    
    init(repository : MovieRepository = MovieRepository()) {
        self.repository = repository
    }
    
    func getMovie(error: @escaping (String) -> ()) {
        
        let movieId = self.movie?.id ?? 0
        
        self.isLoading.accept(true)
        
        self.repository.getMovie(movieId: movieId)
            .observeOn(MainScheduler.instance)
            .subscribe( onNext: { data in
                
                self.posterUrl.accept(data!.posterUrl)
                self.title.accept(data!.title)
                self.releaseDate.accept(data!.releaseDate.getDate(customFormat: "dd MMMM yyyy")!)
                self.rateAvg.accept("\(String(describing: data!.voteAvg))/10")
                self.rateTotal.accept(String(describing: data!.voteCount))
                self.overview.accept(data!.overview)
                self.displayedReviewContent.accept(data!.displayedreview?.content ?? "")
                self.displayedReviewAuthor.accept(data!.displayedreview?.author ?? "")
                
                self.genres.accept(data!.genres!)
                
                self.trailerVideos.accept(data!.videos!)
                self.isLoading.accept(false)
            },
            onError: { err in
                error(err.localizedDescription)
                self.isLoading.accept(false)
            }).disposed(by: self.disposeBag)
        
    }
}
